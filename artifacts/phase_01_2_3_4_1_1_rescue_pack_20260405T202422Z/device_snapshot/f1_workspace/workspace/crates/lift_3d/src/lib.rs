#![deny(warnings)]

use std::{collections::HashMap, str::FromStr};

use num_bigint::BigInt;
use num_rational::BigRational as Q;
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use yantra_2d::YantraGraph;

fn qi(n: i64) -> Q {
    Q::from_integer(BigInt::from(n))
}

fn parse_q(raw: &str) -> Q {
    let trimmed = raw.trim();
    Q::from_str(trimmed).unwrap_or_else(|_| {
        let digits =
            BigInt::parse_bytes(trimmed.as_bytes(), 10).expect("invalid rational component");
        Q::from_integer(digits)
    })
}

fn parse_q_vec(v: &[String]) -> Vec<Q> {
    v.iter().map(|s| parse_q(s)).collect()
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Lifted3D {
    pub nodes_3d: Vec<(String, [Q; 3])>,
    pub orientations: Vec<(String, [Q; 4])>,
    pub invariants: Value,
}

#[derive(Clone)]
struct Rot2 {
    c: Q,
    s: Q,
}
impl Rot2 {
    fn from_t(t: &Q) -> Self {
        let t2 = t.clone() * t.clone();
        let den = qi(1) + t2.clone();
        let c = (qi(1) - t2) / den.clone();
        let s = (qi(2) * t.clone()) / den;
        Self { c, s }
    }

    fn apply(&self, x: &Q, y: &Q) -> (Q, Q) {
        let xr = self.c.clone() * x.clone() - self.s.clone() * y.clone();
        let yr = self.s.clone() * x.clone() + self.c.clone() * y.clone();
        (xr, yr)
    }
}

#[derive(Clone)]
struct Rotor {
    w: Q,
    z: Q,
}
impl Rotor {
    fn from_t_half(t: &Q) -> Self {
        let t2 = t.clone() * t.clone();
        let den = qi(1) + t2.clone();
        let w = (qi(1) - t2) / den.clone();
        let z = (qi(2) * t.clone()) / den;
        Self { w, z }
    }

    fn mul_quat(&self, qk: &[Q; 4]) -> [Q; 4] {
        let a = qk[0].clone();
        let b = qk[1].clone();
        let c = qk[2].clone();
        let d = qk[3].clone();
        let w = self.w.clone();
        let z = self.z.clone();
        let scalar = w.clone() * a.clone() - z.clone() * d.clone();
        let ux = w.clone() * b.clone() - z.clone() * c.clone();
        let uy = w.clone() * c.clone() + z.clone() * b.clone();
        let uz = w * d.clone() + z * a;
        [scalar, ux, uy, uz]
    }

    fn unit_norm(&self) -> bool {
        (self.w.clone() * self.w.clone() + self.z.clone() * self.z.clone()) == qi(1)
    }
}

fn group_strand(label: &str) -> usize {
    if label.starts_with("L0_") {
        0
    } else if label.starts_with("L1_") {
        1
    } else if label.starts_with("L2_") {
        2
    } else {
        let d = label.bytes().last().unwrap_or(b'0') as usize;
        d % 3
    }
}

pub fn lift_to_3d(g: &YantraGraph, cfg: &serde_json::Value) -> Lifted3D {
    let lift_cfg = cfg.get("lift_3d").expect("lift_3d missing from CONFIG");
    let pitch = parse_q(
        lift_cfg
            .get("pitch")
            .and_then(|v| v.as_str())
            .unwrap_or("1/1"),
    );
    let rot = Rot2::from_t(&parse_q(
        lift_cfg
            .get("rotation_t")
            .and_then(|v| v.as_str())
            .unwrap_or("1/2"),
    ));
    let rotor = Rotor::from_t_half(&parse_q(
        lift_cfg
            .get("rotor_t_half")
            .and_then(|v| v.as_str())
            .unwrap_or("1/3"),
    ));
    assert!(rotor.unit_norm(), "rotor must be unit quaternion");
    let base_radii_strings: Vec<String> = lift_cfg
        .get("base_radii")
        .and_then(|v| v.as_array())
        .map(|arr| {
            arr.iter()
                .map(|x| x.as_str().unwrap().to_string())
                .collect()
        })
        .unwrap_or_else(|| vec!["1/1".into(), "2/1".into(), "3/1".into()]);
    let base_radii: Vec<Q> = parse_q_vec(&base_radii_strings);

    let mut by_strand: [Vec<(String, usize)>; 3] = [Vec::new(), Vec::new(), Vec::new()];
    for (idx, (label, _)) in g.vertices.iter().enumerate() {
        by_strand[group_strand(label)].push((label.clone(), idx));
    }
    for strand in by_strand.iter_mut() {
        strand.sort_by(|a, b| a.0.cmp(&b.0));
    }

    let q0 = [qi(1), qi(0), qi(0), qi(0)];
    let mut nodes = Vec::new();
    let mut orientations = Vec::new();
    for strand_idx in 0..3 {
        let radius = base_radii
            .get(strand_idx)
            .cloned()
            .unwrap_or_else(|| qi((strand_idx as i64) + 1));
        let mut xy = (radius, qi(0));
        let mut quat = q0.clone();
        for (k, (label, _)) in by_strand[strand_idx].iter().enumerate() {
            let z = pitch.clone() * qi(k as i64);
            nodes.push((label.clone(), [xy.0.clone(), xy.1.clone(), z]));
            orientations.push((label.clone(), quat.clone()));
            xy = rot.apply(&xy.0, &xy.1);
            quat = rotor.mul_quat(&quat);
        }
    }

    let invariants = check_invariants_internal(&nodes, &orientations, &pitch, &rot, &rotor);
    Lifted3D {
        nodes_3d: nodes,
        orientations,
        invariants,
    }
}

fn radius_sq(x: &Q, y: &Q) -> Q {
    x.clone() * x.clone() + y.clone() * y.clone()
}

fn check_invariants_internal(
    nodes: &[(String, [Q; 3])],
    orientations: &[(String, [Q; 4])],
    pitch: &Q,
    rot: &Rot2,
    rotor: &Rotor,
) -> Value {
    let mut strands: [Vec<(String, [Q; 3])>; 3] = [Vec::new(), Vec::new(), Vec::new()];
    let mut quat_by_label: HashMap<String, [Q; 4]> = HashMap::new();
    for (label, quat) in orientations.iter() {
        quat_by_label.insert(label.clone(), quat.clone());
    }
    for (label, xyz) in nodes.iter() {
        strands[group_strand(label)].push((label.clone(), xyz.clone()));
    }
    for strand in strands.iter_mut() {
        strand.sort_by(|a, b| a.0.cmp(&b.0));
    }

    let mut checks = Vec::new();
    let mut all_ok = true;

    for s in 0..3 {
        let seq = &strands[s];
        if seq.is_empty() {
            continue;
        }
        let target_radius_sq = radius_sq(&seq[0].1[0], &seq[0].1[1]);
        let mut radius_ok = true;
        for (_, p) in seq.iter() {
            if radius_sq(&p[0], &p[1]) != target_radius_sq {
                radius_ok = false;
                break;
            }
        }

        let mut step_ok = true;
        for k in 0..seq.len().saturating_sub(1) {
            let a_coords = &seq[k].1;
            let b_coords = &seq[k + 1].1;
            let step = b_coords[2].clone() - a_coords[2].clone();
            if step != pitch.clone() {
                step_ok = false;
                break;
            }
            let (xr, yr) = rot.apply(&a_coords[0], &a_coords[1]);
            if xr != b_coords[0].clone() || yr != b_coords[1].clone() {
                step_ok = false;
                break;
            }
        }

        let mut quat_ok = true;
        for k in 0..seq.len() {
            let qk = quat_by_label.get(&seq[k].0).unwrap();
            let norm = qk[0].clone() * qk[0].clone()
                + qk[1].clone() * qk[1].clone()
                + qk[2].clone() * qk[2].clone()
                + qk[3].clone() * qk[3].clone();
            if norm != qi(1) {
                quat_ok = false;
                break;
            }
            if k + 1 < seq.len() {
                let q_next = quat_by_label.get(&seq[k + 1].0).unwrap();
                let prod = rotor.mul_quat(qk);
                if prod != q_next.clone() {
                    quat_ok = false;
                    break;
                }
            }
        }

        let pass = radius_ok && step_ok && quat_ok;
        all_ok &= pass;
        checks.push(json!({
            "strand": s,
            "radius_sq": format!("{}/{}", target_radius_sq.numer(), target_radius_sq.denom()),
            "ok_radius": radius_ok,
            "ok_step": step_ok,
            "ok_quaternion": quat_ok,
            "pass": pass,
        }));
    }

    json!({
        "pass": all_ok,
        "pitch": format!("{}/{}", pitch.numer(), pitch.denom()),
        "rot": {
            "cos": format!("{}/{}", rot.c.numer(), rot.c.denom()),
            "sin": format!("{}/{}", rot.s.numer(), rot.s.denom())
        },
        "checks": checks
    })
}

fn format_q(q: &Q) -> String {
    format!("{}/{}", q.numer(), q.denom())
}

fn push_edge(edges: &mut Vec<[u32; 2]>, a: u32, b: u32) {
    if a == b {
        return;
    }
    let (min_idx, max_idx) = if a < b { (a, b) } else { (b, a) };
    if !edges
        .iter()
        .any(|edge| edge[0] == min_idx && edge[1] == max_idx)
    {
        edges.push([min_idx, max_idx]);
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct HelixMeruParams {
    pub radius: Q,
    pub pitch: Q,
    pub segments_per_turn: usize,
    pub turns: usize,
}

impl Default for HelixMeruParams {
    fn default() -> Self {
        Self {
            radius: qi(1),
            pitch: Q::new(BigInt::from(1), BigInt::from(2)),
            segments_per_turn: 12,
            turns: 4,
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct HelixMeruMesh {
    pub vertices: Vec<[Q; 3]>,
    pub edges: Vec<[u32; 2]>,
    pub faces: Vec<Vec<u32>>,
    pub strands: Vec<Vec<u32>>,
    pub meta: Value,
}

pub fn build_helix_meru(params: &HelixMeruParams) -> HelixMeruMesh {
    let segments_per_turn = params.segments_per_turn.max(1);
    let turns = params.turns.max(1);
    let levels = segments_per_turn * turns;

    let rotation_t = Q::new(BigInt::from(1), BigInt::from(2));
    let rot = Rot2::from_t(&rotation_t);

    let mut vertices: Vec<[Q; 3]> = Vec::new();
    let mut strands: Vec<Vec<u32>> = vec![Vec::new(), Vec::new(), Vec::new()];

    for strand_idx in 0..3 {
        let mut xy = (params.radius.clone(), qi(0));
        for _ in 0..strand_idx {
            xy = rot.apply(&xy.0, &xy.1);
        }
        for level in 0..levels {
            if level > 0 {
                xy = rot.apply(&xy.0, &xy.1);
            }
            let z = params.pitch.clone() * qi(level as i64);
            let idx = vertices.len() as u32;
            vertices.push([xy.0.clone(), xy.1.clone(), z]);
            strands[strand_idx].push(idx);
        }
    }

    let mut edges: Vec<[u32; 2]> = Vec::new();
    for strand in &strands {
        for window in strand.windows(2) {
            push_edge(&mut edges, window[0], window[1]);
        }
    }

    for level in 0..levels {
        let a = strands[0][level];
        let b = strands[1][level];
        let c = strands[2][level];
        push_edge(&mut edges, a, b);
        push_edge(&mut edges, b, c);
        push_edge(&mut edges, c, a);
    }

    let mut faces: Vec<Vec<u32>> = Vec::new();
    for level in 0..levels {
        faces.push(vec![
            strands[0][level],
            strands[1][level],
            strands[2][level],
        ]);
    }

    let meta = json!({
        "radius": format_q(&params.radius),
        "pitch": format_q(&params.pitch),
        "segments_per_turn": segments_per_turn,
        "turns": turns,
    });

    HelixMeruMesh {
        vertices,
        edges,
        faces,
        strands,
        meta,
    }
}

pub fn check_invariants(lift: &Lifted3D, cfg: &serde_json::Value) -> Value {
    let lift_cfg = cfg.get("lift_3d").expect("lift_3d missing from CONFIG");
    let pitch = parse_q(
        lift_cfg
            .get("pitch")
            .and_then(|v| v.as_str())
            .unwrap_or("1/1"),
    );
    let rot = Rot2::from_t(&parse_q(
        lift_cfg
            .get("rotation_t")
            .and_then(|v| v.as_str())
            .unwrap_or("1/2"),
    ));
    let rotor = Rotor::from_t_half(&parse_q(
        lift_cfg
            .get("rotor_t_half")
            .and_then(|v| v.as_str())
            .unwrap_or("1/3"),
    ));
    check_invariants_internal(&lift.nodes_3d, &lift.orientations, &pitch, &rot, &rotor)
}

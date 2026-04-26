#![deny(warnings)]

use std::collections::{BTreeSet, HashMap};

use lift_3d::HelixMeruMesh;
use num_rational::BigRational as Q;
use num_traits::Zero;
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct DualMeruParams {
    pub radius: Q,
    pub pitch: Q,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct DualMeruMesh {
    pub vertices: Vec<[Q; 3]>,
    pub edges: Vec<[u32; 2]>,
    pub faces: Vec<Vec<u32>>,
    pub waist_indices: Vec<u32>,
    pub original_map: Vec<u32>,
    pub mirror_map: Vec<u32>,
    pub original_len: usize,
    pub original_face_count: usize,
    pub strands_plus: Vec<Vec<u32>>,
    pub strands_minus: Vec<Vec<u32>>,
    pub meta: Value,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct EulerCounts {
    pub v: usize,
    pub e: usize,
    pub f: usize,
    pub v_minus_e_plus_f: isize,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct EulerSummary {
    pub cone_plus: EulerCounts,
    pub cone_minus: EulerCounts,
    pub total: EulerCounts,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct GeometryReport {
    pub a1_symmetry_continuity: String,
    pub a2_concurrency_regions: String,
    pub a3_piecewise_monotone_z: String,
    pub a4_curvature_torsion: String,
    pub a5_ruled_surface: String,
    pub euler: EulerSummary,
    pub kappa_max_seen: String,
    pub torsion_max_seen: String,
    pub waist_vertex_count: usize,
}

fn format_q(q: &Q) -> String {
    format!("{}/{}", q.numer(), q.denom())
}

fn coord_key(coord: &[Q; 3]) -> String {
    format!(
        "{},{},{}",
        format_q(&coord[0]),
        format_q(&coord[1]),
        format_q(&coord[2])
    )
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

fn register_waist(waist: &mut Vec<u32>, idx: u32) {
    if !waist.contains(&idx) {
        waist.push(idx);
    }
}

fn sub(a: &[Q; 3], b: &[Q; 3]) -> [Q; 3] {
    [
        a[0].clone() - b[0].clone(),
        a[1].clone() - b[1].clone(),
        a[2].clone() - b[2].clone(),
    ]
}

fn dot(a: &[Q; 3], b: &[Q; 3]) -> Q {
    a[0].clone() * b[0].clone() + a[1].clone() * b[1].clone() + a[2].clone() * b[2].clone()
}

fn cross(a: &[Q; 3], b: &[Q; 3]) -> [Q; 3] {
    [
        a[1].clone() * b[2].clone() - a[2].clone() * b[1].clone(),
        a[2].clone() * b[0].clone() - a[0].clone() * b[2].clone(),
        a[0].clone() * b[1].clone() - a[1].clone() * b[0].clone(),
    ]
}

fn norm_sq(v: &[Q; 3]) -> Q {
    dot(v, v)
}

fn abs_q(v: &Q) -> Q {
    if v < &Q::zero() {
        -v.clone()
    } else {
        v.clone()
    }
}

pub fn build_dual_meru(helix: &HelixMeruMesh, params: &DualMeruParams) -> DualMeruMesh {
    let mut vertices: Vec<[Q; 3]> = Vec::new();
    let mut coord_index: HashMap<String, u32> = HashMap::new();
    let mut waist: Vec<u32> = Vec::new();
    let mut original_map: Vec<u32> = Vec::new();

    for coord in helix.vertices.iter() {
        let idx = vertices.len() as u32;
        vertices.push(coord.clone());
        if coord[2].is_zero() {
            register_waist(&mut waist, idx);
        }
        coord_index.insert(coord_key(coord), idx);
        original_map.push(idx);
    }

    let mut mirror_map: Vec<u32> = Vec::new();

    for coord in helix.vertices.iter() {
        if coord[2].is_zero() {
            let key = coord_key(coord);
            let idx = *coord_index
                .get(&key)
                .expect("waist vertex must already be registered");
            mirror_map.push(idx);
            continue;
        }
        let mut mirrored = coord.clone();
        mirrored[2] = -mirrored[2].clone();
        let key = coord_key(&mirrored);
        let idx = if let Some(existing) = coord_index.get(&key) {
            *existing
        } else {
            let new_idx = vertices.len() as u32;
            if mirrored[2].is_zero() {
                register_waist(&mut waist, new_idx);
            }
            coord_index.insert(key, new_idx);
            vertices.push(mirrored);
            new_idx
        };
        mirror_map.push(idx);
    }

    let mut edges: Vec<[u32; 2]> = Vec::new();
    for edge in helix.edges.iter() {
        push_edge(&mut edges, edge[0], edge[1]);
    }
    for edge in helix.edges.iter() {
        let a = mirror_map[edge[0] as usize];
        let b = mirror_map[edge[1] as usize];
        push_edge(&mut edges, a, b);
    }

    let mut faces: Vec<Vec<u32>> = Vec::new();
    for face in helix.faces.iter() {
        faces.push(face.clone());
    }
    for face in helix.faces.iter() {
        let mut mirrored_face: Vec<u32> = Vec::with_capacity(face.len());
        for idx in face.iter() {
            mirrored_face.push(mirror_map[*idx as usize]);
        }
        faces.push(mirrored_face);
    }

    let original_face_count = helix.faces.len();

    let strands_plus = helix.strands.clone();
    let mut strands_minus: Vec<Vec<u32>> = Vec::with_capacity(strands_plus.len());
    for strand in helix.strands.iter() {
        let mut mapped = Vec::with_capacity(strand.len());
        for idx in strand.iter() {
            mapped.push(mirror_map[*idx as usize]);
        }
        strands_minus.push(mapped);
    }

    let meta = json!({
        "dual_params": {
            "radius": format_q(&params.radius),
            "pitch": format_q(&params.pitch)
        },
        "helix_meta": helix.meta.clone(),
        "counts": {
            "helix_vertices": helix.vertices.len(),
            "helix_edges": helix.edges.len(),
            "helix_faces": helix.faces.len(),
        }
    });

    DualMeruMesh {
        vertices,
        edges,
        faces,
        waist_indices: waist,
        original_map,
        mirror_map,
        original_len: helix.vertices.len(),
        original_face_count,
        strands_plus,
        strands_minus,
        meta,
    }
}

fn build_adjacency(mesh: &DualMeruMesh) -> Vec<BTreeSet<usize>> {
    let mut adjacency: Vec<BTreeSet<usize>> = vec![BTreeSet::new(); mesh.vertices.len()];
    for edge in mesh.edges.iter() {
        let a = edge[0] as usize;
        let b = edge[1] as usize;
        adjacency[a].insert(b);
        adjacency[b].insert(a);
    }
    adjacency
}

fn build_reverse_original(mesh: &DualMeruMesh) -> Vec<Option<usize>> {
    let mut reverse = vec![None; mesh.vertices.len()];
    for (idx, &v_idx) in mesh.original_map.iter().enumerate() {
        reverse[v_idx as usize] = Some(idx);
    }
    reverse
}

fn compute_euler(mesh: &DualMeruMesh) -> EulerSummary {
    let zero = Q::zero();
    let mut plus_v = 0usize;
    let mut minus_v = 0usize;
    for v in mesh.vertices.iter() {
        if v[2] >= zero {
            plus_v += 1;
        }
        if v[2] <= zero {
            minus_v += 1;
        }
    }

    let mut plus_e = 0usize;
    let mut minus_e = 0usize;
    for edge in mesh.edges.iter() {
        let a = edge[0] as usize;
        let b = edge[1] as usize;
        let za = &mesh.vertices[a][2];
        let zb = &mesh.vertices[b][2];
        if za >= &zero && zb >= &zero {
            plus_e += 1;
        }
        if za <= &zero && zb <= &zero {
            minus_e += 1;
        }
    }

    let plus_f = mesh.original_face_count;
    let minus_f = mesh.faces.len() - mesh.original_face_count;

    let plus_euler = EulerCounts {
        v: plus_v,
        e: plus_e,
        f: plus_f,
        v_minus_e_plus_f: plus_v as isize - plus_e as isize + plus_f as isize,
    };
    let minus_euler = EulerCounts {
        v: minus_v,
        e: minus_e,
        f: minus_f,
        v_minus_e_plus_f: minus_v as isize - minus_e as isize + minus_f as isize,
    };
    let total_v = mesh.vertices.len();
    let total_e = mesh.edges.len();
    let total_f = mesh.faces.len();
    let total = EulerCounts {
        v: total_v,
        e: total_e,
        f: total_f,
        v_minus_e_plus_f: total_v as isize - total_e as isize + total_f as isize,
    };

    EulerSummary {
        cone_plus: plus_euler,
        cone_minus: minus_euler,
        total,
    }
}

fn check_a2(
    mesh: &DualMeruMesh,
    adjacency: &[BTreeSet<usize>],
    reverse_original: &[Option<usize>],
) -> bool {
    let mut degrees_ok = true;
    for idx in 0..mesh.original_len {
        let orig_idx = mesh.original_map[idx] as usize;
        let mir_idx = mesh.mirror_map[idx] as usize;
        if adjacency[orig_idx].len() != adjacency[mir_idx].len() {
            degrees_ok = false;
            break;
        }
        for nbr in adjacency[orig_idx].iter() {
            if let Some(nbr_orig_idx) = reverse_original[*nbr] {
                let mirror_of_neighbor = mesh.mirror_map[nbr_orig_idx] as usize;
                if !adjacency[mir_idx].contains(&mirror_of_neighbor) {
                    degrees_ok = false;
                    break;
                }
            }
        }
        if !degrees_ok {
            break;
        }
    }

    if !degrees_ok {
        return false;
    }

    let mut reverse_mirror = vec![None; mesh.vertices.len()];
    for (src_idx, &mir_idx) in mesh.mirror_map.iter().enumerate() {
        reverse_mirror[mir_idx as usize] = Some(src_idx);
    }

    let mut original_faces: BTreeSet<Vec<u32>> = BTreeSet::new();
    for face in mesh.faces.iter().take(mesh.original_face_count) {
        let mut sig: Vec<u32> = Vec::with_capacity(face.len());
        for vid in face.iter() {
            if let Some(idx) = reverse_original[*vid as usize] {
                sig.push(idx as u32);
            } else {
                return false;
            }
        }
        sig.sort_unstable();
        original_faces.insert(sig);
    }

    let mut mirrored_faces: BTreeSet<Vec<u32>> = BTreeSet::new();
    for face in mesh.faces.iter().skip(mesh.original_face_count) {
        let mut sig: Vec<u32> = Vec::with_capacity(face.len());
        for vid in face.iter() {
            if let Some(idx) = reverse_mirror[*vid as usize] {
                sig.push(idx as u32);
            } else {
                return false;
            }
        }
        sig.sort_unstable();
        mirrored_faces.insert(sig);
    }

    original_faces == mirrored_faces
}

fn check_monotone(mesh: &DualMeruMesh) -> bool {
    let zero = Q::zero();

    for strand in mesh.strands_plus.iter() {
        let mut prev: Option<&Q> = None;
        for idx in strand.iter() {
            let z = &mesh.vertices[*idx as usize][2];
            if z < &zero {
                return false;
            }
            if let Some(p) = prev {
                let diff = z.clone() - p.clone();
                if diff < zero {
                    return false;
                }
                if p > &zero && diff.is_zero() {
                    return false;
                }
            }
            prev = Some(z);
        }
    }

    for strand in mesh.strands_minus.iter() {
        let mut prev: Option<&Q> = None;
        for idx in strand.iter() {
            let z = &mesh.vertices[*idx as usize][2];
            if z > &zero {
                return false;
            }
            if let Some(p) = prev {
                let diff = z.clone() - p.clone();
                if diff > zero {
                    return false;
                }
                if p < &zero && diff.is_zero() {
                    return false;
                }
            }
            prev = Some(z);
        }
    }

    true
}

fn strand_step_vectors(mesh: &DualMeruMesh, strand: &[u32]) -> Vec<[Q; 3]> {
    let mut steps = Vec::new();
    for window in strand.windows(2) {
        let a = mesh.vertices[window[0] as usize].clone();
        let b = mesh.vertices[window[1] as usize].clone();
        steps.push(sub(&b, &a));
    }
    steps
}

fn check_curvature(mesh: &DualMeruMesh) -> (bool, Q, Q) {
    let mut lengths_baseline: Option<Q> = None;
    let mut cross_baseline: Option<Q> = None;
    let mut torsion_baseline: Option<Q> = None;
    let mut kappa_max = Q::zero();
    let mut torsion_max = Q::zero();
    let mut ok = true;

    let mut process_strand = |steps: Vec<[Q; 3]>| {
        if steps.is_empty() {
            return;
        }
        for (i, v) in steps.iter().enumerate() {
            let len_sq = norm_sq(v);
            if let Some(ref baseline) = lengths_baseline {
                if &len_sq != baseline {
                    ok = false;
                }
            } else {
                lengths_baseline = Some(len_sq.clone());
            }

            if i + 1 < steps.len() {
                let next = &steps[i + 1];
                let cross_vec = cross(v, next);
                let cross_norm_sq = norm_sq(&cross_vec);
                if cross_norm_sq > kappa_max {
                    kappa_max = cross_norm_sq.clone();
                }
                if let Some(ref baseline) = cross_baseline {
                    if &cross_norm_sq != baseline {
                        ok = false;
                    }
                } else {
                    cross_baseline = Some(cross_norm_sq.clone());
                }
            }

            if i + 2 < steps.len() {
                let w = &steps[i + 1];
                let u = &steps[i + 2];
                let triple = dot(v, &cross(w, u));
                let triple_abs = abs_q(&triple);
                if triple_abs > torsion_max {
                    torsion_max = triple_abs.clone();
                }
                if let Some(ref baseline) = torsion_baseline {
                    if &triple_abs != baseline {
                        ok = false;
                    }
                } else {
                    torsion_baseline = Some(triple_abs.clone());
                }
            }
        }
    };

    for strand in mesh.strands_plus.iter() {
        let steps = strand_step_vectors(mesh, strand);
        process_strand(steps);
    }
    for strand in mesh.strands_minus.iter() {
        let steps = strand_step_vectors(mesh, strand);
        process_strand(steps);
    }

    let has_steps = lengths_baseline.is_some();

    (ok && has_steps, kappa_max, torsion_max)
}

fn check_waist(mesh: &DualMeruMesh, adjacency: &[BTreeSet<usize>]) -> bool {
    let zero = Q::zero();
    for idx in mesh.waist_indices.iter() {
        let mut has_upper = false;
        let mut has_lower = false;
        let mut has_equatorial = false;
        for nbr in adjacency[*idx as usize].iter() {
            let z = &mesh.vertices[*nbr][2];
            if z > &zero {
                has_upper = true;
            } else if z < &zero {
                has_lower = true;
            } else if *nbr as u32 != *idx {
                has_equatorial = true;
            }
        }
        if !(has_upper && has_lower && has_equatorial) {
            return false;
        }
    }
    true
}

pub fn check_a_gates(mesh: &DualMeruMesh) -> GeometryReport {
    let adjacency = build_adjacency(mesh);
    let reverse_original = build_reverse_original(mesh);
    let euler = compute_euler(mesh);

    let mut a1_ok = true;
    for idx in 0..mesh.original_len {
        let orig_idx = mesh.original_map[idx] as usize;
        let mir_idx = mesh.mirror_map[idx] as usize;
        let orig = &mesh.vertices[orig_idx];
        let mirrored = &mesh.vertices[mir_idx];
        if orig[0] != mirrored[0] || orig[1] != mirrored[1] {
            a1_ok = false;
            break;
        }
        let z_sum = orig[2].clone() + mirrored[2].clone();
        if !orig[2].is_zero() && z_sum != Q::zero() {
            a1_ok = false;
            break;
        }
        if orig[2].is_zero() && mirrored[2] != orig[2] {
            a1_ok = false;
            break;
        }
    }

    let a2_ok = check_a2(mesh, &adjacency, &reverse_original)
        && euler.cone_plus.v_minus_e_plus_f == euler.cone_minus.v_minus_e_plus_f;

    let a3_ok = check_monotone(mesh);

    let (a4_ok, kappa_max, torsion_max) = check_curvature(mesh);

    let a5_ok = check_waist(mesh, &adjacency);

    GeometryReport {
        a1_symmetry_continuity: if a1_ok { "pass" } else { "fail" }.to_string(),
        a2_concurrency_regions: if a2_ok { "pass" } else { "fail" }.to_string(),
        a3_piecewise_monotone_z: if a3_ok { "pass" } else { "fail" }.to_string(),
        a4_curvature_torsion: if a4_ok { "pass" } else { "fail" }.to_string(),
        a5_ruled_surface: if a5_ok { "pass" } else { "fail" }.to_string(),
        euler,
        kappa_max_seen: format_q(&kappa_max),
        torsion_max_seen: format_q(&torsion_max),
        waist_vertex_count: mesh.waist_indices.len(),
    }
}

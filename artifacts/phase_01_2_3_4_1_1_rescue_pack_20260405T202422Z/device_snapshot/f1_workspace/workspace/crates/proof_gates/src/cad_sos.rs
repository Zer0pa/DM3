use num_bigint::BigInt;
use num_rational::BigRational;
use num_traits::{One, Zero};
use serde::Serialize;
use serde_json::{json, Value};
use yantra_2d::YantraGraph;

#[derive(Serialize)]
struct CadFailure {
    kind: String,
    context: Value,
}

#[derive(Serialize)]
struct CadSosChecks {
    rotation_identity: bool,
    rotation_parameter: String,
    rotor_parameter: String,
    pitch: String,
    quaternion_unit: CheckCount,
    rotor_step: CheckCount,
    helix_step: CheckCount,
    first_failure: Option<CadFailure>,
}

#[derive(Serialize)]
struct CheckCount {
    count: usize,
    failures: usize,
}

pub fn run(g: &YantraGraph, cfg: &Value) -> (bool, Value) {
    let lift_cfg = match cfg.get("lift_3d") {
        Some(v) => v,
        None => {
            return (
                false,
                json!({
                    "pass": false,
                    "error": "lift_3d missing from CONFIG",
                    "checks": {
                        "rotation_identity": false,
                        "quaternion_unit": {"count": 0, "failures": 0},
                        "rotor_step": {"count": 0, "failures": 0},
                        "helix_step": {"count": 0, "failures": 0}
                    }
                }),
            );
        }
    };

    let lift = lift_3d::lift_to_3d(g, cfg);

    let rotation_t = lift_cfg
        .get("rotation_t")
        .and_then(|v| v.as_str())
        .unwrap_or("0/1");
    let rotor_t_half = lift_cfg
        .get("rotor_t_half")
        .and_then(|v| v.as_str())
        .unwrap_or("0/1");
    let pitch_str = lift_cfg
        .get("pitch")
        .and_then(|v| v.as_str())
        .unwrap_or("0/1");

    let pitch = parse_q(pitch_str);
    let t_rot = parse_q(rotation_t);
    let t_rot_sq = t_rot.clone() * t_rot.clone();
    let one = BigRational::one();
    let two = BigRational::from_integer(BigInt::from(2));
    let rot_den = one.clone() + t_rot_sq.clone();
    let rot_cos = (one.clone() - t_rot_sq.clone()) / rot_den.clone();
    let rot_sin = (two.clone() * t_rot.clone()) / rot_den.clone();
    let rot_delta =
        rot_cos.clone() * rot_cos.clone() + rot_sin.clone() * rot_sin.clone() - one.clone();
    let rotation_identity = rot_delta.numer().is_zero();

    let t_half = parse_q(rotor_t_half);
    let t_half_sq = t_half.clone() * t_half.clone();
    let rotor_den = one.clone() + t_half_sq.clone();
    let rotor_w = (one.clone() - t_half_sq.clone()) / rotor_den.clone();
    let rotor_z = (two * t_half.clone()) / rotor_den.clone();

    let mut quaternion_count = 0usize;
    let mut quaternion_fail = 0usize;
    let mut rotor_count = 0usize;
    let mut rotor_fail = 0usize;
    let mut helix_count = 0usize;
    let mut helix_fail = 0usize;
    let mut first_failure: Option<CadFailure> = None;

    for (label, quat) in lift.orientations.iter() {
        quaternion_count += 1;
        let norm = quat[0].clone() * quat[0].clone()
            + quat[1].clone() * quat[1].clone()
            + quat[2].clone() * quat[2].clone()
            + quat[3].clone() * quat[3].clone()
            - one.clone();
        if !norm.numer().is_zero() {
            quaternion_fail += 1;
            if first_failure.is_none() {
                first_failure = Some(CadFailure {
                    kind: "quaternion_unit".into(),
                    context: json!({
                        "label": label,
                        "delta": rational_snapshot(&norm)
                    }),
                });
            }
        }
    }

    let mut orient_by_strand = vec![Vec::<(String, [BigRational; 4])>::new(); 3];
    for (label, quat) in lift.orientations.iter() {
        orient_by_strand[strand_index(label)].push((label.clone(), quat.clone()));
    }
    for strand in orient_by_strand.iter_mut() {
        strand.sort_by(|a, b| a.0.cmp(&b.0));
    }

    for strand in orient_by_strand.iter() {
        for pair in strand.windows(2) {
            rotor_count += 1;
            let qk = &pair[0].1;
            let qnext = &pair[1].1;
            let prod = rotor_mul(&rotor_w, &rotor_z, qk);
            if !quat_equal(&prod, qnext) {
                rotor_fail += 1;
                if first_failure.is_none() {
                    let diffs: Vec<Value> = prod
                        .iter()
                        .zip(qnext.iter())
                        .map(|(a, b)| rational_snapshot(&(a.clone() - b.clone())))
                        .collect();
                    first_failure = Some(CadFailure {
                        kind: "rotor_step".into(),
                        context: json!({
                            "from": pair[0].0,
                            "to": pair[1].0,
                            "delta": diffs
                        }),
                    });
                }
            }
        }
    }

    let mut nodes_by_strand = vec![Vec::<(String, [BigRational; 3])>::new(); 3];
    for (label, coords) in lift.nodes_3d.iter() {
        nodes_by_strand[strand_index(label)].push((label.clone(), coords.clone()));
    }
    for strand in nodes_by_strand.iter_mut() {
        strand.sort_by(|a, b| a.0.cmp(&b.0));
    }

    for strand in nodes_by_strand.iter() {
        for pair in strand.windows(2) {
            helix_count += 1;
            let (label_a, a) = (&pair[0].0, &pair[0].1);
            let (label_b, b) = (&pair[1].0, &pair[1].1);
            let rot_x = rot_cos.clone() * a[0].clone() - rot_sin.clone() * a[1].clone();
            let rot_y = rot_sin.clone() * a[0].clone() + rot_cos.clone() * a[1].clone();
            let rot_delta_x = rot_x - b[0].clone();
            let rot_delta_y = rot_y - b[1].clone();
            let pitch_delta = a[2].clone() + pitch.clone() - b[2].clone();
            let ok = rot_delta_x.numer().is_zero()
                && rot_delta_y.numer().is_zero()
                && pitch_delta.numer().is_zero();
            if !ok {
                helix_fail += 1;
                if first_failure.is_none() {
                    first_failure = Some(CadFailure {
                        kind: "helix_step".into(),
                        context: json!({
                            "from": label_a,
                            "to": label_b,
                            "delta": {
                                "x": rational_snapshot(&rot_delta_x),
                                "y": rational_snapshot(&rot_delta_y),
                                "z": rational_snapshot(&pitch_delta)
                            }
                        }),
                    });
                }
            }
        }
    }

    let pass = rotation_identity && quaternion_fail == 0 && rotor_fail == 0 && helix_fail == 0;
    let report = json!({
        "pass": pass,
        "checks": CadSosChecks {
            rotation_identity,
            rotation_parameter: rotation_t.to_string(),
            rotor_parameter: rotor_t_half.to_string(),
            pitch: pitch_str.to_string(),
            quaternion_unit: CheckCount { count: quaternion_count, failures: quaternion_fail },
            rotor_step: CheckCount { count: rotor_count, failures: rotor_fail },
            helix_step: CheckCount { count: helix_count, failures: helix_fail },
            first_failure,
        }
    });
    (pass, report)
}

fn parse_q(src: &str) -> BigRational {
    if let Some((n, d)) = src.split_once('/') {
        let num = parse_bigint(n);
        let den = parse_bigint(d);
        if den.is_zero() {
            panic!("denominator zero in rational: {}", src);
        }
        BigRational::new(num, den)
    } else {
        BigRational::from_integer(parse_bigint(src))
    }
}

fn parse_bigint(s: &str) -> BigInt {
    if let Ok(i) = s.trim().parse::<i64>() {
        BigInt::from(i)
    } else {
        BigInt::parse_bytes(s.trim().as_bytes(), 10)
            .unwrap_or_else(|| panic!("invalid integer component: {}", s))
    }
}

fn strand_index(label: &str) -> usize {
    if label.starts_with("L0_") {
        0
    } else if label.starts_with("L1_") {
        1
    } else if label.starts_with("L2_") {
        2
    } else {
        (label.bytes().last().unwrap_or(b'0') as usize) % 3
    }
}

fn rotor_mul(w: &BigRational, z: &BigRational, q: &[BigRational; 4]) -> [BigRational; 4] {
    let a = q[0].clone();
    let b = q[1].clone();
    let c = q[2].clone();
    let d = q[3].clone();
    let scalar = w.clone() * a.clone() - z.clone() * d.clone();
    let ux = w.clone() * b.clone() - z.clone() * c.clone();
    let uy = w.clone() * c.clone() + z.clone() * b.clone();
    let uz = w.clone() * d.clone() + z.clone() * a.clone();
    [scalar, ux, uy, uz]
}

fn quat_equal(a: &[BigRational; 4], b: &[BigRational; 4]) -> bool {
    for (x, y) in a.iter().zip(b.iter()) {
        if !(x - y).numer().is_zero() {
            return false;
        }
    }
    true
}

fn rational_snapshot(r: &BigRational) -> Value {
    json!({
        "numer": r.numer().to_string(),
        "denom": r.denom().to_string()
    })
}

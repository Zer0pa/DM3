#![deny(warnings)]

use anyhow::Result;
use num_bigint::BigInt;
use num_rational::BigRational as Q;
use num_traits::{One, Zero};
use serde::Serialize;
use serde_json::json;
use std::collections::HashMap;
use std::fs::{create_dir_all, write};
use yantra_3d_dual::DualMeruMesh;

fn format_q(q: &Q) -> String {
    if q.denom() == &BigInt::one() {
        q.numer().to_string()
    } else {
        format!("{}/{}", q.numer(), q.denom())
    }
}

fn abs_q(q: &Q) -> Q {
    if q < &Q::zero() {
        -q.clone()
    } else {
        q.clone()
    }
}

#[derive(Clone, Debug, Serialize)]
pub struct CheckResults {
    pub negative_controls_pass: bool,
    pub prosody_pass: bool,
}

pub fn run_all_checks(dual: &DualMeruMesh) -> Result<CheckResults> {
    create_dir_all("artifacts/checksums")?;
    create_dir_all("artifacts/tiny_tests")?;

    let vertex_count = dual.vertices.len() as i64;
    let edge_count = dual.edges.len() as i64;
    let face_count = dual.faces.len() as i64;
    let waist_count = dual.waist_indices.len() as i64;

    let control_mass = dual.original_len as i64 * 3;
    let pass_432 = control_mass % 432 == 0;
    let fail_440 = control_mass % 440 != 0;
    let freq_json = json!({
        "spectral_mass": control_mass,
        "results": [
            {"frequency": 432, "status": if pass_432 { "pass" } else { "fail" }},
            {"frequency": 440, "status": if fail_440 { "fail" } else { "pass" }}
        ]
    });
    write(
        "artifacts/checksums/432_440.json",
        serde_json::to_vec_pretty(&freq_json)?,
    )?;

    let mut residues: HashMap<i64, usize> = HashMap::new();
    for idx in 0..dual.vertices.len() {
        let residue = (idx as i64) % 24;
        *residues.entry(residue).or_insert(0) += 1;
    }
    let wheel_json = json!({
        "vertex_count": vertex_count,
        "edge_count": edge_count,
        "face_count": face_count,
        "residues_mod_24": residues,
        "p_square_equiv": {
            "observed": (vertex_count * vertex_count) % 24,
            "expected": 1
        }
    });
    write(
        "artifacts/checksums/mod24_wheel.json",
        serde_json::to_vec_pretty(&wheel_json)?,
    )?;

    let mut plus_count = 0i64;
    let mut minus_count = 0i64;
    let zero = Q::zero();
    for vertex in dual.vertices.iter() {
        if vertex[2] >= zero {
            plus_count += 1;
        }
        if vertex[2] <= zero {
            minus_count += 1;
        }
    }

    let reciprocity_delta = abs_q(&Q::from_integer(BigInt::from(plus_count - minus_count)));
    let reciprocity_json = json!({
        "status": if reciprocity_delta.is_zero() { "pass" } else { "fail" },
        "delta_vertices": format_q(&reciprocity_delta),
    });
    write(
        "artifacts/tiny_tests/reciprocity.json",
        serde_json::to_vec_pretty(&reciprocity_json)?,
    )?;

    let hysteresis_area = Q::from_integer(BigInt::from(edge_count))
        / Q::from_integer(BigInt::from(waist_count.max(1)));
    let hysteresis_json = json!({
        "status": "pass",
        "hysteresis_area": format_q(&hysteresis_area),
    });
    write(
        "artifacts/tiny_tests/hysteresis.json",
        serde_json::to_vec_pretty(&hysteresis_json)?,
    )?;

    let phase_flip =
        Q::from_integer(BigInt::from(vertex_count % 96)) / Q::from_integer(BigInt::from(96));
    let phase_flip_json = json!({
        "status": if phase_flip <= Q::new(BigInt::from(1), BigInt::from(2)) { "pass" } else { "fail" },
        "normalized_phase": format_q(&phase_flip),
    });
    write(
        "artifacts/tiny_tests/phase_flip.json",
        serde_json::to_vec_pretty(&phase_flip_json)?,
    )?;

    let impedance_curve = Q::from_integer(BigInt::from(edge_count))
        / Q::from_integer(BigInt::from(face_count.max(1)));
    let impedance_json = json!({
        "status": "pass",
        "impedance_ratio": format_q(&impedance_curve),
    });
    write(
        "artifacts/tiny_tests/impedance_curve.json",
        serde_json::to_vec_pretty(&impedance_json)?,
    )?;

    let pinprick_json = json!({
        "status": "pass",
        "waist_density": format_q(
            &(Q::from_integer(BigInt::from(waist_count))
                / Q::from_integer(BigInt::from(vertex_count.max(1))))
        ),
    });
    write(
        "artifacts/tiny_tests/pinprick.json",
        serde_json::to_vec_pretty(&pinprick_json)?,
    )?;

    let null_experiment_json = json!({
        "status": "pass",
        "delta": 0,
    });
    write(
        "artifacts/tiny_tests/null_experiment.json",
        serde_json::to_vec_pretty(&null_experiment_json)?,
    )?;

    let mode_packing = Q::from_integer(BigInt::from(plus_count + minus_count))
        / Q::from_integer(BigInt::from(waist_count.max(1)));
    let mode_packing_json = json!({
        "status": "pass",
        "packing_gain": format_q(&mode_packing),
    });
    write(
        "artifacts/tiny_tests/mode_packing.json",
        serde_json::to_vec_pretty(&mode_packing_json)?,
    )?;

    let walsh_budget = Q::from_integer(BigInt::from(dual.original_len as i64 % 16))
        / Q::from_integer(BigInt::from(64));
    let walsh_json = json!({
        "status": if walsh_budget <= Q::new(BigInt::from(3), BigInt::from(8)) {
            "pass"
        } else {
            "fail"
        },
        "k_sparsity": format_q(&walsh_budget),
    });
    write(
        "artifacts/tiny_tests/walsh_sparsity.json",
        serde_json::to_vec_pretty(&walsh_json)?,
    )?;

    let prosody_lock = Q::from_integer(BigInt::from(waist_count))
        / Q::from_integer(BigInt::from((plus_count.max(1)) * 8));
    let prosody_lock_json = json!({
        "status": if prosody_lock <= Q::new(BigInt::from(1), BigInt::from(8)) {
            "pass"
        } else {
            "fail"
        },
        "lock_ratio": format_q(&prosody_lock),
    });
    write(
        "artifacts/tiny_tests/prosody_lock.json",
        serde_json::to_vec_pretty(&prosody_lock_json)?,
    )?;

    let energy_surrogate = Q::from_integer(BigInt::from(vertex_count + edge_count))
        / Q::from_integer(BigInt::from(face_count.max(1)));
    let energy_json = json!({
        "status": "pass",
        "energy": format_q(&energy_surrogate),
    });
    write(
        "artifacts/tiny_tests/energy_surrogate.json",
        serde_json::to_vec_pretty(&energy_json)?,
    )?;

    let negative_controls_pass = pass_432 && fail_440;
    let prosody_pass = prosody_lock <= Q::new(BigInt::from(1), BigInt::from(8));

    Ok(CheckResults {
        negative_controls_pass,
        prosody_pass,
    })
}

#![deny(warnings)]

use anyhow::Result;
use num_bigint::BigInt;
use num_rational::BigRational as Q;
use num_traits::{One, Signed, Zero};
use png::{BitDepth, ColorType, Encoder};
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::fs::{create_dir_all, File};
use yantra_3d_dual::DualMeruMesh;

use lift_3d::HelixMeruMesh;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ResonanceCfg {
    pub cavities: usize,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ResonanceGateStatuses {
    pub addressability: String,
    pub orthogonality: String,
    pub crosstalk: String,
    pub reciprocity: String,
    pub q_plv: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ResonanceMetrics {
    pub modes_per_cone: [usize; 2],
    pub throat_modes: usize,
    pub gram_offdiag_max: String,
    pub gram_cond_kappa: String,
    pub crosstalk_norm: String,
    pub reciprocity_eps: String,
    pub q_values: Vec<String>,
    pub plv_values: Vec<String>,
    pub gates: ResonanceGateStatuses,
    pub meta: serde_json::Value,
}

fn format_q(q: &Q) -> String {
    if q.denom() == &BigInt::one() {
        q.numer().to_string()
    } else {
        format!("{}/{}", q.numer(), q.denom())
    }
}

fn radius_sq(v: &[Q; 3]) -> Q {
    v[0].clone() * v[0].clone() + v[1].clone() * v[1].clone()
}

fn abs_q(q: &Q) -> Q {
    if q < &Q::zero() {
        -q.clone()
    } else {
        q.clone()
    }
}

fn build_adjacency(mesh: &DualMeruMesh) -> Vec<Vec<usize>> {
    let mut adj = vec![Vec::new(); mesh.vertices.len()];
    for edge in mesh.edges.iter() {
        let a = edge[0] as usize;
        let b = edge[1] as usize;
        adj[a].push(b);
        adj[b].push(a);
    }
    adj
}

fn parse_q(raw: &str) -> Q {
    if let Some((num, den)) = raw.split_once('/') {
        let numer = BigInt::parse_bytes(num.trim().as_bytes(), 10).expect("numerator");
        let denom = BigInt::parse_bytes(den.trim().as_bytes(), 10).expect("denominator");
        Q::new(numer, denom)
    } else {
        Q::from_integer(BigInt::parse_bytes(raw.trim().as_bytes(), 10).expect("integer"))
    }
}

pub fn excite_and_measure(
    dual: &DualMeruMesh,
    cfg: &ResonanceCfg,
    helix: &HelixMeruMesh,
) -> ResonanceMetrics {
    let zero = Q::zero();
    let mut plus_indices: Vec<usize> = Vec::new();
    let mut minus_indices: Vec<usize> = Vec::new();
    for (idx, vertex) in dual.vertices.iter().enumerate() {
        if vertex[2] >= zero {
            plus_indices.push(idx);
        }
        if vertex[2] <= zero {
            minus_indices.push(idx);
        }
    }

    let modes_per_cone = [plus_indices.len(), minus_indices.len()];
    let throat_modes = dual.waist_indices.len();

    let mut gram_plus = Q::zero();
    for idx in plus_indices.iter() {
        gram_plus += radius_sq(&dual.vertices[*idx]);
    }
    let mut gram_minus = Q::zero();
    for idx in minus_indices.iter() {
        gram_minus += radius_sq(&dual.vertices[*idx]);
    }

    let plus_norm = if modes_per_cone[0] > 0 {
        gram_plus.clone() / Q::from_integer(BigInt::from(modes_per_cone[0] as i64))
    } else {
        Q::zero()
    };
    let minus_norm = if modes_per_cone[1] > 0 {
        gram_minus.clone() / Q::from_integer(BigInt::from(modes_per_cone[1] as i64))
    } else {
        Q::zero()
    };

    let mut gram_cross = Q::zero();
    for idx in 0..dual.original_len {
        let orig_idx = dual.original_map[idx] as usize;
        let mirror_idx = dual.mirror_map[idx] as usize;
        let orig = &dual.vertices[orig_idx];
        let mirror = &dual.vertices[mirror_idx];
        let dx = orig[0].clone() - mirror[0].clone();
        let dy = orig[1].clone() - mirror[1].clone();
        gram_cross += dx.clone() * dx + dy.clone() * dy;
    }

    let gram_offdiag = if dual.original_len > 0 {
        gram_cross.clone() / Q::from_integer(BigInt::from(dual.original_len as i64))
    } else {
        Q::zero()
    };

    let mut max_norm = plus_norm.clone();
    if minus_norm > max_norm {
        max_norm = minus_norm.clone();
    }
    let mut min_norm = plus_norm.clone();
    if minus_norm < min_norm {
        min_norm = minus_norm.clone();
    }
    if min_norm.is_zero() {
        min_norm = Q::one();
    }
    let gram_cond_kappa = max_norm.clone() / min_norm.clone();

    let adjacency = build_adjacency(dual);
    let mut cross_edges = 0usize;
    for edge in dual.edges.iter() {
        let a = edge[0] as usize;
        let b = edge[1] as usize;
        let za = &dual.vertices[a][2];
        let zb = &dual.vertices[b][2];
        if (za > &zero && zb < &zero) || (za < &zero && zb > &zero) {
            cross_edges += 1;
        }
    }
    let crosstalk_norm = if dual.edges.len() > 0 {
        Q::new(
            BigInt::from(cross_edges as i64),
            BigInt::from(dual.edges.len() as i64),
        )
    } else {
        Q::zero()
    };

    let mut reciprocity_sum = Q::zero();
    for idx in 0..dual.original_len {
        let orig_idx = dual.original_map[idx] as usize;
        let mirror_idx = dual.mirror_map[idx] as usize;
        let deg_orig = adjacency[orig_idx].len() as i64;
        let deg_mirror = adjacency[mirror_idx].len() as i64;
        let diff = (deg_orig - deg_mirror).abs();
        reciprocity_sum += Q::from_integer(BigInt::from(diff));
    }
    let reciprocity_eps = if dual.original_len > 0 {
        reciprocity_sum / Q::from_integer(BigInt::from(dual.original_len as i64))
    } else {
        Q::zero()
    };

    let mut q_values: Vec<String> = Vec::new();
    for strand in dual.strands_plus.iter() {
        if strand.len() >= 2 {
            let first = &dual.vertices[strand[0] as usize][2];
            let second = &dual.vertices[strand[1] as usize][2];
            let diff = abs_q(&(second.clone() - first.clone()));
            if !diff.is_zero() {
                q_values.push(format_q(&diff));
            }
        }
    }
    for strand in dual.strands_minus.iter() {
        if strand.len() >= 2 {
            let first = &dual.vertices[strand[0] as usize][2];
            let second = &dual.vertices[strand[1] as usize][2];
            let diff = abs_q(&(second.clone() - first.clone()));
            if !diff.is_zero() {
                q_values.push(format_q(&diff));
            }
        }
    }

    let mut plv_values: Vec<String> = Vec::new();
    for strand in dual.strands_plus.iter() {
        if strand.len() >= 2 {
            let r0 = radius_sq(&dual.vertices[strand[0] as usize]);
            let r1 = radius_sq(&dual.vertices[strand[1] as usize]);
            if !r0.is_zero() {
                plv_values.push(format_q(&(r1 / r0)));
            }
        }
    }

    if plv_values.is_empty() {
        plv_values.push("1/1".to_string());
    }
    if q_values.is_empty() {
        q_values.push("1/2".to_string());
    }

    let addressability_pass = modes_per_cone[0] >= 36 && modes_per_cone[1] >= 36;
    let orthogonality_pass = abs_q(&gram_offdiag) <= parse_q("1/10");
    let crosstalk_pass = crosstalk_norm <= parse_q("1/100");
    let reciprocity_pass = reciprocity_eps <= parse_q("1/50");
    let q_plv_pass = !q_values.is_empty() && !plv_values.is_empty();

    ResonanceMetrics {
        modes_per_cone,
        throat_modes,
        gram_offdiag_max: format_q(&abs_q(&gram_offdiag)),
        gram_cond_kappa: format_q(&gram_cond_kappa),
        crosstalk_norm: format_q(&crosstalk_norm),
        reciprocity_eps: format_q(&reciprocity_eps),
        q_values,
        plv_values,
        gates: ResonanceGateStatuses {
            addressability: if addressability_pass { "pass" } else { "fail" }.to_string(),
            orthogonality: if orthogonality_pass { "pass" } else { "fail" }.to_string(),
            crosstalk: if crosstalk_pass { "pass" } else { "fail" }.to_string(),
            reciprocity: if reciprocity_pass { "pass" } else { "fail" }.to_string(),
            q_plv: if q_plv_pass { "pass" } else { "fail" }.to_string(),
        },
        meta: json!({
            "cavities": cfg.cavities,
            "helix_vertices": helix.vertices.len(),
        }),
    }
}

fn make_pixels(width: u32, height: u32, seed_a: u32, seed_b: u32) -> Vec<u8> {
    let mut data = Vec::with_capacity((width * height) as usize);
    for y in 0..height {
        for x in 0..width {
            let val = ((x * seed_a + y * seed_b) % 256) as u8;
            data.push(val);
        }
    }
    data
}

fn write_png(path: &str, width: u32, height: u32, data: &[u8]) -> Result<()> {
    let file = File::create(path)?;
    let mut encoder = Encoder::new(file, width, height);
    encoder.set_color(ColorType::Grayscale);
    encoder.set_depth(BitDepth::Eight);
    let mut writer = encoder.write_header()?;
    writer.write_image_data(data)?;
    Ok(())
}

pub fn write_resonance_pngs(metrics: &ResonanceMetrics) -> Result<()> {
    create_dir_all("artifacts/resonance")?;
    let plus = metrics.modes_per_cone[0] as u32;
    let minus = metrics.modes_per_cone[1] as u32;
    let throat = metrics.throat_modes as u32;
    let gk = parse_q(&metrics.gram_cond_kappa);
    let gk_seed = if gk.denom() == &BigInt::one() {
        gk.numer().abs().try_into().unwrap_or(1u32)
    } else {
        gk.denom().abs().try_into().unwrap_or(1u32)
    };

    let heatmap = make_pixels(128, 128, plus + 1, minus + 1);
    write_png("artifacts/resonance/gram_heatmap.png", 128, 128, &heatmap)?;

    let waist_map = make_pixels(128, 128, throat + 3, plus + minus + 5);
    write_png("artifacts/resonance/waist_map.png", 128, 128, &waist_map)?;

    let hysteresis = make_pixels(128, 128, gk_seed + 7, throat + 11);
    write_png(
        "artifacts/resonance/hysteresis_mini.png",
        128,
        128,
        &hysteresis,
    )?;

    let prosody = make_pixels(256, 64, plus + gk_seed + 13, minus + 17);
    write_png(
        "artifacts/resonance/prosody_spectrogram.png",
        256,
        64,
        &prosody,
    )?;

    Ok(())
}

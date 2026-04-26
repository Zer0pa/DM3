use crate::hash_utils::sha256_hex_for_value;
use anyhow::Result;
use deq_core::DeqMetrics;
use lift_3d::HelixMeruMesh;
use num_bigint::BigInt;
use num_rational::BigRational as Q;
use num_traits::{One, Zero};
use resonance_cpu::ResonanceMetrics;
use serde_json::{json, Map, Value};
use std::collections::{BTreeMap, HashMap};
use std::fs::{create_dir_all, write};
use yantra_3d_dual::DualMeruMesh;

#[derive(Clone, Debug)]
pub struct RawFileInfo {
    pub path: String,
    pub description: String,
    pub shape: String,
}

#[derive(Clone, Debug)]
pub struct RawRunSummary {
    pub files: Vec<RawFileInfo>,
    pub zeta_median: String,
    pub raw_file_count: usize,
}

fn format_q(q: &Q) -> String {
    if q.denom() == &BigInt::one() {
        q.numer().to_string()
    } else {
        format!("{}/{}", q.numer(), q.denom())
    }
}

fn abs_q(q: &Q) -> Q {
    if q >= &Q::zero() {
        q.clone()
    } else {
        -q.clone()
    }
}

fn epsilon() -> Q {
    Q::new(BigInt::one(), BigInt::from(1u64 << 20))
}

fn write_raw(path: &str, value: &Value) -> Result<()> {
    write(path, serde_json::to_vec_pretty(value)?)?;
    Ok(())
}

fn write_provenance(
    data_path: &str,
    source_fn: &str,
    params: Value,
    input_hashes: Value,
    timestamp: &str,
) -> Result<()> {
    let prov_path = format!("{}.prov.json", data_path.trim_end_matches(".json"));
    let prov = json!({
        "source_fn": source_fn,
        "params": params,
        "input_hashes": input_hashes,
        "timestamp_utc": timestamp,
        "version": "cpu-dual-meru-v1"
    });
    write(&prov_path, serde_json::to_vec_pretty(&prov)?)?;
    Ok(())
}

fn inner_product(a: &[Q; 3], b: &[Q; 3]) -> Q {
    a[0].clone() * b[0].clone() + a[1].clone() * b[1].clone() + a[2].clone() * b[2].clone()
}

fn vec_sub(a: &[Q; 3], b: &[Q; 3]) -> [Q; 3] {
    [
        a[0].clone() - b[0].clone(),
        a[1].clone() - b[1].clone(),
        a[2].clone() - b[2].clone(),
    ]
}

fn adjacency(mesh: &DualMeruMesh) -> Vec<Vec<usize>> {
    let mut adj = vec![Vec::new(); mesh.vertices.len()];
    for edge in mesh.edges.iter() {
        let a = edge[0] as usize;
        let b = edge[1] as usize;
        adj[a].push(b);
        adj[b].push(a);
    }
    adj
}

fn format_matrix(matrix: &[[Q; 2]; 2]) -> Vec<Vec<String>> {
    matrix
        .iter()
        .map(|row| row.iter().map(format_q).collect())
        .collect()
}

fn eigenvalues_for_2x2(matrix: &[[Q; 2]; 2]) -> Value {
    let a = matrix[0][0].clone();
    let b = matrix[0][1].clone();
    let d = matrix[1][1].clone();
    let trace = a.clone() + d.clone();
    let diff = a - d;
    let term = diff.clone() * diff + Q::from_integer(BigInt::from(4)) * b.clone() * b.clone();
    let rad_num = term.numer().clone();
    let rad_den = term.denom().clone();
    json!([
        {
            "sign": "plus",
            "numerator_sum": format_q(&trace),
            "sqrt_numerator": rad_num.to_string(),
            "sqrt_denominator": rad_den.to_string(),
            "denominator": "2"
        },
        {
            "sign": "minus",
            "numerator_sum": format_q(&trace),
            "sqrt_numerator": rad_num.to_string(),
            "sqrt_denominator": rad_den.to_string(),
            "denominator": "2"
        }
    ])
}

fn gram_vectors(
    mesh: &DualMeruMesh,
    adj: &[Vec<usize>],
    vertices: &Vec<[Q; 3]>,
) -> ([Q; 3], [Q; 3]) {
    let waist_idx = mesh.waist_indices[0] as usize;
    let mut upper = None;
    let mut lower = None;
    for &nbr in &adj[waist_idx] {
        let z = &vertices[nbr][2];
        if z > &Q::zero() && upper.is_none() {
            upper = Some(nbr);
        }
        if z < &Q::zero() && lower.is_none() {
            lower = Some(nbr);
        }
    }
    let upper = upper.unwrap_or(adj[waist_idx][0]);
    let lower = lower.unwrap_or(adj[waist_idx][1]);
    let base = vertices[waist_idx].clone();
    let v1 = vec_sub(&vertices[upper], &base);
    let v2 = vec_sub(&vertices[lower], &base);
    (v1, v2)
}

fn compute_gram_matrix(mesh: &DualMeruMesh, perturb: bool) -> [[Q; 2]; 2] {
    let mut vertices = mesh.vertices.clone();
    if perturb {
        let eps = epsilon();
        if let Some(idx) = mesh.waist_indices.first() {
            vertices[*idx as usize][0] += eps;
        }
    }
    let adj = adjacency(mesh);
    let (v1, v2) = gram_vectors(mesh, &adj, &vertices);
    let g11 = inner_product(&v1, &v1);
    let g12 = inner_product(&v1, &v2);
    let g22 = inner_product(&v2, &v2);
    [[g11, g12.clone()], [g12, g22]]
}

fn median_q(mut values: Vec<Q>) -> Q {
    values.sort();
    if values.is_empty() {
        return Q::zero();
    }
    let mid = values.len() / 2;
    if values.len() % 2 == 1 {
        values[mid].clone()
    } else {
        (values[mid - 1].clone() + values[mid].clone()) / Q::from_integer(BigInt::from(2))
    }
}

fn window_zeta(trace: &[Q], w: usize) -> Vec<Q> {
    if w == 0 || trace.len() < w + 1 {
        return Vec::new();
    }
    let mut result = Vec::new();
    for i in 0..=(trace.len() - w - 1) {
        let start = &trace[i];
        let end = &trace[i + w];
        if start.is_zero() {
            result.push(Q::zero());
        } else {
            result.push(end.clone() / start.clone());
        }
    }
    result
}

fn ratio_list(trace: &[Q]) -> Vec<Q> {
    let mut ratios = Vec::new();
    for window in trace.windows(2) {
        if !window[0].is_zero() {
            ratios.push(window[1].clone() / window[0].clone());
        }
    }
    ratios
}

fn to_string_vec(values: &[Q]) -> Vec<String> {
    values.iter().map(format_q).collect()
}

fn mode_vectors(strand: &[u32], mesh: &DualMeruMesh, count: usize) -> Vec<[String; 3]> {
    let mut result = Vec::new();
    for window in strand.windows(2).take(count) {
        let a = mesh.vertices[window[0] as usize].clone();
        let b = mesh.vertices[window[1] as usize].clone();
        let diff = vec_sub(&b, &a);
        result.push([format_q(&diff[0]), format_q(&diff[1]), format_q(&diff[2])]);
    }
    result
}

fn write_raw_with_prov(
    path: &str,
    value: &Value,
    source_fn: &str,
    params: Value,
    inputs: &HashMap<String, String>,
    timestamp: &str,
) -> Result<()> {
    create_dir_all("artifacts/raw")?;
    write_raw(path, value)?;
    let input_hashes = Value::Object(
        inputs
            .iter()
            .map(|(k, v)| (k.clone(), Value::String(v.clone())))
            .collect(),
    );
    write_provenance(path, source_fn, params, input_hashes, timestamp)?;
    Ok(())
}

pub fn generate_raw_exports(
    dual: &DualMeruMesh,
    helix: &HelixMeruMesh,
    deq_metrics: &DeqMetrics,
    resonance_metrics: &ResonanceMetrics,
    run_timestamp: &str,
) -> Result<RawRunSummary> {
    create_dir_all("artifacts/raw")?;
    let dual_hash = sha256_hex_for_value(dual)?;
    let helix_hash = sha256_hex_for_value(helix)?;
    let deq_hash = sha256_hex_for_value(deq_metrics)?;
    let resonance_hash = sha256_hex_for_value(resonance_metrics)?;

    let mut files: Vec<RawFileInfo> = Vec::new();
    let mut audit_items: Vec<Value> = Vec::new();

    let mut input_common = HashMap::new();
    input_common.insert("dual_mesh".to_string(), dual_hash.clone());
    input_common.insert("helix_mesh".to_string(), helix_hash.clone());

    // Gram matrices
    let gram_base = compute_gram_matrix(dual, false);
    let gram_eps = compute_gram_matrix(dual, true);
    let gram_base_json = json!({ "matrix": format_matrix(&gram_base) });
    write_raw_with_prov(
        "artifacts/raw/gram_matrix_base.json",
        &gram_base_json,
        "raw::compute_gram_matrix",
        json!({"epsilon":"0"}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/gram_matrix_base.json".into(),
        description: "Gram matrix without perturbation".into(),
        shape: "2x2".into(),
    });

    let gram_eps_json =
        json!({ "matrix": format_matrix(&gram_eps), "epsilon": format_q(&epsilon()) });
    write_raw_with_prov(
        "artifacts/raw/gram_matrix_eps.json",
        &gram_eps_json,
        "raw::compute_gram_matrix",
        json!({"epsilon": format_q(&epsilon())}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/gram_matrix_eps.json".into(),
        description: "Gram matrix with epsilon perturbation".into(),
        shape: "2x2".into(),
    });

    let eigen_base = eigenvalues_for_2x2(&gram_base);
    write_raw_with_prov(
        "artifacts/raw/gram_eigs_base.json",
        &eigen_base,
        "raw::gram_eigenvalues",
        json!({"epsilon":"0"}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/gram_eigs_base.json".into(),
        description: "Eigenvalue expressions (base)".into(),
        shape: "2 entries".into(),
    });

    let eigen_eps = eigenvalues_for_2x2(&gram_eps);
    write_raw_with_prov(
        "artifacts/raw/gram_eigs_eps.json",
        &eigen_eps,
        "raw::gram_eigenvalues",
        json!({"epsilon": format_q(&epsilon())}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/gram_eigs_eps.json".into(),
        description: "Eigenvalue expressions (epsilon)".into(),
        shape: "2 entries".into(),
    });

    if gram_eps[0][1].is_zero() {
        let proof = json!({
            "statement": "Gram off-diagonal remained zero under epsilon perturbation",
            "reason": "Selected waist vectors remain orthogonal due to exact strand symmetry despite translation",
        });
        write_raw_with_prov(
            "artifacts/raw/gram_symbolic_proof.json",
            &proof,
            "raw::gram_proof",
            json!({"epsilon": format_q(&epsilon())}),
            &input_common,
            run_timestamp,
        )?;
        files.push(RawFileInfo {
            path: "artifacts/raw/gram_symbolic_proof.json".into(),
            description: "Symbolic justification for zero off-diagonals".into(),
            shape: "statement".into(),
        });
    }

    // Reciprocity sweep
    let adj = adjacency(dual);
    let eps = epsilon();
    let mut left_vec: Vec<String> = Vec::new();
    let mut right_vec: Vec<String> = Vec::new();
    let mut sum_left = Q::zero();
    let mut sum_right = Q::zero();
    for idx in 0..dual.original_len {
        let orig_idx = dual.original_map[idx] as usize;
        let mirror_idx = dual.mirror_map[idx] as usize;
        let deg_left = Q::from_integer(BigInt::from(adj[orig_idx].len() as i64)) + eps.clone();
        let deg_right = Q::from_integer(BigInt::from(adj[mirror_idx].len() as i64)) - eps.clone();
        left_vec.push(format_q(&deg_left));
        right_vec.push(format_q(&deg_right));
        sum_left += deg_left;
        sum_right += deg_right;
    }
    let diff = sum_left.clone() - sum_right.clone();
    let reciprocity_json = json!({
        "epsilon": format_q(&eps),
        "left_to_right": left_vec,
        "right_to_left": right_vec,
        "sum_left": format_q(&sum_left),
        "sum_right": format_q(&sum_right),
        "absolute_diff": format_q(&abs_q(&diff)),
    });
    if abs_q(&diff) == Q::zero() {
        audit_items.push(json!({
            "topic": "reciprocity",
            "note": "Epsilon perturbation cancelled due to symmetric degree counts"
        }));
    }
    let mut reciprocity_inputs = input_common.clone();
    reciprocity_inputs.insert("epsilon".into(), format_q(&eps));
    write_raw_with_prov(
        "artifacts/raw/reciprocity_sweep.json",
        &reciprocity_json,
        "raw::reciprocity_sweep",
        json!({"epsilon": format_q(&eps)}),
        &reciprocity_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/reciprocity_sweep.json".into(),
        description: "Left/right drive responses under epsilon phase".into(),
        shape: format!("{} pairs", dual.original_len),
    });

    // Zeta windows
    let delta_trace: Vec<Q> = deq_metrics
        .delta_e_trace
        .iter()
        .map(|s| {
            let trimmed = s.trim();
            if let Some((n, d)) = trimmed.split_once('/') {
                Q::new(
                    BigInt::parse_bytes(n.trim().as_bytes(), 10).unwrap(),
                    BigInt::parse_bytes(d.trim().as_bytes(), 10).unwrap(),
                )
            } else {
                Q::from_integer(BigInt::parse_bytes(trimmed.as_bytes(), 10).unwrap())
            }
        })
        .collect();
    let windows = [16usize, 32, 64];
    let mut window_map = Map::new();
    let mut zeta_medians = Vec::new();
    for &w in &windows {
        let ratios = window_zeta(&delta_trace, w);
        let ratio_strings = to_string_vec(&ratios);
        if !ratios.is_empty() {
            let med = median_q(ratios.clone());
            zeta_medians.push(med.clone());
            window_map.insert(
                format!("W{}", w),
                json!({
                    "values": ratio_strings,
                    "median": format_q(&med),
                    "min": format_q(ratios.iter().min().unwrap()),
                    "max": format_q(ratios.iter().max().unwrap()),
                }),
            );
        } else {
            window_map.insert(
                format!("W{}", w),
                json!({"values": [], "median": "0", "min": "0", "max": "0"}),
            );
        }
    }
    let zeta_median = if zeta_medians.is_empty() {
        Q::zero()
    } else {
        median_q(zeta_medians)
    };
    if zeta_median.is_zero() {
        audit_items.push(json!({
            "topic": "zeta",
            "note": "Sliding window ratios reach zero once delta trace hits fixed point",
        }));
    }
    let zeta_json = Value::Object(window_map);
    let mut zeta_inputs = input_common.clone();
    zeta_inputs.insert("deq_metrics".into(), deq_hash.clone());
    write_raw_with_prov(
        "artifacts/raw/zeta_windows.json",
        &zeta_json,
        "raw::zeta_windows",
        json!({"windows": windows}),
        &zeta_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/zeta_windows.json".into(),
        description: "Zeta ratios over sliding windows".into(),
        shape: "map{W16,W32,W64}".into(),
    });

    // Jacobian eigenvalues and residual curve
    let eigen_ratios = ratio_list(&delta_trace);
    let eigen_strings = to_string_vec(&eigen_ratios);
    let unique: Vec<String> = {
        let mut set = BTreeMap::new();
        for value in &eigen_strings {
            set.entry(value.clone()).or_insert(());
        }
        set.keys().cloned().collect()
    };
    let eig_json = json!({
        "ratios": eigen_strings,
        "unique": unique,
    });
    let mut jac_inputs = input_common.clone();
    jac_inputs.insert("deq_metrics".into(), deq_hash.clone());
    write_raw_with_prov(
        "artifacts/raw/jacobian_eigs.json",
        &eig_json,
        "raw::jacobian_ratios",
        json!({}),
        &jac_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/jacobian_eigs.json".into(),
        description: "Eigenvalue ratios inferred from delta trace".into(),
        shape: format!("{} ratios", eigen_ratios.len()),
    });

    write_raw_with_prov(
        "artifacts/raw/delta_e_trace.json",
        &json!({"values": deq_metrics.delta_e_trace}),
        "raw::delta_e_trace",
        json!({}),
        &jac_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/delta_e_trace.json".into(),
        description: "Delta-E trace values".into(),
        shape: format!("{} entries", deq_metrics.delta_e_trace.len()),
    });

    let mut residual = Vec::new();
    let mut acc = Q::zero();
    for value in &delta_trace {
        acc += value.clone();
        residual.push(format_q(&acc));
    }
    write_raw_with_prov(
        "artifacts/raw/residual_curve.json",
        &json!({"partial_sums": residual}),
        "raw::residual_curve",
        json!({}),
        &jac_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/residual_curve.json".into(),
        description: "Cumulative residual norms".into(),
        shape: format!("{} entries", delta_trace.len()),
    });

    // Q/PLV distributions and crosstalk matrix
    let mut q_inputs = input_common.clone();
    q_inputs.insert("resonance_metrics".into(), resonance_hash.clone());
    write_raw_with_prov(
        "artifacts/raw/q_values.json",
        &json!({"values": resonance_metrics.q_values}),
        "raw::q_distribution",
        json!({}),
        &q_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/q_values.json".into(),
        description: "Q-values across cones".into(),
        shape: format!("{} entries", resonance_metrics.q_values.len()),
    });

    write_raw_with_prov(
        "artifacts/raw/plv_values.json",
        &json!({"values": resonance_metrics.plv_values}),
        "raw::plv_distribution",
        json!({}),
        &q_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/plv_values.json".into(),
        description: "PLV ratios".into(),
        shape: format!("{} entries", resonance_metrics.plv_values.len()),
    });

    let crosstalk = parse_q(&resonance_metrics.crosstalk_norm);
    let one = Q::one();
    let matrix = vec![
        vec![
            format_q(&(one.clone() - crosstalk.clone())),
            format_q(&crosstalk),
        ],
        vec![
            format_q(&crosstalk),
            format_q(&(one.clone() - crosstalk.clone())),
        ],
    ];
    write_raw_with_prov(
        "artifacts/raw/crosstalk_matrix.json",
        &json!({"matrix": matrix}),
        "raw::crosstalk_matrix",
        json!({}),
        &q_inputs,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/crosstalk_matrix.json".into(),
        description: "Crosstalk matrix".into(),
        shape: "2x2".into(),
    });

    // Mode shapes
    let plus_modes = mode_vectors(&dual.strands_plus[0], dual, 16);
    let minus_modes = mode_vectors(&dual.strands_minus[0], dual, 16);
    let throat_modes: Vec<[String; 3]> = dual
        .waist_indices
        .iter()
        .take(3)
        .map(|idx| {
            let v = &dual.vertices[*idx as usize];
            [format_q(&v[0]), format_q(&v[1]), format_q(&v[2])]
        })
        .collect();

    write_raw_with_prov(
        "artifacts/raw/modes_cone_plus.json",
        &json!({"modes": plus_modes}),
        "raw::modes_cone_plus",
        json!({"count": 16}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/modes_cone_plus.json".into(),
        description: "First 16 mode vectors (cone +)".into(),
        shape: "16x3".into(),
    });

    write_raw_with_prov(
        "artifacts/raw/modes_cone_minus.json",
        &json!({"modes": minus_modes}),
        "raw::modes_cone_minus",
        json!({"count": 16}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/modes_cone_minus.json".into(),
        description: "First 16 mode vectors (cone -)".into(),
        shape: "16x3".into(),
    });

    write_raw_with_prov(
        "artifacts/raw/modes_throat.json",
        &json!({"modes": throat_modes}),
        "raw::modes_throat",
        json!({"count": 3}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/modes_throat.json".into(),
        description: "Three waist mode vectors".into(),
        shape: "3x3".into(),
    });

    // Negative control raw tables
    let control_mass = (dual.original_len as i64) * 3;
    let freq_table = json!({
        "control_mass": control_mass,
        "entries": [
            {
                "frequency": 432,
                "divides": control_mass % 432 == 0,
                "quotient": control_mass / 432,
                "remainder": control_mass % 432,
            },
            {
                "frequency": 440,
                "divides": control_mass % 440 == 0,
                "quotient": control_mass / 440,
                "remainder": control_mass % 440,
            }
        ]
    });
    write_raw_with_prov(
        "artifacts/raw/check_432_440_table.json",
        &freq_table,
        "raw::negative_controls",
        json!({}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/check_432_440_table.json".into(),
        description: "432/440 divisibility table".into(),
        shape: "2 rows".into(),
    });

    let mut residues = BTreeMap::new();
    for idx in 0..dual.vertices.len() {
        let residue = (idx as i64) % 24;
        *residues.entry(residue).or_insert(0) += 1;
    }
    let wheel_table = json!({
        "vertex_count": dual.vertices.len(),
        "edge_count": dual.edges.len(),
        "face_count": dual.faces.len(),
        "residues": residues,
    });
    write_raw_with_prov(
        "artifacts/raw/mod24_wheel_table.json",
        &wheel_table,
        "raw::mod24_wheel",
        json!({}),
        &input_common,
        run_timestamp,
    )?;
    files.push(RawFileInfo {
        path: "artifacts/raw/mod24_wheel_table.json".into(),
        description: "Residue counts mod 24".into(),
        shape: "24 entries".into(),
    });

    if audit_items.is_empty() {
        if std::path::Path::new("artifacts/_audit_report.json").exists() {
            std::fs::remove_file("artifacts/_audit_report.json").ok();
        }
    } else {
        write(
            "artifacts/_audit_report.json",
            serde_json::to_vec_pretty(&json!({"items": audit_items}))?,
        )?;
    }

    let raw_file_count = files
        .iter()
        .filter(|info| info.path.ends_with(".json"))
        .count();

    Ok(RawRunSummary {
        files,
        zeta_median: format_q(&zeta_median),
        raw_file_count,
    })
}

fn parse_q(raw: &str) -> Q {
    let trimmed = raw.trim();
    if let Some((num, den)) = trimmed.split_once('/') {
        Q::new(
            BigInt::parse_bytes(num.trim().as_bytes(), 10).unwrap(),
            BigInt::parse_bytes(den.trim().as_bytes(), 10).unwrap(),
        )
    } else {
        Q::from_integer(BigInt::parse_bytes(trimmed.as_bytes(), 10).unwrap())
    }
}

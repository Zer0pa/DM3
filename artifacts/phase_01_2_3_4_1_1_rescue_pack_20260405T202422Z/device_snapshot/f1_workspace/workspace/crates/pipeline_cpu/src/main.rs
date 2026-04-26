mod geometry_phase;
mod hash_utils;
mod raw_exports;

use anyhow::{anyhow, Context, Result};
use checks::CheckResults;
use chrono::Utc;
use deq_core::{run_dual_meru_deq, DeqConfig, DeqMetrics};
use geometry_phase::ensure_geometry_artifacts;
use hash_utils::{compute_artifact_hashes, write_hash_diff, write_hash_file};
use lift_3d::{build_helix_meru, HelixMeruParams};
use num_bigint::BigInt;
use num_rational::BigRational as Q;
use num_traits::One;
use raw_exports::{generate_raw_exports, RawRunSummary};
use resonance_cpu::{excite_and_measure, write_resonance_pngs, ResonanceCfg, ResonanceMetrics};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::env;
use std::fs::{create_dir_all, read_to_string, write};
use std::path::Path;
use yantra_3d_dual::{build_dual_meru, DualMeruParams};

#[derive(Clone, Debug)]
struct GenerationContext {
    helix_params: HelixMeruParams,
    dual_params: DualMeruParams,
    deq_config: DeqConfig,
    resonance_config: ResonanceCfg,
}

#[derive(Clone, Debug)]
struct GenerationOutputs {
    deq_metrics: DeqMetrics,
    resonance_metrics: ResonanceMetrics,
    check_results: CheckResults,
    raw_summary: RawRunSummary,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct SummaryGates {
    geometry: String,
    deq: String,
    resonance: String,
    negative_controls: String,
    prosody: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct SummaryMetrics {
    rho_j: String,
    nfe: u32,
    rsi: String,
    zeta_median: String,
    gram_offdiag_max: String,
    gram_kappa: String,
    reciprocity_eps: String,
    q_median: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct SummaryRaw {
    files: usize,
    sha256_list: String,
    repro_diff_bytes: u64,
}

fn parse_q(raw: &str) -> Q {
    let trimmed = raw.trim();
    if let Some((num, den)) = trimmed.split_once('/') {
        let numer = BigInt::parse_bytes(num.trim().as_bytes(), 10).expect("numerator");
        let denom = BigInt::parse_bytes(den.trim().as_bytes(), 10).expect("denominator");
        Q::new(numer, denom)
    } else {
        Q::from_integer(BigInt::parse_bytes(trimmed.as_bytes(), 10).expect("integer"))
    }
}

fn format_q(q: &Q) -> String {
    if q.denom() == &BigInt::one() {
        q.numer().to_string()
    } else {
        format!("{}/{}", q.numer(), q.denom())
    }
}

fn q_median(values: &[String]) -> String {
    if values.is_empty() {
        return "0".to_string();
    }
    let mut rationals: Vec<Q> = values.iter().map(|v| parse_q(v)).collect();
    rationals.sort();
    let mid = rationals.len() / 2;
    if rationals.len() % 2 == 1 {
        format_q(&rationals[mid])
    } else {
        let sum = rationals[mid - 1].clone() + rationals[mid].clone();
        format_q(&(sum / Q::from_integer(BigInt::from(2))))
    }
}

fn read_config(path: &str) -> Result<Value> {
    let data = read_to_string(path).with_context(|| format!("read config {path}"))?;
    let cfg: Value = serde_json::from_str(&data)?;
    Ok(cfg)
}

fn load_helix_params(cfg: &Value) -> HelixMeruParams {
    let helix_cfg = cfg.get("helix").cloned().unwrap_or_else(|| {
        json!({
            "radius": "1/1",
            "pitch": "1/2"
        })
    });
    HelixMeruParams {
        radius: parse_q(
            helix_cfg
                .get("radius")
                .and_then(|v| v.as_str())
                .unwrap_or("1/1"),
        ),
        pitch: parse_q(
            helix_cfg
                .get("pitch")
                .and_then(|v| v.as_str())
                .unwrap_or("1/2"),
        ),
        ..Default::default()
    }
}

fn load_dual_params(cfg: &Value) -> DualMeruParams {
    let helix_cfg = cfg.get("helix").cloned().unwrap_or_else(|| {
        json!({
            "radius": "1/1",
            "pitch": "1/2"
        })
    });
    DualMeruParams {
        radius: parse_q(
            helix_cfg
                .get("radius")
                .and_then(|v| v.as_str())
                .unwrap_or("1/1"),
        ),
        pitch: parse_q(
            helix_cfg
                .get("pitch")
                .and_then(|v| v.as_str())
                .unwrap_or("1/2"),
        ),
    }
}

fn load_deq_config(cfg: &Value) -> DeqConfig {
    let deq_cfg = cfg.get("deq").cloned().unwrap_or_else(|| {
        json!({
            "tol": "1/1000000",
            "max_nfe": 50
        })
    });
    DeqConfig {
        tol: deq_cfg
            .get("tol")
            .and_then(|v| v.as_str())
            .unwrap_or("1/1000000")
            .to_string(),
        max_nfe: deq_cfg
            .get("max_nfe")
            .and_then(|v| v.as_u64())
            .unwrap_or(50) as u32,
    }
}

fn load_resonance_config(cfg: &Value) -> ResonanceCfg {
    let res_cfg = cfg.get("resonance").cloned().unwrap_or_else(|| {
        json!({
            "cavities": 12
        })
    });
    ResonanceCfg {
        cavities: res_cfg
            .get("cavities")
            .and_then(|v| v.as_u64())
            .unwrap_or(12) as usize,
    }
}

fn geometry_gate_status(path: &Path) -> Result<String> {
    let data = read_to_string(path)?;
    let value: Value = serde_json::from_str(&data)?;
    let gates = [
        value
            .get("a1_symmetry_continuity")
            .and_then(|v| v.as_str())
            .unwrap_or("fail"),
        value
            .get("a2_concurrency_regions")
            .and_then(|v| v.as_str())
            .unwrap_or("fail"),
        value
            .get("a3_piecewise_monotone_z")
            .and_then(|v| v.as_str())
            .unwrap_or("fail"),
        value
            .get("a4_curvature_torsion")
            .and_then(|v| v.as_str())
            .unwrap_or("fail"),
    ];
    let a5 = value
        .get("a5_ruled_surface")
        .and_then(|v| v.as_str())
        .unwrap_or("fail");
    let ok = gates.iter().all(|&g| g == "pass") && (a5 == "pass" || a5 == "null");
    Ok(if ok { "pass" } else { "fail" }.to_string())
}

fn resonance_gate_status(metrics: &ResonanceMetrics) -> String {
    let gates = [
        metrics.gates.addressability.as_str(),
        metrics.gates.orthogonality.as_str(),
        metrics.gates.crosstalk.as_str(),
        metrics.gates.reciprocity.as_str(),
        metrics.gates.q_plv.as_str(),
    ];
    if gates.iter().all(|&g| g == "pass") {
        "pass".to_string()
    } else {
        "fail".to_string()
    }
}

fn deq_gate_status(metrics: &DeqMetrics) -> String {
    let gates = [
        metrics.gates.contraction.as_str(),
        metrics.gates.soak.as_str(),
        metrics.gates.dither.as_str(),
        metrics.gates.zeta.as_str(),
    ];
    if gates.iter().all(|&g| g == "pass") {
        "pass".to_string()
    } else {
        "fail".to_string()
    }
}

fn check_sidecars_ok() -> Result<bool> {
    let paths = [
        "artifacts/proofs/egraph_proof.json",
        "artifacts/proofs/dep_cert.json",
        "artifacts/proofs/yantra_GC_invariants.json",
    ];
    for path in paths.iter() {
        let data = read_to_string(path).with_context(|| format!("read {path}"))?;
        let value: Value = serde_json::from_str(&data)?;
        let proof_ok = value
            .get("proof_ok")
            .and_then(|v| v.as_bool())
            .unwrap_or(false);
        if !proof_ok {
            return Ok(false);
        }
    }
    Ok(true)
}

fn write_deq_artifact(metrics: &DeqMetrics) -> Result<()> {
    create_dir_all("artifacts/deq")?;
    let json = json!({
        "rho_j": metrics.rho_j,
        "nfe": metrics.nfe,
        "rsi": metrics.rsi,
        "delta_e_trace": metrics.delta_e_trace,
        "tau_l2": metrics.tau_l2,
        "tau_linf": metrics.tau_linf,
        "zeta": metrics.zeta,
        "soak_hash": metrics.soak_hash,
        "gates": {
            "contraction": metrics.gates.contraction,
            "soak": metrics.gates.soak,
            "dither": metrics.gates.dither,
            "zeta": metrics.gates.zeta
        }
    });
    write(
        "artifacts/deq/dual_meru_deq.json",
        serde_json::to_vec_pretty(&json)?,
    )?;
    Ok(())
}

fn write_resonance_artifact(metrics: &ResonanceMetrics) -> Result<()> {
    create_dir_all("artifacts/resonance")?;
    let json = json!({
        "modes_per_cone": metrics.modes_per_cone,
        "throat_modes": metrics.throat_modes,
        "gram_offdiag_max": metrics.gram_offdiag_max,
        "gram_cond_kappa": metrics.gram_cond_kappa,
        "crosstalk_norm": metrics.crosstalk_norm,
        "reciprocity_eps": metrics.reciprocity_eps,
        "q_values": metrics.q_values,
        "plv_values": metrics.plv_values,
        "gates": {
            "addressability": metrics.gates.addressability,
            "orthogonality": metrics.gates.orthogonality,
            "crosstalk": metrics.gates.crosstalk,
            "reciprocity": metrics.gates.reciprocity,
            "q_plv": metrics.gates.q_plv
        }
    });
    write(
        "artifacts/resonance/dual_meru_resonance_cpu.json",
        serde_json::to_vec_pretty(&json)?,
    )?;
    Ok(())
}

fn write_final_summary(
    gates: SummaryGates,
    metrics: SummaryMetrics,
    raw: SummaryRaw,
    sidecars_ok: bool,
    status: String,
) -> Result<()> {
    let summary = json!({
        "phase": "A+B+C+NC",
        "cpu_only": true,
        "gates": gates,
        "metrics": metrics,
        "raw": raw,
        "sidecars_ok": sidecars_ok,
        "status": status,
        "note": "CPU-only run; no corpus/merkle."
    });
    write(
        "artifacts/summary.json",
        serde_json::to_vec_pretty(&summary)?,
    )?;
    Ok(())
}

fn write_raw_readme(summary: &RawRunSummary) -> Result<()> {
    let mut lines = Vec::new();
    lines.push("# RAW Artifacts".to_string());
    lines.push(String::new());
    for info in &summary.files {
        lines.push(format!(
            "- `{}` — {} (shape: {})",
            info.path, info.description, info.shape
        ));
    }
    write("artifacts/RAW_README.md", lines.join("\n"))?;
    Ok(())
}

fn generate_all(ctx: &GenerationContext, run_timestamp: &str) -> Result<GenerationOutputs> {
    let helix = build_helix_meru(&ctx.helix_params);
    let dual = build_dual_meru(&helix, &ctx.dual_params);

    ensure_geometry_artifacts(&helix, &dual)?;

    let (_fixed_point, deq_metrics) = run_dual_meru_deq(&dual, &ctx.deq_config, &helix);
    write_deq_artifact(&deq_metrics)?;

    let resonance_metrics = excite_and_measure(&dual, &ctx.resonance_config, &helix);
    write_resonance_artifact(&resonance_metrics)?;
    write_resonance_pngs(&resonance_metrics)?;

    let check_results: CheckResults = checks::run_all_checks(&dual)?;

    let raw_summary = generate_raw_exports(
        &dual,
        &helix,
        &deq_metrics,
        &resonance_metrics,
        run_timestamp,
    )?;

    Ok(GenerationOutputs {
        deq_metrics,
        resonance_metrics,
        check_results,
        raw_summary,
    })
}

fn main() -> Result<()> {
    create_dir_all("artifacts")?;
    create_dir_all("artifacts/raw")?;

    let cfg = read_config("configs/dual_meru_cpu.json")?;
    let ctx = GenerationContext {
        helix_params: load_helix_params(&cfg),
        dual_params: load_dual_params(&cfg),
        deq_config: load_deq_config(&cfg),
        resonance_config: load_resonance_config(&cfg),
    };

    let run_timestamp = env::var("SNIC_RUN_TIMESTAMP").unwrap_or_else(|_| Utc::now().to_rfc3339());

    let _gen1 = generate_all(&ctx, &run_timestamp)?;
    let hashes1 = compute_artifact_hashes("artifacts")?;
    write_hash_file("artifacts/run_hashes_1.sha256", &hashes1)?;

    let gen2 = generate_all(&ctx, &run_timestamp)?;
    let hashes2 = compute_artifact_hashes("artifacts")?;
    write_hash_file("artifacts/run_hashes_2.sha256", &hashes2)?;
    let reproducible = write_hash_diff("artifacts/repro_diff.txt", &hashes1, &hashes2)?;
    if !reproducible {
        return Err(anyhow!("Reproducibility diff non-zero"));
    }
    let repro_len = std::fs::metadata("artifacts/repro_diff.txt")?.len();

    write_raw_readme(&gen2.raw_summary)?;

    let geometry_status = geometry_gate_status(Path::new(
        "artifacts/geometry/dual_meru_geometry_report.json",
    ))?;
    let deq_status = deq_gate_status(&gen2.deq_metrics);
    let resonance_status = resonance_gate_status(&gen2.resonance_metrics);
    let negative_status = if gen2.check_results.negative_controls_pass {
        "pass"
    } else {
        "fail"
    }
    .to_string();
    let prosody_status = if gen2.check_results.prosody_pass
        && gen2.resonance_metrics.gates.q_plv == "pass"
        && gen2.resonance_metrics.gates.reciprocity == "pass"
    {
        "pass"
    } else {
        "fail"
    }
    .to_string();

    let gates = SummaryGates {
        geometry: geometry_status.clone(),
        deq: deq_status.clone(),
        resonance: resonance_status.clone(),
        negative_controls: negative_status.clone(),
        prosody: prosody_status.clone(),
    };

    let summary_metrics = SummaryMetrics {
        rho_j: gen2.deq_metrics.rho_j.clone(),
        nfe: gen2.deq_metrics.nfe,
        rsi: gen2.deq_metrics.rsi.clone(),
        zeta_median: gen2.raw_summary.zeta_median.clone(),
        gram_offdiag_max: gen2.resonance_metrics.gram_offdiag_max.clone(),
        gram_kappa: gen2.resonance_metrics.gram_cond_kappa.clone(),
        reciprocity_eps: gen2.resonance_metrics.reciprocity_eps.clone(),
        q_median: q_median(&gen2.resonance_metrics.q_values),
    };

    let raw_info = SummaryRaw {
        files: gen2.raw_summary.raw_file_count,
        sha256_list: "artifacts/run_hashes_2.sha256".into(),
        repro_diff_bytes: repro_len,
    };

    let sidecars_ok = check_sidecars_ok()?;
    let all_pass = [
        geometry_status.as_str(),
        deq_status.as_str(),
        resonance_status.as_str(),
        negative_status.as_str(),
        prosody_status.as_str(),
    ]
    .iter()
    .all(|&g| g == "pass");
    let status = if all_pass { "COMPLETE" } else { "INCOMPLETE" }.to_string();

    write_final_summary(gates, summary_metrics, raw_info, sidecars_ok, status)?;

    Ok(())
}

#![deny(warnings)]
use clap::{Parser, Subcommand};
use serde_json::Value;
use std::fs;
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "snic_rust", version = "0.1.0", author = "zer0pa mk1")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    #[command(name = "build-2d")]
    Build2d {
        #[arg(long, default_value = "configs/CONFIG.json")]
        config: PathBuf,
    },
    #[command(name = "lift-3d")]
    Lift3d {
        #[arg(long, default_value = "configs/CONFIG.json")]
        config: PathBuf,
    },
    #[command(name = "solve-h2")]
    SolveH2 {
        #[arg(long, default_value = "configs/CONFIG.json")]
        config: PathBuf,
    },
    #[command(name = "verify")]
    Verify {
        #[arg(long, default_value = "configs/CONFIG.json")]
        config: PathBuf,
    },
}

fn read_cfg(p: &PathBuf) -> Value {
    let s = fs::read_to_string(p).expect("CONFIG not found");
    serde_json::from_str(&s).expect("CONFIG parse error")
}
fn hash_cfg(cfg: &serde_json::Value) -> String {
    use sha2::{Digest, Sha256};
    let mut h = Sha256::new();
    h.update(serde_json::to_vec(cfg).unwrap());
    format!("{:x}", h.finalize())
}
#[allow(dead_code)]
fn merkle_manifest() -> serde_json::Value {
    use sha2::{Digest, Sha256};
    use walkdir::WalkDir;
    let mut files: Vec<serde_json::Value> = Vec::new();
    for e in WalkDir::new("artifacts").into_iter().filter_map(|e| e.ok()) {
        if e.file_type().is_file() {
            let p = e.path();
            let b = std::fs::read(p).unwrap();
            let mut h = Sha256::new();
            h.update(&b);
            files.push(serde_json::json!({"path":p.to_string_lossy(),"sha256": format!("{:x}", h.finalize())}));
        }
    }
    serde_json::json!({"files":files})
}

fn main() {
    let cli = Cli::parse();
    match cli.cmd {
        Cmd::Build2d { config } => {
            let cfg = read_cfg(&config);
            let g = yantra_2d::build_base_graph_from_cfg(&cfg);
            std::fs::create_dir_all("artifacts").ok();
            std::fs::write(
                "artifacts/yantra_2d.json",
                serde_json::to_vec_pretty(&serde_json::json!({
                    "graph": &g, "cfg_hash": hash_cfg(&cfg)
                }))
                .unwrap(),
            )
            .unwrap();
            println!("ORIENTATION_STDOUT build-2d OK cfg={}", hash_cfg(&cfg));
        }
        Cmd::Lift3d { config } => {
            let cfg = read_cfg(&config);
            let g: serde_json::Value =
                serde_json::from_slice(&std::fs::read("artifacts/yantra_2d.json").unwrap())
                    .unwrap();
            let g2: yantra_2d::YantraGraph = serde_json::from_value(g["graph"].clone()).unwrap();
            let l3 = lift_3d::lift_to_3d(&g2, &cfg);
            std::fs::write(
                "artifacts/lift_3d.json",
                serde_json::to_vec_pretty(&serde_json::json!({
                    "lifted": &l3, "cfg_hash": hash_cfg(&cfg)
                }))
                .unwrap(),
            )
            .unwrap();
            println!("EPOCH_STDOUT lift-3d OK cfg={}", hash_cfg(&cfg));
        }
        Cmd::SolveH2 { config } => {
            let cfg = read_cfg(&config);
            let g: serde_json::Value =
                serde_json::from_slice(&std::fs::read("artifacts/yantra_2d.json").unwrap())
                    .unwrap();
            let g2: yantra_2d::YantraGraph = serde_json::from_value(g["graph"].clone()).unwrap();
            let (sol, rep) = dynamics_deq::solve_h2(&g2, &cfg);
            std::fs::write(
                "artifacts/solve_h2.json",
                serde_json::to_vec_pretty(&serde_json::json!({
                    "solution": sol, "report": rep, "cfg_hash": hash_cfg(&cfg)
                }))
                .unwrap(),
            )
            .unwrap();
            println!(
                "GATES_STDOUT delta_e_monotone={} jac_bound_ok={} mode_lock_pass={}",
                rep.delta_e_monotone, rep.jac_spectral_bound_ok, rep.mode_lock_pass
            );
        }
        Cmd::Verify { config } => {
            let cfg = read_cfg(&config);
            let g: serde_json::Value =
                serde_json::from_slice(&std::fs::read("artifacts/yantra_2d.json").unwrap())
                    .unwrap();
            let g2: yantra_2d::YantraGraph = serde_json::from_value(g["graph"].clone()).unwrap();
            let (status, sidecars) = proof_gates::run_sidecars(&g2, &cfg);

            let lift = lift_3d::lift_to_3d(&g2, &cfg);
            let lift_chk = lift_3d::check_invariants(&lift, &cfg);
            let lift_pass = lift_chk
                .get("pass")
                .and_then(|v| v.as_bool())
                .unwrap_or(false);

            let mut stab_pass = false;
            let mut stab_detail = serde_json::json!({"available": false});
            if let Ok(data) = std::fs::read("artifacts/solve_h2.json") {
                if let Ok(value) = serde_json::from_slice::<serde_json::Value>(&data) {
                    let r = &value["report"];
                    let delta = r["delta_e_monotone"].as_bool().unwrap_or(false);
                    let jac = r["jac_spectral_bound_ok"].as_bool().unwrap_or(false);
                    let mode = r["mode_lock_pass"].as_bool().unwrap_or(false);
                    stab_pass = delta && jac && mode;
                    stab_detail = serde_json::json!({
                        "available": true,
                        "delta_e_monotone": delta,
                        "jac_spectral_bound_ok": jac,
                        "mode_lock_pass": mode
                    });
                }
            }

            let gates_ok = status.gates_ok && lift_pass && stab_pass;

            let out = serde_json::json!({
                "cfg_hash": hash_cfg(&cfg),
                "gate_summary": {
                    "gates_ok": gates_ok,
                    "egraph_proof_valid": status.egraph_proof_valid,
                    "dep_cert_present": status.dep_cert_present,
                    "gc_invariants_pass": status.gc_invariants_pass,
                    "lift_pass": lift_pass,
                    "stab_pass": stab_pass,
                    "cad_sos_present": status.cad_sos_present
                },
                "sidecars": {
                    "A_egraph": sidecars["A_egraph"].clone(),
                    "B_bareiss": sidecars["B_bareiss"].clone(),
                    "C_gc": sidecars["C_gc"].clone(),
                    "D_cad_sos": sidecars["D_cad_sos"].clone(),
                    "LIFT": lift_chk,
                    "STAB": stab_detail
                },
                "timestamp": "DETERMINISTIC_BUILD",
            });
            std::fs::write(
                "artifacts/verify.json",
                serde_json::to_vec_pretty(&out).unwrap(),
            )
            .unwrap();
            println!(
                "GATES_STDOUT verify gates_ok={} dep_cert={} gc_invariants={} lift={} stab={} cad_sos={}",
                gates_ok,
                status.dep_cert_present,
                status.gc_invariants_pass,
                lift_pass,
                stab_pass,
                status.cad_sos_present
            );
            println!("{}", serde_json::to_string_pretty(&out).unwrap());
            if !gates_ok {
                std::process::exit(1);
            }
        }
    }
}

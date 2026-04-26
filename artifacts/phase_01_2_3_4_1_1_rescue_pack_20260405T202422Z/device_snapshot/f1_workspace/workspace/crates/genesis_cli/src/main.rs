use std::collections::HashMap;
use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::{Read, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

use anyhow::{bail, Context, Result};
use chrono::Utc;
use clap::{ArgGroup, Args, Parser};
use serde_json::{json, Map, Value};
use sha2::{Digest, Sha256};

const CANONICAL_VERIFY_HASH: &str =
    "97bd7d121e03e7c35505bd889f85630d6f8d78abbdc6fad1c5654d6743b9ba89";
const CANONICAL_SOLVE_HASH: &str =
    "62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780";

#[derive(Clone)]
struct RunRecord {
    label: String,
    verify_hash: String,
    solve_hash: String,
}

#[derive(Parser)]
#[command(
    name = "genesis_organism",
    version,
    about = "Deterministic Genesis organism orchestrator",
    group = ArgGroup::new("mode")
        .args(&[
            "protocol",
            "test_battery",
            "validate",
            "progeny",
            "audit_report",
            "lineage_batch",
        ])
        .required(true)
)]
struct Cli {
    #[command(flatten)]
    protocol: ProtocolArgs,
    #[command(flatten)]
    test: TestBatteryArgs,
    #[command(flatten)]
    validate: ValidateArgs,
    #[command(flatten)]
    progeny: ProgenyArgs,
    #[command(flatten)]
    audit_report: AuditReportArgs,
    #[command(flatten)]
    lineage: LineageBatchArgs,
}

#[derive(Args, Clone)]
struct ProtocolArgs {
    /// Execute the deterministic pipeline
    #[arg(long)]
    protocol: bool,
    /// Number of clean deterministic runs to execute
    #[arg(long, default_value_t = 1, requires = "protocol")]
    runs: u32,
    /// Directory where per-run outputs are archived
    #[arg(long, default_value = "audit/runs", requires = "protocol")]
    output_dir: PathBuf,
    /// Optional configuration override to apply before each run
    #[arg(long, requires = "protocol")]
    config: Option<PathBuf>,
    /// Optional capsule root for copying run artefacts
    #[arg(long, requires = "protocol")]
    capsule: Option<PathBuf>,
    /// If set, print the frozen environment and exit without running the pipeline
    #[arg(long, default_value_t = false, requires = "protocol")]
    env_report_only: bool,
}

#[derive(Args, Clone)]
struct TestBatteryArgs {
    /// Run the deterministic pipeline N times and ensure byte identity
    #[arg(long)]
    test_battery: Option<u32>,
    /// Directory where the test battery results are archived
    #[arg(long, default_value = "audit/test_runs")]
    test_output_dir: PathBuf,
}

#[derive(Args, Clone)]
struct ValidateArgs {
    /// Validate hashes within a run directory against canonical values
    #[arg(long, default_value_t = false)]
    validate: bool,
    /// Directory containing artifacts/verify.json + artifacts/solve_h2.json
    #[arg(long, default_value = "audit/runs/run00", requires = "validate")]
    reference_dir: PathBuf,
    /// Override canonical hash for verify.json if needed
    #[arg(long, requires = "validate")]
    verify_hash: Option<String>,
    /// Override canonical hash for solve_h2.json if needed
    #[arg(long, requires = "validate")]
    solve_hash: Option<String>,
}

#[derive(Args, Clone)]
struct ProgenyArgs {
    /// Generate a tagged progeny build (stored under progeny/<name>)
    #[arg(long)]
    progeny: Option<String>,
    /// Root directory for progeny outputs
    #[arg(long, default_value = "audit/progeny")]
    progeny_root: PathBuf,
}

#[derive(Args, Clone)]
struct AuditReportArgs {
    /// Emit a summary report (JSON) describing deterministic runs
    #[arg(long)]
    audit_report: Option<PathBuf>,
    /// Directory to scan when assembling the report
    #[arg(long, default_value = "audit/runs")]
    report_source: PathBuf,
}

#[derive(Args, Clone)]
struct LineageBatchArgs {
    /// Execute the sealed progeny batch and capture deterministic hashes
    #[arg(long)]
    lineage_batch: bool,
    /// Root directory containing Z_P1_* sealed workspaces
    #[arg(long, default_value = "../01_PROVEN_LINEAGE")]
    lineage_root: PathBuf,
    /// Number of clean runs per workspace
    #[arg(long, default_value_t = 1)]
    lineage_runs: u32,
    /// Directory under the current workspace where batch logs are archived
    #[arg(long, default_value = "audit/lineage_batch")]
    lineage_output_dir: PathBuf,
}

struct GenesisContext {
    root: PathBuf,
    audit_log: PathBuf,
}

struct AuditLog {
    file: File,
}

impl AuditLog {
    fn new(path: &Path) -> Result<Self> {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).with_context(|| format!("creating audit dir {parent:?}"))?;
        }
        let file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(path)
            .with_context(|| format!("opening audit log {path:?}"))?;
        Ok(Self { file })
    }

    fn write(&mut self, line: &str) -> Result<()> {
        writeln!(self.file, "{} | {}", timestamp_utc(), line).with_context(|| "writing audit log")
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let ctx = GenesisContext::new()?;
    let mut audit = AuditLog::new(&ctx.audit_log)?;
    freeze_environment(&mut audit)?;

    if cli.protocol.protocol {
        run_protocol(&ctx, &cli.protocol, &mut audit)
    } else if let Some(runs) = cli.test.test_battery {
        run_test_battery(&ctx, &cli.test, runs, &mut audit)
    } else if cli.validate.validate {
        run_validate(&ctx, &cli.validate, &mut audit)
    } else if let Some(name) = &cli.progeny.progeny {
        run_progeny(&ctx, &cli.progeny, name, &mut audit)
    } else if let Some(path) = &cli.audit_report.audit_report {
        run_audit_report(&ctx, &cli.audit_report, path, &mut audit)
    } else if cli.lineage.lineage_batch {
        run_lineage_batch(&ctx, &cli.lineage, &mut audit)
    } else {
        bail!("no command matched; specify --protocol, --test-battery, --validate, --progeny, or --audit-report");
    }
}

fn run_lineage_batch(
    ctx: &GenesisContext,
    args: &LineageBatchArgs,
    audit: &mut AuditLog,
) -> Result<()> {
    if args.lineage_runs == 0 {
        bail!("lineage-batch requires at least one run per workspace");
    }
    let lineage_root = ctx.root.join(&args.lineage_root);
    if !lineage_root.exists() {
        bail!("lineage root {} does not exist", lineage_root.display());
    }
    if !lineage_root.is_dir() {
        bail!("lineage root {} is not a directory", lineage_root.display());
    }

    let workspaces = list_lineage_workspaces(&lineage_root)?;
    if workspaces.is_empty() {
        bail!(
            "no Z_P1_* workspaces discovered beneath {}",
            lineage_root.display()
        );
    }

    let output_root = ctx.root.join(&args.lineage_output_dir);
    fs::create_dir_all(&output_root)
        .with_context(|| format!("creating {}", output_root.display()))?;

    audit.write(&format!(
        "[LINEAGE] batch start root={} count={} runs_per_workspace={}",
        lineage_root.display(),
        workspaces.len(),
        args.lineage_runs
    ))?;

    let mut records = Vec::new();
    let mut baseline: HashMap<String, (String, String)> = HashMap::new();

    for (name, path) in &workspaces {
        let workspace_output = output_root.join(name);
        fs::create_dir_all(&workspace_output)
            .with_context(|| format!("creating {}", workspace_output.display()))?;

        for run_idx in 0..args.lineage_runs {
            let run_label = format!("{name}_run{run_idx:02}");
            audit.write(&format!("[LINEAGE] {run_label} start"))?;

            let log_path = workspace_output.join(format!("run{run_idx:02}.log"));
            let output = Command::new("./scripts/REBUILD_FROM_CLEAN.sh")
                .current_dir(path)
                .stdout(Stdio::piped())
                .stderr(Stdio::piped())
                .output()
                .with_context(|| {
                    format!("running REBUILD_FROM_CLEAN.sh within {}", path.display())
                })?;
            let stdout = String::from_utf8_lossy(&output.stdout);
            let stderr = String::from_utf8_lossy(&output.stderr);
            let mut combined = String::new();
            if !stdout.is_empty() {
                combined.push_str("===== STDOUT =====\n");
                combined.push_str(&stdout);
                if !stdout.ends_with('\n') {
                    combined.push('\n');
                }
            }
            if !stderr.is_empty() {
                combined.push_str("===== STDERR =====\n");
                combined.push_str(&stderr);
                if !stderr.ends_with('\n') {
                    combined.push('\n');
                }
            }
            fs::write(&log_path, combined)
                .with_context(|| format!("writing {}", log_path.display()))?;

            if !output.status.success() {
                bail!("lineage run {run_label} failed; see {}", log_path.display());
            }

            let verify_path = path.join("artifacts/verify.json");
            let solve_path = path.join("artifacts/solve_h2.json");
            let summary_path = path.join("receipts/VERIFY_SUMMARY.json");
            if !verify_path.exists() || !solve_path.exists() {
                bail!(
                    "expected artifacts not found after {run_label} (verify: {}, solve: {})",
                    verify_path.display(),
                    solve_path.display()
                );
            }

            canonicalize_verify_file(&verify_path)?;
            canonicalize_summary_file(&summary_path)?;
            rewrite_merkle(
                path,
                &[
                    verify_path.clone(),
                    solve_path.clone(),
                    summary_path.clone(),
                ],
            )?;

            let verify_hash = sha256_file(&verify_path)?;
            let solve_hash = sha256_file(&solve_path)?;
            audit.write(&format!("[LINEAGE] {run_label} verify={verify_hash}"))?;
            audit.write(&format!("[LINEAGE] {run_label} solve_h2={solve_hash}"))?;

            if let Some((baseline_verify, baseline_solve)) = baseline.get(name) {
                if !hashes_equal(&verify_hash, baseline_verify) {
                    bail!(
                        "verify.json hash drift detected for workspace {}: {} vs {}",
                        name,
                        verify_hash,
                        baseline_verify
                    );
                }
                if !hashes_equal(&solve_hash, baseline_solve) {
                    bail!(
                        "solve_h2.json hash drift detected for workspace {}: {} vs {}",
                        name,
                        solve_hash,
                        baseline_solve
                    );
                }
            } else {
                baseline.insert(name.clone(), (verify_hash.clone(), solve_hash.clone()));
            }

            let dest_merkle = workspace_output.join("MERKLE.txt");
            let src_merkle = path.join("receipts/MERKLE.txt");
            if src_merkle.exists() {
                fs::copy(&src_merkle, &dest_merkle)
                    .with_context(|| format!("copying {}", src_merkle.display()))?;
            }
            let dest_summary = workspace_output.join("VERIFY_SUMMARY.json");
            if summary_path.exists() {
                fs::copy(&summary_path, &dest_summary)
                    .with_context(|| format!("copying {}", summary_path.display()))?;
            }

            records.push(RunRecord {
                label: run_label,
                verify_hash,
                solve_hash,
            });
        }
    }

    write_hash_ledger(&output_root, &records)?;

    let mut summary: Vec<(String, (String, String))> = baseline.into_iter().collect();
    summary.sort_by(|a, b| a.0.cmp(&b.0));

    println!(
        "Lineage batch complete: {} workspace(s), {} total run(s)",
        summary.len(),
        records.len()
    );
    for (name, (verify, solve)) in &summary {
        println!(
            "{} -> verify.json {} | solve_h2.json {}",
            name, verify, solve
        );
    }
    println!(
        "Hash ledger saved to {}",
        output_root.join("hashes.tsv").display()
    );

    audit.write(&format!(
        "[LINEAGE] batch complete; ledger at {}/hashes.tsv",
        output_root.display()
    ))?;

    Ok(())
}

fn run_protocol(ctx: &GenesisContext, args: &ProtocolArgs, audit: &mut AuditLog) -> Result<()> {
    if args.env_report_only {
        println!(
            "Environment frozen. Audit log at {}",
            ctx.audit_log.display()
        );
        return Ok(());
    }

    if args.runs == 0 {
        bail!("runs must be >= 1");
    }

    let output_dir = ctx.root.join(&args.output_dir);
    let records = execute_runs(
        ctx,
        audit,
        args.runs,
        &output_dir,
        args.config.as_ref(),
        args.capsule.as_ref(),
    )?;
    validate_consistency(&records)?;
    write_hash_ledger(&output_dir, &records)?;
    print_summary(&records);
    Ok(())
}

fn run_test_battery(
    ctx: &GenesisContext,
    args: &TestBatteryArgs,
    runs: u32,
    audit: &mut AuditLog,
) -> Result<()> {
    if runs == 0 {
        bail!("test-battery requires at least one run");
    }
    let output_dir = ctx.root.join(&args.test_output_dir);
    let records = execute_runs(ctx, audit, runs, &output_dir, None, None)?;
    validate_consistency(&records)?;
    write_hash_ledger(&output_dir, &records)?;
    audit.write(&format!(
        "[TEST] completed {runs} run(s); summary stored at {}/hashes.tsv",
        output_dir.display()
    ))?;
    print_summary(&records);
    Ok(())
}

fn run_validate(ctx: &GenesisContext, args: &ValidateArgs, audit: &mut AuditLog) -> Result<()> {
    let reference_dir = ctx.root.join(&args.reference_dir);
    let (verify_hash, solve_hash) = load_run_hashes(&reference_dir)?;
    let expected_verify = args.verify_hash.as_deref().unwrap_or(CANONICAL_VERIFY_HASH);
    let expected_solve = args.solve_hash.as_deref().unwrap_or(CANONICAL_SOLVE_HASH);
    let verify_match = hashes_equal(&verify_hash, expected_verify);
    let solve_match = hashes_equal(&solve_hash, expected_solve);
    audit.write(&format!(
        "[VALIDATE] dir={} verify={verify_hash} solve={solve_hash}",
        reference_dir.display()
    ))?;
    if verify_match && solve_match {
        println!("Validation OK against canonical hashes.");
        Ok(())
    } else {
        bail!("validation failed: verify match = {verify_match}, solve match = {solve_match}")
    }
}

fn run_progeny(
    ctx: &GenesisContext,
    args: &ProgenyArgs,
    name: &str,
    audit: &mut AuditLog,
) -> Result<()> {
    let sanitized = sanitize_label(name);
    if sanitized.is_empty() {
        bail!("progeny name must contain alphanumeric characters");
    }
    let progeny_root = ctx.root.join(&args.progeny_root);
    fs::create_dir_all(&progeny_root)?;
    let output_dir = progeny_root.join(&sanitized);
    let records = execute_runs(ctx, audit, 1, &output_dir, None, None)?;
    write_hash_ledger(&output_dir, &records)?;
    audit.write(&format!(
        "[PROGENY] {} stored at {}",
        sanitized,
        output_dir.display()
    ))?;
    print_summary(&records);
    Ok(())
}

fn run_audit_report(
    ctx: &GenesisContext,
    args: &AuditReportArgs,
    output: &PathBuf,
    audit: &mut AuditLog,
) -> Result<()> {
    let source_dir = ctx.root.join(&args.report_source);
    let runs = find_run_directories(&source_dir)?;
    let mut records = Vec::new();
    for (label, dir) in &runs {
        let (verify, solve) = load_run_hashes(dir)?;
        records.push(json!({
            "label": label,
            "dir": dir.strip_prefix(&ctx.root).unwrap_or(dir).display().to_string(),
            "verify_hash": verify,
            "solve_h2_hash": solve
        }));
    }
    let report = json!({
        "generated_at": timestamp_utc(),
        "canonical": {
            "verify": CANONICAL_VERIFY_HASH,
            "solve_h2": CANONICAL_SOLVE_HASH
        },
        "run_count": records.len(),
        "runs": records
    });
    let output_path = ctx.root.join(output);
    if let Some(parent) = output_path.parent() {
        fs::create_dir_all(parent)?;
    }
    fs::write(&output_path, serde_json::to_string_pretty(&report)?)?;
    audit.write(&format!(
        "[AUDIT] report written to {} ({} runs)",
        output_path.display(),
        runs.len()
    ))?;
    println!("Audit report saved to {}", output_path.display());
    Ok(())
}

fn list_lineage_workspaces(root: &Path) -> Result<Vec<(String, PathBuf)>> {
    let mut workspaces = Vec::new();
    if !root.exists() {
        return Ok(workspaces);
    }

    for entry in fs::read_dir(root)? {
        let entry = entry?;
        if !entry.file_type()?.is_dir() {
            continue;
        }
        let name = entry.file_name().to_string_lossy().into_owned();
        if !name.starts_with("Z_P1_") {
            continue;
        }
        let rebuild = entry.path().join("scripts/REBUILD_FROM_CLEAN.sh");
        if rebuild.exists() {
            workspaces.push((name, entry.path()));
        }
    }
    workspaces.sort_by(|a, b| a.0.cmp(&b.0));
    Ok(workspaces)
}

fn freeze_environment(audit: &mut AuditLog) -> Result<()> {
    let pairs = [
        ("LC_ALL", "C"),
        ("LANG", "C"),
        ("TZ", "UTC"),
        ("UMASK", "022"),
        ("SOURCE_DATE_EPOCH", "1704067200"),
        ("CLICOLOR", "0"),
    ];
    for (key, val) in pairs {
        env::set_var(key, val);
    }
    audit.write("[ENV] LC_ALL=C LANG=C TZ=UTC UMASK=022 SOURCE_DATE_EPOCH=1704067200 CLICOLOR=0")
}

fn clean_outputs(ctx: &GenesisContext) -> Result<()> {
    for name in ["artifacts", "receipts", "public"] {
        let path = ctx.root.join(name);
        if path.exists() {
            fs::remove_dir_all(&path).with_context(|| format!("removing {name}"))?;
        }
        fs::create_dir_all(&path).with_context(|| format!("creating {name}"))?;
    }
    Ok(())
}

fn policy_check(ctx: &GenesisContext, audit: &mut AuditLog) -> Result<()> {
    let script = ctx.root.join("scripts/POLICY_CHECK.sh");
    run_command_path(ctx, audit, &script, &[])
}

fn reset_config(ctx: &GenesisContext, audit: &mut AuditLog) -> Result<()> {
    let path = ctx.root.join("configs/CONFIG.json");
    let mut data: Value =
        serde_json::from_reader(File::open(&path).with_context(|| "reading CONFIG.json")?)
            .with_context(|| "parsing CONFIG.json")?;
    if !data.is_object() {
        bail!("CONFIG.json root must be an object");
    }
    let obj = data.as_object_mut().unwrap();
    obj.insert("yantra".to_string(), json!({"layout": "TEST_TRIADS"}));

    let lift = obj
        .entry("lift_3d".to_string())
        .or_insert_with(|| Value::Object(Map::new()))
        .as_object_mut()
        .context("lift_3d must be object")?;
    lift.insert("pitch".to_string(), Value::String("1/1".into()));
    lift.insert("rotation_t".to_string(), Value::String("1/2".into()));
    lift.insert("rotor_t_half".to_string(), Value::String("1/3".into()));
    lift.insert(
        "base_radii".to_string(),
        Value::Array(
            vec!["1/1", "2/1", "3/1"]
                .into_iter()
                .map(|s| Value::String(s.into()))
                .collect(),
        ),
    );

    let pretty = serde_json::to_string_pretty(&data)?;
    fs::write(&path, format!("{pretty}\n")).with_context(|| "writing CONFIG.json")?;
    audit.write("[CONFIG] baseline restored")
}

fn apply_config_override(
    ctx: &GenesisContext,
    audit: &mut AuditLog,
    override_path: &Path,
) -> Result<()> {
    let source = if override_path.is_absolute() {
        override_path.to_path_buf()
    } else {
        ctx.root.join(override_path)
    };
    if !source.exists() {
        bail!("config override {} does not exist", source.display());
    }
    let body = fs::read_to_string(&source)
        .with_context(|| format!("reading config override {}", source.display()))?;
    let value: Value = match source.extension().and_then(|ext| ext.to_str()) {
        Some(ext) if ext.eq_ignore_ascii_case("toml") => toml::from_str(&body)
            .with_context(|| format!("parsing TOML config override {}", source.display()))?,
        _ => serde_json::from_str(&body)
            .with_context(|| format!("parsing JSON config override {}", source.display()))?,
    };
    let dest = ctx.root.join("configs/CONFIG.json");
    reset_config(ctx, audit)?;
    let mut base: Value = serde_json::from_reader(
        File::open(&dest).with_context(|| format!("reading baseline config {}", dest.display()))?,
    )
    .with_context(|| "parsing baseline CONFIG.json")?;
    merge_json(&mut base, &value);
    write_sorted_json(&dest, &base)?;
    audit.write(&format!(
        "[CONFIG] override applied from {}",
        source.strip_prefix(&ctx.root).unwrap_or(&source).display()
    ))
}

fn run_command(
    ctx: &GenesisContext,
    audit: &mut AuditLog,
    program: &str,
    args: &[&str],
) -> Result<()> {
    audit.write(&format!(
        "[CMD] {} {}",
        program,
        if args.is_empty() {
            String::new()
        } else {
            args.join(" ")
        }
    ))?;
    let status = Command::new(program)
        .args(args)
        .current_dir(&ctx.root)
        .status()
        .with_context(|| format!("running {program}"))?;
    if !status.success() {
        bail!("command {program} failed with status {status:?}");
    }
    Ok(())
}

fn run_command_path(
    ctx: &GenesisContext,
    audit: &mut AuditLog,
    program: &Path,
    args: &[&str],
) -> Result<()> {
    audit.write(&format!(
        "[CMD] {} {}",
        program.display(),
        if args.is_empty() {
            String::new()
        } else {
            args.join(" ")
        }
    ))?;
    let status = Command::new(program)
        .args(args)
        .current_dir(&ctx.root)
        .status()
        .with_context(|| format!("running {}", program.display()))?;
    if !status.success() {
        bail!("command {} failed", program.display());
    }
    Ok(())
}

fn run_script(ctx: &GenesisContext, audit: &mut AuditLog, rel: &str) -> Result<()> {
    run_command_path(ctx, audit, &ctx.root.join(rel), &[])
}

fn check_gate_summary(ctx: &GenesisContext) -> Result<()> {
    let path = ctx.root.join("artifacts/verify.json");
    let value: Value = serde_json::from_reader(File::open(&path)?)?;
    let summary = value.get("gate_summary").context("gate_summary missing")?;
    let ok = summary
        .get("gates_ok")
        .and_then(Value::as_bool)
        .unwrap_or(false)
        && summary
            .get("cad_sos_present")
            .and_then(Value::as_bool)
            .unwrap_or(false);
    if ok {
        Ok(())
    } else {
        bail!("gate summary check failed")
    }
}

fn refresh_receipts(ctx: &GenesisContext, audit: &mut AuditLog) -> Result<()> {
    let artifacts = ctx.root.join("artifacts");
    let receipts = ctx.root.join("receipts");
    fs::create_dir_all(&receipts)?;

    let verify_path = artifacts.join("verify.json");
    let solve_path = artifacts.join("solve_h2.json");
    let summary_path = receipts.join("VERIFY_SUMMARY.json");

    let mut verify_value: Value = serde_json::from_reader(File::open(&verify_path)?)?;
    if let Some(obj) = verify_value.as_object_mut() {
        obj.insert(
            "timestamp".to_string(),
            Value::String("DETERMINISTIC_BUILD".into()),
        );
    }
    write_sorted_json(&verify_path, &verify_value)?;

    let summary = json!({
        "ts_utc": "DETERMINISTIC_BUILD",
        "gates": verify_value
            .get("gate_summary")
            .cloned()
            .unwrap_or(Value::Object(Map::new())),
        "cad_sos": verify_value
            .get("sidecars")
            .and_then(|s| s.get("D_cad_sos"))
            .cloned()
            .unwrap_or(Value::Object(Map::new())),
    });
    write_sorted_json(&summary_path, &summary)?;

    canonicalize_summary_file(&summary_path)?;
    rewrite_merkle(&ctx.root, &[verify_path, solve_path, summary_path])?;
    audit.write("[RECEIPTS] refreshed")
}

fn sort_json(value: &Value) -> Value {
    match value {
        Value::Object(map) => {
            let mut sorted = map
                .iter()
                .map(|(k, v)| (k.clone(), sort_json(v)))
                .collect::<Vec<_>>();
            sorted.sort_by(|a, b| a.0.cmp(&b.0));
            let mut new_map = Map::new();
            for (k, v) in sorted {
                new_map.insert(k, v);
            }
            Value::Object(new_map)
        }
        Value::Array(arr) => Value::Array(arr.iter().map(sort_json).collect()),
        _ => value.clone(),
    }
}

fn write_sorted_json(path: &Path, value: &Value) -> Result<()> {
    let sorted = sort_json(value);
    let mut body = serde_json::to_string_pretty(&sorted)?;
    body.push('\n');
    fs::write(path, body)?;
    Ok(())
}

fn merge_json(base: &mut Value, patch: &Value) {
    match (base, patch) {
        (Value::Object(base_map), Value::Object(patch_map)) => {
            for (key, patch_value) in patch_map {
                match base_map.get_mut(key) {
                    Some(base_value) => merge_json(base_value, patch_value),
                    None => {
                        base_map.insert(key.clone(), patch_value.clone());
                    }
                }
            }
        }
        (base_slot, patch_value) => {
            *base_slot = patch_value.clone();
        }
    }
}

fn canonicalize_verify_file(path: &Path) -> Result<()> {
    if !path.exists() {
        return Ok(());
    }
    let mut value: Value = serde_json::from_reader(File::open(path)?)?;
    if let Some(obj) = value.as_object_mut() {
        obj.insert(
            "timestamp".to_string(),
            Value::String("DETERMINISTIC_BUILD".into()),
        );
    }
    write_sorted_json(path, &value)
}

fn canonicalize_summary_file(path: &Path) -> Result<()> {
    if !path.exists() {
        return Ok(());
    }
    let mut value: Value = serde_json::from_reader(File::open(path)?)?;
    if let Some(obj) = value.as_object_mut() {
        obj.insert(
            "ts_utc".to_string(),
            Value::String("DETERMINISTIC_BUILD".into()),
        );
        if obj.contains_key("timestamp") {
            obj.insert(
                "timestamp".to_string(),
                Value::String("DETERMINISTIC_BUILD".into()),
            );
        }
    }
    write_sorted_json(path, &value)
}

fn rewrite_merkle(workspace: &Path, files: &[PathBuf]) -> Result<()> {
    let mut entries = Vec::new();
    for path in files {
        if path.exists() {
            let rel = path
                .strip_prefix(workspace)
                .unwrap_or(path)
                .display()
                .to_string();
            let rel = rel.replace('\\', "/");
            entries.push((rel, sha256_file(path)?));
        }
    }
    if entries.is_empty() {
        return Ok(());
    }
    entries.sort_by(|a, b| a.0.cmp(&b.0));
    let mut body = String::new();
    for (rel, hash) in entries {
        body.push_str(&format!("{hash}  {rel}\n"));
    }
    let merkle_path = workspace.join("receipts/MERKLE.txt");
    fs::create_dir_all(
        merkle_path
            .parent()
            .context("MERKLE.txt parent directory missing")?,
    )?;
    fs::write(merkle_path, body)?;
    Ok(())
}

fn sha256_file(path: &Path) -> Result<String> {
    let mut file = File::open(path).with_context(|| format!("opening {path:?}"))?;
    let mut hasher = Sha256::new();
    let mut buf = [0u8; 8192];
    loop {
        let n = file.read(&mut buf)?;
        if n == 0 {
            break;
        }
        hasher.update(&buf[..n]);
    }
    Ok(format!("{:x}", hasher.finalize()))
}

fn copy_dir(src: &Path, dst: &Path) -> Result<()> {
    fs::create_dir_all(dst)?;
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let file_type = entry.file_type()?;
        let target = dst.join(entry.file_name());
        if file_type.is_dir() {
            copy_dir(&entry.path(), &target)?;
        } else {
            fs::copy(entry.path(), target)?;
        }
    }
    Ok(())
}

impl GenesisContext {
    fn new() -> Result<Self> {
        let root = env::current_dir().with_context(|| "reading cwd")?;
        let audit_log = root.join("audit/genesis.log");
        Ok(Self { root, audit_log })
    }
}

fn timestamp_utc() -> String {
    Utc::now().to_rfc3339()
}

fn execute_runs(
    ctx: &GenesisContext,
    audit: &mut AuditLog,
    runs: u32,
    output_dir: &Path,
    config_override: Option<&PathBuf>,
    capsule_root: Option<&PathBuf>,
) -> Result<Vec<RunRecord>> {
    fs::create_dir_all(output_dir)?;
    let config_override = config_override.map(|path| {
        if path.is_absolute() {
            path.clone()
        } else {
            ctx.root.join(path)
        }
    });
    let capsule_root = capsule_root.map(|path| {
        if path.is_absolute() {
            path.clone()
        } else {
            ctx.root.join(path)
        }
    });
    if let Some(root) = &capsule_root {
        fs::create_dir_all(root)?;
    }
    let mut results = Vec::new();
    for run_idx in 0..runs {
        let run_label = format!("run{run_idx:02}");
        audit.write(&format!("[RUN {run_label}] start"))?;

        clean_outputs(ctx)?;
        policy_check(ctx, audit)?;
        if let Some(cfg) = &config_override {
            apply_config_override(ctx, audit, cfg)?;
        } else {
            reset_config(ctx, audit)?;
        }
        run_command(ctx, audit, "cargo", &["build", "--locked"])?;
        run_command(
            ctx,
            audit,
            "cargo",
            &["test", "--workspace", "--", "--nocapture"],
        )?;
        run_script(ctx, audit, "scripts/REPRODUCE.sh")?;
        run_script(ctx, audit, "scripts/REPORT.sh")?;
        check_gate_summary(ctx)?;
        refresh_receipts(ctx, audit)?;

        let verify_path = ctx.root.join("artifacts/verify.json");
        let solve_path = ctx.root.join("artifacts/solve_h2.json");
        let verify_hash = sha256_file(&verify_path)?;
        let solve_hash = sha256_file(&solve_path)?;
        audit.write(&format!("[RUN {run_label}] verify={verify_hash}"))?;
        audit.write(&format!("[RUN {run_label}] solve_h2={solve_hash}"))?;

        let dest = output_dir.join(&run_label);
        copy_run_outputs(ctx, &dest)?;
        if let Some(root) = &capsule_root {
            let capsule_dest = root.join(&run_label);
            copy_run_outputs(ctx, &capsule_dest)?;
        }

        results.push(RunRecord {
            label: run_label,
            verify_hash,
            solve_hash,
        });
    }
    Ok(results)
}

fn copy_run_outputs(ctx: &GenesisContext, dest: &Path) -> Result<()> {
    if dest.exists() {
        fs::remove_dir_all(dest)?;
    }
    fs::create_dir_all(dest)?;
    for name in ["artifacts", "receipts", "public"] {
        let source = ctx.root.join(name);
        if source.exists() {
            copy_dir(&source, &dest.join(name))?;
        }
    }
    Ok(())
}

fn write_hash_ledger(output_dir: &Path, records: &[RunRecord]) -> Result<()> {
    if records.is_empty() {
        return Ok(());
    }
    let ledger = output_dir.join("hashes.tsv");
    let mut file = File::create(&ledger)?;
    for rec in records {
        writeln!(file, "{}\tverify.json\t{}", rec.label, rec.verify_hash)?;
        writeln!(file, "{}\tsolve_h2.json\t{}", rec.label, rec.solve_hash)?;
    }
    Ok(())
}

fn load_run_hashes(dir: &Path) -> Result<(String, String)> {
    let verify = sha256_file(&dir.join("artifacts/verify.json"))?;
    let solve = sha256_file(&dir.join("artifacts/solve_h2.json"))?;
    Ok((verify, solve))
}

fn hashes_equal(actual: &str, expected: &str) -> bool {
    actual.eq_ignore_ascii_case(expected)
}

fn find_run_directories(root: &Path) -> Result<Vec<(String, PathBuf)>> {
    if root.join("artifacts/verify.json").exists() {
        return Ok(vec![(
            root.file_name()
                .map(|s| s.to_string_lossy().into_owned())
                .unwrap_or_else(|| "run".into()),
            root.to_path_buf(),
        )]);
    }

    let mut runs = Vec::new();
    if root.is_dir() {
        for entry in fs::read_dir(root)? {
            let entry = entry?;
            if entry.file_type()?.is_dir() {
                let subdir = entry.path();
                if subdir.join("artifacts/verify.json").exists() {
                    let label = entry.file_name().to_string_lossy().into_owned();
                    runs.push((label, subdir));
                }
            }
        }
    }
    Ok(runs)
}

fn sanitize_label(input: &str) -> String {
    let mut sanitized = String::new();
    for ch in input.chars() {
        if ch.is_ascii_alphanumeric() || matches!(ch, '-' | '_') {
            sanitized.push(ch);
        } else if sanitized.ends_with('_') {
            continue;
        } else {
            sanitized.push('_');
        }
    }
    sanitized.trim_matches('_').to_string()
}

fn validate_consistency(records: &[RunRecord]) -> Result<()> {
    if records.is_empty() {
        return Ok(());
    }
    let first_verify = &records[0].verify_hash;
    let first_solve = &records[0].solve_hash;
    for rec in records.iter().skip(1) {
        if !hashes_equal(&rec.verify_hash, first_verify) {
            bail!(
                "verify hash mismatch on {}: {} vs {}",
                rec.label,
                rec.verify_hash,
                first_verify
            );
        }
        if !hashes_equal(&rec.solve_hash, first_solve) {
            bail!(
                "solve hash mismatch on {}: {} vs {}",
                rec.label,
                rec.solve_hash,
                first_solve
            );
        }
    }
    Ok(())
}

fn print_summary(records: &[RunRecord]) {
    if records.is_empty() {
        return;
    }
    println!("Deterministic protocol completed: {} run(s)", records.len());
    println!("Canonical verify.json SHA-256: {}", records[0].verify_hash);
    println!("Canonical solve_h2.json SHA-256: {}", records[0].solve_hash);
}

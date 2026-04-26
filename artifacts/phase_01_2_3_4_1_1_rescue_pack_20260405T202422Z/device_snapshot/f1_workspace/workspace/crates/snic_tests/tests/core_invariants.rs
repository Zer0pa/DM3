use serde_json::json;

fn baseline_cfg() -> serde_json::Value {
    json!({
        "yantra": {"layout":"TEST_TRIADS"},
        "lift_3d": {"pitch":"1/1","rotation_t":"1/2","rotor_t_half":"1/3","base_radii":["1/1","2/1","3/1"]},
        "deq": {"solver":"MonDEQ","jacobian_spectral_bound_max":"164/165","laplacian_positional_encoding":true,"harmonic_drives":["3:2","4:3"],"deterministic_jitter_policy":"cfg_hash_derived"}
    })
}

#[test]
fn gc_bareiss_snapshot_numbers_and_deq_flags() {
    let cfg = baseline_cfg();
    let g = yantra_2d::build_base_graph_from_cfg(&cfg);

    let (status, sidecars) = proof_gates::run_sidecars(&g, &cfg);
    assert!(
        status.gc_invariants_pass && status.dep_cert_present,
        "A/B/C must be structurally OK"
    );

    let gc = sidecars.get("C_gc").expect("C_gc sidecar missing");
    let col = gc
        .get("collinear_triplets")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let deg = gc
        .get("max_concurrency_degree")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    assert!(col >= 60, "collinear_triplets too small: {}", col);
    assert!(deg >= 3, "max_concurrency_degree unexpected: {}", deg);

    let cfg_v = serde_json::json!({"deq":{"drive_mode":"uniform"}});
    let (_json_out, rep) = dynamics_deq::solve_h2(&g, &cfg_v);
    assert!(
        rep.delta_e_monotone && rep.jac_spectral_bound_ok && rep.mode_lock_pass,
        "DEQ stability flags must be true: {:?}",
        rep
    );
}

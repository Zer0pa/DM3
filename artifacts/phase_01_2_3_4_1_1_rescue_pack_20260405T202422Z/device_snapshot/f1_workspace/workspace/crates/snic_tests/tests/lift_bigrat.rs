use serde_json::json;

fn cfg_with(pitch: &str, rotation_t: &str, rotor_t_half: &str) -> serde_json::Value {
    json!({
        "yantra": {"layout":"TEST_TRIADS"},
        "lift_3d": {
            "pitch": pitch, "rotation_t": rotation_t, "rotor_t_half": rotor_t_half,
            "base_radii": ["1/1","2/1","3/1"]
        },
        "deq": {
            "solver":"MonDEQ",
            "jacobian_spectral_bound_max":"164/165",
            "laplacian_positional_encoding": true,
            "harmonic_drives":["3:2","4:3"],
            "deterministic_jitter_policy":"cfg_hash_derived"
        }
    })
}

fn assert_lift_ok(pitch: &str, rot: &str, half: &str) {
    let cfg = cfg_with(pitch, rot, half);
    let g = yantra_2d::build_base_graph_from_cfg(&cfg);
    let l3 = lift_3d::lift_to_3d(&g, &cfg);
    let inv = lift_3d::check_invariants(&l3, &cfg);
    assert!(
        inv["pass"].as_bool().unwrap_or(false),
        "LIFT invariants failed for pitch={}, rot={}, half={}: {}",
        pitch,
        rot,
        half,
        inv
    );
}

#[test]
fn lift_bigrational_baseline_and_grid() {
    // Baseline
    assert_lift_ok("1/1", "1/2", "1/3");

    // Grid including former overflow (case #14)
    let combos = [
        ("2/1", "1/3", "1/4"),
        ("3/2", "1/4", "1/5"),
        ("1/2", "2/3", "1/5"),
        ("2/3", "3/4", "1/6"),
        ("3/1", "1/5", "1/6"),
        ("1/3", "2/5", "1/7"),
        ("4/3", "1/6", "1/4"),
        ("5/3", "2/7", "1/8"),
        ("3/5", "1/7", "1/9"),
        ("5/4", "3/5", "1/3"),
        ("4/5", "2/3", "2/5"),
        ("7/5", "3/7", "2/7"),
        ("5/7", "4/7", "3/7"), // former overflow
        ("6/5", "1/8", "1/5"),
        ("8/5", "2/9", "1/10"),
        ("5/8", "3/8", "1/4"),
        ("7/6", "1/9", "2/9"),
    ];
    for (p, r, h) in combos {
        assert_lift_ok(p, r, h);
    }
}

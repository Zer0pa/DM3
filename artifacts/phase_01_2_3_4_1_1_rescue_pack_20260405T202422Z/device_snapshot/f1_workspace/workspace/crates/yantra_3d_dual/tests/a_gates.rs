use lift_3d::{build_helix_meru, HelixMeruParams};
use num_rational::BigRational as Q;
use std::str::FromStr;
use yantra_3d_dual::{build_dual_meru, check_a_gates, DualMeruParams};

fn q(raw: &str) -> Q {
    Q::from_str(raw).expect("valid rational")
}

#[test]
fn a1_a4_basic_geometry_passes_on_dual() {
    let helix_params = HelixMeruParams {
        radius: q("1/1"),
        pitch: q("1/2"),
        ..Default::default()
    };
    let helix = build_helix_meru(&helix_params);
    let dual_params = DualMeruParams {
        radius: q("1/1"),
        pitch: q("1/2"),
    };
    let dual = build_dual_meru(&helix, &dual_params);
    let rep = check_a_gates(&dual);
    assert_eq!(rep.a1_symmetry_continuity, "pass");
    assert_eq!(rep.a3_piecewise_monotone_z, "pass");
    assert_eq!(rep.a4_curvature_torsion, "pass");
}

#[test]
fn a2_concurrency_and_euler_sane() {
    let helix_params = HelixMeruParams {
        radius: q("1/1"),
        pitch: q("1/2"),
        ..Default::default()
    };
    let helix = build_helix_meru(&helix_params);
    let dual_params = DualMeruParams {
        radius: q("1/1"),
        pitch: q("1/2"),
    };
    let dual = build_dual_meru(&helix, &dual_params);
    let rep = check_a_gates(&dual);
    assert_eq!(rep.a2_concurrency_regions, "pass");
    assert_eq!(
        rep.euler.cone_plus.v_minus_e_plus_f,
        rep.euler.cone_minus.v_minus_e_plus_f
    );
}

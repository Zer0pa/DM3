#![deny(warnings)]
mod cad_sos;
use egg::{rewrite as rw, *};
use num_rational::Rational64 as Q;
use serde_json::{json, Value};
use std::collections::HashSet;
use yantra_2d::{Point, YantraGraph};

#[derive(Default, serde::Serialize)]
pub struct GateStatus {
    pub gates_ok: bool,
    pub egraph_proof_valid: bool,
    pub dep_cert_present: bool,
    pub gc_invariants_pass: bool,
    pub cad_sos_present: bool,
}

pub fn run_sidecars(g: &YantraGraph, cfg: &Value) -> (GateStatus, Value) {
    let (ok_a, a_json) = gate_egraph_demo();
    let (ok_b, b_json) = gate_bareiss_dep_cert_geometry(g);
    let (ok_c, c_json) = gate_gc(g);
    let (ok_d, d_json) = cad_sos::run(g, cfg);

    let status = GateStatus {
        gates_ok: ok_a && ok_b && ok_c && ok_d,
        egraph_proof_valid: ok_a,
        dep_cert_present: ok_b,
        gc_invariants_pass: ok_c,
        cad_sos_present: ok_d,
    };
    (
        status,
        json!({"A_egraph":a_json,"B_bareiss":b_json,"C_gc":c_json,"D_cad_sos":d_json}),
    )
}

/* -------- Gate A: e-graph demo (deterministic equality proof) -------- */
fn gate_egraph_demo() -> (bool, Value) {
    define_language! {
        enum Math {
            Num(i64),
            "+" = Add([Id; 2]),
        }
    }
    let mut egraph = EGraph::<Math, ()>::default();
    let add_comm = rw!("comm"; "(+ ?a ?b)" => "(+ ?b ?a)");
    let add_assoc = rw!("assoc"; "(+ ?a (+ ?b ?c))" => "(+ (+ ?a ?b) ?c)");

    let expr1: RecExpr<Math> = "(+ 1 (+ 2 3))".parse().unwrap();
    let expr2: RecExpr<Math> = "(+ (+ 3 2) 1)".parse().unwrap();
    let id1 = egraph.add_expr(&expr1);
    let id2 = egraph.add_expr(&expr2);
    let runner = Runner::default()
        .with_egraph(egraph)
        .run(&[add_comm, add_assoc]);
    let same = runner.egraph.find(id1) == runner.egraph.find(id2);
    (same, json!({"same_class":same,"note":"demo equality"}))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Line {
    a: Q,
    b: Q,
    c: Q,
}

fn q(n: i64) -> Q {
    Q::from_integer(n)
}

fn make_line(p: &Point, q_pt: &Point) -> Line {
    let a = q_pt.y - p.y;
    let b = p.x - q_pt.x;
    let c = -(a * p.x + b * p.y);
    let mut line = Line { a, b, c };
    if line.a < q(0)
        || (line.a == q(0) && line.b < q(0))
        || (line.a == q(0) && line.b == q(0) && line.c < q(0))
    {
        line.a = -line.a;
        line.b = -line.b;
        line.c = -line.c;
    }
    line
}

fn eval(line: &Line, point: &Point) -> Q {
    line.a * point.x + line.b * point.y + line.c
}

fn gcd_i64(mut a: i64, mut b: i64) -> i64 {
    a = a.abs();
    b = b.abs();
    if a == 0 {
        return if b == 0 { 1 } else { b };
    }
    if b == 0 {
        return a;
    }
    while b != 0 {
        let tmp = a % b;
        a = b;
        b = tmp;
    }
    if a == 0 {
        1
    } else {
        a
    }
}

fn gcd_i128(mut a: i128, mut b: i128) -> i128 {
    a = a.abs();
    b = b.abs();
    if a == 0 {
        return if b == 0 { 1 } else { b };
    }
    if b == 0 {
        return a;
    }
    while b != 0 {
        let tmp = a % b;
        a = b;
        b = tmp;
    }
    if a == 0 {
        1
    } else {
        a
    }
}

fn lcm_i64(a: i64, b: i64) -> i64 {
    if a == 0 || b == 0 {
        return 0;
    }
    (a / gcd_i64(a, b)) * b
}

fn line_signature(line: &Line) -> (i128, i128, i128) {
    let den_a = *line.a.denom();
    let den_b = *line.b.denom();
    let den_c = *line.c.denom();

    let mut lcm = lcm_i64(den_a as i64, den_b as i64);
    lcm = lcm_i64(lcm, den_c as i64);
    if lcm == 0 {
        lcm = 1;
    }
    let lcm_i = lcm as i128;

    let a_scaled = (*line.a.numer() as i128) * (lcm_i / den_a as i128);
    let b_scaled = (*line.b.numer() as i128) * (lcm_i / den_b as i128);
    let c_scaled = (*line.c.numer() as i128) * (lcm_i / den_c as i128);

    let mut g = gcd_i128(gcd_i128(a_scaled, b_scaled), c_scaled);
    if g == 0 {
        g = 1;
    }

    let mut a_norm = a_scaled / g;
    let mut b_norm = b_scaled / g;
    let mut c_norm = c_scaled / g;

    if a_norm < 0 || (a_norm == 0 && b_norm < 0) || (a_norm == 0 && b_norm == 0 && c_norm < 0) {
        a_norm = -a_norm;
        b_norm = -b_norm;
        c_norm = -c_norm;
    }

    (a_norm, b_norm, c_norm)
}

fn to_int_normal(line: &Line) -> (i128, i128) {
    let sig = line_signature(line);
    let mut a = sig.0;
    let mut b = sig.1;
    let g = gcd_i128(a, b);
    if g != 0 {
        a /= g;
        b /= g;
    }
    (a, b)
}

fn gate_bareiss_dep_cert_geometry(g: &YantraGraph) -> (bool, Value) {
    if g.vertices.len() < 2 {
        return (false, json!({"error":"insufficient vertices"}));
    }

    let mut lines: Vec<Line> = Vec::new();
    let mut seen: HashSet<(i128, i128, i128)> = HashSet::new();
    for i in 0..g.vertices.len() {
        let (_, pi) = &g.vertices[i];
        for j in (i + 1)..g.vertices.len() {
            let (_, pj) = &g.vertices[j];
            let candidate = make_line(pi, pj);
            let sig = line_signature(&candidate);
            if seen.insert(sig) {
                lines.push(candidate);
            }
        }
    }

    if lines.len() < 2 {
        return (false, json!({"error":"need at least two distinct lines"}));
    }

    let mut counts: Vec<(usize, i64)> = Vec::new();
    for (idx, line) in lines.iter().enumerate() {
        let mut incidence = 0i64;
        for (_, point) in g.vertices.iter() {
            if eval(line, point) == q(0) {
                incidence += 1;
            }
        }
        counts.push((idx, incidence));
    }
    counts.sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));

    let mut normals: Vec<(i128, i128)> = Vec::new();
    for (idx, _) in counts.iter().take(3) {
        normals.push(to_int_normal(&lines[*idx]));
    }
    if normals.len() < 2 {
        return (false, json!({"error":"unable to gather enough normals"}));
    }

    let mut g00: i128 = 0;
    let mut g01: i128 = 0;
    let mut g11: i128 = 0;
    for (a, b) in normals.iter() {
        g00 += a * a;
        g01 += a * b;
        g11 += b * b;
    }

    let det = g00 * g11 - g01 * g01;
    let rank = if det != 0 {
        2
    } else if g00 != 0 || g11 != 0 || g01 != 0 {
        1
    } else {
        0
    };
    let ok = rank == 2;

    (
        ok,
        json!({
            "selected_normals": normals,
            "G": {"g00": g00, "g01": g01, "g11": g11, "det": det},
            "rank": rank,
            "certificate": "rank(A)=2 via det(A^T A)!=0 (fraction-free integer arithmetic)"
        }),
    )
}

/* -------- Gate C: GC invariants (already exact via invariants crate) -------- */
fn gate_gc(g: &YantraGraph) -> (bool, Value) {
    let invariants = invariants::gc_invariants(g);
    let pass = invariants
        .get("pass")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);
    (pass, invariants)
}

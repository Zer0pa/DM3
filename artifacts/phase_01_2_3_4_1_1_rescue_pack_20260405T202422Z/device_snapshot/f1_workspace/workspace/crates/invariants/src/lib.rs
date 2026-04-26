#![deny(warnings)]
use num_rational::Rational64 as Q;
use serde_json::{json, Value};
use std::collections::{HashMap, HashSet};
use yantra_2d::{Point, YantraGraph};

fn q(n: i64) -> Q {
    Q::from_integer(n)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
struct Line {
    a: Q,
    b: Q,
    c: Q,
}

fn line_through(p: &Point, q: &Point) -> Line {
    let a = q.y - p.y;
    let b = p.x - q.x;
    let c = -(a * p.x + b * p.y);
    Line { a, b, c }
}

fn eval(line: &Line, point: &Point) -> Q {
    line.a * point.x + line.b * point.y + line.c
}

fn intersect(l1: &Line, l2: &Line) -> Option<Point> {
    let det = l1.a * l2.b - l2.a * l1.b;
    if det == Q::from_integer(0) {
        return None;
    }
    let x = (l2.c * l1.b - l1.c * l2.b) / det;
    let y = (l1.c * l2.a - l2.c * l1.a) / det;
    Some(Point { x, y })
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

fn canonical_signature(line: &Line) -> (i128, i128, i128) {
    let den_a = *line.a.denom();
    let den_b = *line.b.denom();
    let den_c = *line.c.denom();

    let mut lcm = lcm_i64(den_a, den_b);
    lcm = lcm_i64(lcm, den_c);
    if lcm == 0 {
        lcm = 1;
    }

    let a_scaled = (*line.a.numer() as i128) * (lcm as i128 / den_a as i128);
    let b_scaled = (*line.b.numer() as i128) * (lcm as i128 / den_b as i128);
    let c_scaled = (*line.c.numer() as i128) * (lcm as i128 / den_c as i128);

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

pub fn gc_invariants(g: &YantraGraph) -> Value {
    let mut lines: Vec<Line> = Vec::new();
    let mut seen: HashSet<(i128, i128, i128)> = HashSet::new();

    let n = g.vertices.len();
    for i in 0..n {
        for j in (i + 1)..n {
            let raw = line_through(&g.vertices[i].1, &g.vertices[j].1);
            let sig = canonical_signature(&raw);
            if seen.insert(sig) {
                lines.push(raw);
            }
        }
    }

    fn c3(m: i64) -> i64 {
        if m < 3 {
            0
        } else {
            m * (m - 1) * (m - 2) / 6
        }
    }

    let mut col_tri: i64 = 0;
    let mut line_counts: Vec<i64> = Vec::new();
    for line in &lines {
        let mut count = 0i64;
        for (_, point) in g.vertices.iter() {
            if eval(line, point) == q(0) {
                count += 1;
            }
        }
        col_tri += c3(count);
        line_counts.push(count);
    }

    #[derive(Hash, Eq, PartialEq, Clone, Debug)]
    struct P {
        x: Q,
        y: Q,
    }

    let mut point2lines: HashMap<P, HashSet<usize>> = HashMap::new();
    for i in 0..lines.len() {
        if line_counts[i] < 3 {
            continue;
        }
        for j in (i + 1)..lines.len() {
            if line_counts[j] < 3 {
                continue;
            }
            if let Some(pt) = intersect(&lines[i], &lines[j]) {
                let key = P { x: pt.x, y: pt.y };
                let entry = point2lines.entry(key).or_insert_with(HashSet::new);
                entry.insert(i);
                entry.insert(j);
            }
        }
    }

    let mut max_concurrency = 0i64;
    let mut concurrency_points = Vec::new();
    for (pt, set) in point2lines.iter() {
        let ok = set
            .iter()
            .all(|&idx| eval(&lines[idx], &Point { x: pt.x, y: pt.y }) == q(0));
        if ok {
            let deg = set.len() as i64;
            if deg >= 3 {
                concurrency_points.push(json!({
                    "x": format!("{}", pt.x),
                    "y": format!("{}", pt.y),
                    "degree": deg
                }));
            }
            if deg > max_concurrency {
                max_concurrency = deg;
            }
        }
    }

    let lines_ge3 = line_counts.iter().filter(|&&c| c >= 3).count() as i64;
    let pass = (g.vertices.len() >= 18) && (col_tri >= 3) && (max_concurrency >= 3);

    json!({
        "n_vertices": g.vertices.len(),
        "n_lines_unique": lines.len(),
        "lines_with_ge3_points": lines_ge3,
        "collinear_triplets": col_tri,
        "max_concurrency_degree": max_concurrency,
        "concurrency_points_ge3": concurrency_points,
        "pass": pass
    })
}

pub fn spectral_fingerprint(_g: &YantraGraph) -> Value {
    json!({"mod_24":"PENDING","walsh_sparsity":"PENDING"})
}

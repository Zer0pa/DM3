#![deny(warnings)]
use num_rational::Rational64 as Q;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Point {
    pub x: Q,
    pub y: Q,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct YantraGraph {
    pub vertices: Vec<(String, Point)>,
    pub edges: Vec<(usize, usize)>,
    pub constraints: serde_json::Value,
}

fn q(n: i64) -> Q {
    Q::from_integer(n)
}

pub fn build_base_graph_from_cfg(cfg: &serde_json::Value) -> YantraGraph {
    let layout = cfg
        .get("yantra")
        .and_then(|y| y.get("layout"))
        .and_then(|v| v.as_str())
        .unwrap_or("BOOTSTRAP");

    match layout {
        "TEST_TRIADS" => {
            let mut vertices: Vec<(String, Point)> = Vec::new();

            let line0: [i64; 6] = [-15, -9, -4, 2, 11, 25];
            let line1: [i64; 6] = [-16, -5, -1, 5, 12, 20];
            let line2: [i64; 6] = [-14, -7, -2, 4, 13, 21];

            for &x in &line0 {
                vertices.push((format!("L0_{x}"), Point { x: q(x), y: q(0) }));
            }
            for &x in &line1 {
                vertices.push((format!("L1_{x}"), Point { x: q(x), y: q(x) }));
            }
            for &x in &line2 {
                vertices.push((format!("L2_{x}"), Point { x: q(x), y: q(-x) }));
            }

            let mut edges: Vec<(usize, usize)> = Vec::new();
            for base in [0usize, 6, 12] {
                for k in 0..5 {
                    edges.push((base + k, base + k + 1));
                }
            }

            let constraints = serde_json::json!({
                "layout":"TEST_TRIADS",
                "lines":["y=0","y=x","y=-x"],
                "concurrency_point":{"x":"0","y":"0"}
            });
            YantraGraph {
                vertices,
                edges,
                constraints,
            }
        }
        _ => {
            let ring = (0..18)
                .map(|i| {
                    let x = q(i as i64 - 9);
                    let y = q(((i * i + 3 * i) % 7) as i64 - 3);
                    (format!("V{}", i + 1), Point { x, y })
                })
                .collect::<Vec<_>>();
            let mut edges = Vec::new();
            for i in 0..18 {
                edges.push((i, (i + 1) % 18));
            }
            let constraints = serde_json::json!({"status":"BOOTSTRAP"});
            YantraGraph {
                vertices: ring,
                edges,
                constraints,
            }
        }
    }
}

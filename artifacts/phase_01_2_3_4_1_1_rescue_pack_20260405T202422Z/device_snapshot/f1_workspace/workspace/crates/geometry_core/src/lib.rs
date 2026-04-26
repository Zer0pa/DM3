#![deny(warnings)]
pub mod exact {
    use num_rational::Rational64 as Q;
    use serde::{Deserialize, Serialize};
    use std::ops::{Add, Mul, Sub};

    #[derive(Clone, Copy, Debug, Serialize, Deserialize, PartialEq, Eq)]
    pub struct QsqrtD {
        pub a: Q,
        pub b: Q,
        pub d: i64,
    }
    impl QsqrtD {
        pub fn rational(a: Q) -> Self {
            Self {
                a,
                b: Q::from_integer(0),
                d: 0,
            }
        }
        fn is_rational(&self) -> bool {
            self.b == Q::from_integer(0)
        }
    }
    impl Add for QsqrtD {
        type Output = Self;
        fn add(self, rhs: Self) -> Self {
            assert!(
                self.d == rhs.d || self.is_rational() || rhs.is_rational(),
                "mismatched d"
            );
            let d = if self.d != 0 { self.d } else { rhs.d };
            Self {
                a: self.a + rhs.a,
                b: self.b + rhs.b,
                d,
            }
        }
    }
    impl Sub for QsqrtD {
        type Output = Self;
        fn sub(self, rhs: Self) -> Self {
            assert!(
                self.d == rhs.d || self.is_rational() || rhs.is_rational(),
                "mismatched d"
            );
            let d = if self.d != 0 { self.d } else { rhs.d };
            Self {
                a: self.a - rhs.a,
                b: self.b - rhs.b,
                d,
            }
        }
    }
    impl Mul for QsqrtD {
        type Output = Self;
        fn mul(self, rhs: Self) -> Self {
            let d = if self.d != 0 { self.d } else { rhs.d };
            let a = self.a * rhs.a + self.b * rhs.b * Q::from_integer(d);
            let b = self.a * rhs.b + self.b * rhs.a;
            Self { a, b, d }
        }
    }
    pub type QQ = Q; // shorthand
}

pub mod geom2d {
    use super::exact::QQ as Q;
    use serde::{Deserialize, Serialize};

    #[derive(Clone, Debug, Serialize, Deserialize)]
    pub struct Point {
        pub x: Q,
        pub y: Q,
    }
    #[derive(Clone, Debug, Serialize, Deserialize)]
    pub struct Line {
        pub a: Q,
        pub b: Q,
        pub c: Q,
    } // ax + by + c = 0

    pub fn line_through(p: &Point, q: &Point) -> Line {
        let a = q.y - p.y;
        let b = p.x - q.x;
        let c = -(a * p.x + b * p.y);
        Line { a, b, c }
    }
    pub fn intersect(l1: &Line, l2: &Line) -> Option<Point> {
        let det = l1.a * l2.b - l2.a * l1.b;
        if det == Q::from_integer(0) {
            return None;
        }
        let x = (l2.c * l1.b - l1.c * l2.b) / det;
        let y = (l1.c * l2.a - l2.c * l1.a) / det;
        Some(Point { x, y })
    }
}

pub mod errors {
    use thiserror::Error;
    #[derive(Error, Debug)]
    pub enum SnicError {
        #[error("Guardrail violated: {0}")]
        Guardrail(&'static str),
        #[error("Not implemented: {0}")]
        NotImplemented(&'static str),
        #[error("Invalid input: {0}")]
        Invalid(&'static str),
    }
}

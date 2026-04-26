use anyhow::Result;
use sha2::{Digest, Sha256};
use std::fs::File;
use std::io::{Read, Write};
use std::path::{Path, PathBuf};
use walkdir::WalkDir;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct HashEntry {
    pub path: String,
    pub hash_hex: String,
}

fn sha256_hex_for_bytes(bytes: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(bytes);
    format!("{:x}", hasher.finalize())
}

pub fn sha256_hex_for_file(path: &Path) -> Result<String> {
    let mut file = File::open(path)?;
    let mut hasher = Sha256::new();
    let mut buffer = [0u8; 8192];
    loop {
        let read = file.read(&mut buffer)?;
        if read == 0 {
            break;
        }
        hasher.update(&buffer[..read]);
    }
    Ok(format!("{:x}", hasher.finalize()))
}

pub fn sha256_hex_for_value<T: serde::Serialize>(value: &T) -> Result<String> {
    let bytes = serde_json::to_vec(value)?;
    Ok(sha256_hex_for_bytes(&bytes))
}

pub fn compute_artifact_hashes(root: &str) -> Result<Vec<HashEntry>> {
    let mut entries: Vec<HashEntry> = Vec::new();
    for entry in WalkDir::new(root).into_iter().filter_map(|e| e.ok()) {
        if entry.file_type().is_file() {
            let rel = entry
                .path()
                .strip_prefix(root)
                .unwrap_or(entry.path())
                .to_owned();
            let mut rel_path = PathBuf::from(root);
            rel_path.push(&rel);
            let rel_str = rel_path.to_string_lossy().replace("\\", "/");
            if rel_str.ends_with("run_hashes_1.sha256")
                || rel_str.ends_with("run_hashes_2.sha256")
                || rel_str.ends_with("repro_diff.txt")
            {
                continue;
            }
            let hash = sha256_hex_for_file(entry.path())?;
            entries.push(HashEntry {
                path: rel_str,
                hash_hex: hash,
            });
        }
    }
    entries.sort_by(|a, b| a.path.cmp(&b.path));
    Ok(entries)
}

pub fn write_hash_file(path: &str, entries: &[HashEntry]) -> Result<()> {
    let mut file = File::create(path)?;
    for entry in entries {
        writeln!(file, "{}  {}", entry.hash_hex, entry.path)?;
    }
    Ok(())
}

pub fn write_hash_diff(path: &str, a: &[HashEntry], b: &[HashEntry]) -> Result<bool> {
    if a == b {
        File::create(path)?; // create zero-byte file
        return Ok(true);
    }
    let mut file = File::create(path)?;
    use std::collections::{BTreeMap, BTreeSet};
    let map_a: BTreeMap<_, _> = a.iter().map(|e| (&e.path, &e.hash_hex)).collect();
    let map_b: BTreeMap<_, _> = b.iter().map(|e| (&e.path, &e.hash_hex)).collect();
    let mut keys: BTreeSet<&String> = BTreeSet::new();
    for key in map_a.keys() {
        keys.insert(key);
    }
    for key in map_b.keys() {
        keys.insert(key);
    }
    for key in keys {
        let left = map_a.get(key).copied();
        let right = map_b.get(key).copied();
        if left != right {
            let left_str = left.map(|s| s.as_str()).unwrap_or("(missing)");
            let right_str = right.map(|s| s.as_str()).unwrap_or("(missing)");
            writeln!(file, "{} :: {} -> {}", key, left_str, right_str)?;
        }
    }
    Ok(false)
}

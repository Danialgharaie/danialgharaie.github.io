---
layout: page
title: structscope
description: Rust-native structural bioinformatics toolkit for parsing protein structures, graph-native representations, feature extraction, and analytical outputs.
importance: 1
category: Tools
github: https://github.com/Danialgharaie/structscope
---

`structscope` is a Rust-native structural bioinformatics toolkit for canonical protein structure parsing, graph-native representations, reproducible feature extraction, and analytical outputs. It is built as a multi-crate Rust workspace with separate crates for core parsers and models, graph construction, scientific features, persisted outputs, structured events, provenance, and the CLI.

The toolkit currently parses PDB, mmCIF, and BinaryCIF inputs, including gzip-compressed files. It normalizes structures into a canonical model, builds residue, atom, and interface graphs, and computes low-level structural quantities such as solvent accessible surface area, DSSP-style secondary structure, backbone dihedrals, RMSD/superposition, typed interactions, ligand features, protein-protein interface metrics, and structure quality checks.

The CLI includes entrypoints for parsing, batch featurization, graph export, RMSD, residue-level features, ligand analysis, interface analysis, quality reports, multi-structure comparison, provenance, and optional DuckDB-backed SQL queries over Parquet feature output.

`structscope` is under active development. The public repository is currently at version `0.4.1`; install from crates.io with:

```bash
cargo install structscope-cli
```

Prebuilt Linux x86_64 release binaries are also attached to the project's GitHub releases.

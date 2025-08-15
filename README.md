# Crayfish eDNA Bioinformatics Pipeline

This repository contains bioinformatics scripts, relavant data, and the custom reference databases used for my MSc thesis:

**Title:** eDNA Metabarcoding Reveals Invasive Crayfish and Associated Pathogen in Hampstead Heath Urban Ponds, London.
**Author:** Boualaphan Phonesavanh  
**Date:** 2025  

### Input Data
- Base-called **FASTQ** reads from Oxford Nanopore sequencing.

### Quality Control
- **NanoPlot v1.44.1** — read length and quality visualisation (De Coster & Rademakers 2023).  
- **NanoFilt v2.8.0** — quality filtering:
  - Q score ≥ 12
  - Length: 600–900 bp (COI) and 300–600 bp (18S)

### Adapter & Primer Removal
- **Porechop v0.2.4** — adapter trimming (Wick 2018).  
- **Cutadapt v3.5** — primer sequence trimming (Martin 2011).

### OTU Clustering
- **VSEARCH v1.3.1** — dereplication and clustering at 97% similarity (Rognes et al. 2016).  
- OTUs used instead of ASVs, as Nanopore-specific ASV pipelines are still experimental (Santos et al. 2020; Chang et al. 2024; Stoeck et al. 2024).

### Taxonomic Assignment
- BLAST in VSEARCH v1.3.1 against:
  1. **MIDORI2** database for COI (Machida et al. 2017)
  2. **PR2** database for 18S (Guillou et al. 2012)
  3. **Custom crayfish databases** (COI & 18S) — curated from NCBI for 16 European crayfish species (Kouba et al. 2014).
- Similarity threshold: ≥ 90%.

### Post-processing
- BLAST outputs parsed in **R v4.3.2** to compile tables of detected taxa:
  - Read counts per pond
  - Relative abundances
  - Marker-specific detection (COI vs 18S)

### References
Chang et al. 2024.
De Coster & Rademakers 2023.
De Coster et al. 2018.
Guillou et al. 2012.
Kouba, Petrusek & Kozák 2014.
Machida et al. 2017.
Martin 2011.
Rognes et al. 2016.
Santos et al. 2020.
Stoeck et al. 2024.
Wick 2018.


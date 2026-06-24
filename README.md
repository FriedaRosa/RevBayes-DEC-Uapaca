# Project README
Friederike Wölke
2026-06-20

- [RevBayes-Uapaca Models](#revbayes-uapaca-models)
- [Analyses in this repository:](#analyses-in-this-repository)
  - [A. DEC vs. DEC+J+F analysis](#a-dec-vs-decjf-analysis)
    - [The resulting ancestral range reconstruction on the nuclear tree
      (DEC):](#the-resulting-ancestral-range-reconstruction-on-the-nuclear-tree-dec)
    - [The resulting ancestral range reconstruction on the nuclear tree
      (DEC+J+F):](#the-resulting-ancestral-range-reconstruction-on-the-nuclear-tree-decjf)
    - [The resulting ancestral range reconstruction on the plastome tree
      (DEC):](#the-resulting-ancestral-range-reconstruction-on-the-plastome-tree-dec)
    - [The resulting ancestral range reconstruction on the plastome tree
      (DEC+J+F):](#the-resulting-ancestral-range-reconstruction-on-the-plastome-tree-decjf)
  - [B. Molecular clock model
    selection](#b-molecular-clock-model-selection)

# RevBayes-Uapaca Models

This repository contains the *RevBayes* models used to analyze selected
genes from my *Uapaca* angiosperm353 and plastome datasets.

To set up RevBayes see
[00_Configure_Project_and_RevBayes.html](https://rawcdn.githack.com/FriedaRosa/RevBayes-DEC-Uapaca/aa4309eb62f3c4882015774bb879518bd8b45e1a/00_Configure_Project_and_RevBayes.html).

The folder is organized into the following subfolders: `data` and
`scripts`. `content` holds the RevBayes executable (as downloaded via
the 00_Configure_Project_and_RevBayes.qmd).

    .
    ├── 00_Configure_Project_and_RevBayes.html
    ├── 00_Configure_Project_and_RevBayes.qmd
    ├── content
    ├── data
    ├── figures
    ├── history.txt
    ├── README.md
    ├── README.qmd
    ├── README.rmarkdown
    ├── renv
    ├── renv.lock
    ├── RevBayes-DEC-Uapaca.Rproj
    └── scripts

Where `data` contains the data (input/output) for the RevBayes analyses,
including the nuclear tree, plastome tree which were inferred in the
phylogenomics pipelines:

1)  **Nuclear**: <https://github.com/FriedaRosa/HybSuite_pipeline_2026>

<img src="figures/nuclear_tree.png" width="681" />

2)  **Plastome**:
    <https://github.com/FriedaRosa/Plastome_Phylogenomisc_2026>

    ![](figures/plastome.png)

<!-- -->

3)  it also includes the **Distribution** **Ranges**: `Uapaca_range.nex`
    which was written by hand with the following format:

<!-- -->

    #NEXUS
    [A = Africa, B = Madagascar]
    Begin data;
    Dimensions ntax=21 nchar=2;
    Format datatype=Standard missing=? gap=- labels="01";
    Matrix
                                                        [AB]
            U_bojeri_1                                  01
            Spondianthus_preussii                       10
            U_amplifolia                                01
            U_nitida                                    10
            U_heudelotii                                10
            U_acuminata                                 10
            U_togoensis                                 10
            U_mole                                      10
            U_lissopyrena                               10
            U_guineensis                                10
            U_pilosa                                    10
            U_kirkiana                                  10
            U_robynsii                                  10
            U_sansibarica                               10
            U_pilosa_var_petiolata                      10
            U_vanhouttei                                10
            U_littoralis                                01
            U_ferruginea                                01
            U_densifolia                                01
            U_thouarsii                                 01
            U_louvelii                                  01                    
        ;
    End;

4.  and some high-coverage **molecular sequence** data to estimate the
    rate of sequence evolution for molecular clock models

<!-- -->

    data/input/molecular_data/
    ├── plastome_concat.nex
    ├── uapaca_gene_1.nex
    ├── uapaca_gene_2.nex
    ├── uapaca_gene_3.nex
    ├── uapaca_gene_4.nex
    ├── uapaca_gene_5.nex
    ├── uapaca_gene_6.nex
    ├── uapaca_gene_7.nex
    ├── uapaca_gene_8.nex
    └── uapaca_gene_9.nex

# Analyses in this repository:

## A. DEC vs. DEC+J+F analysis

This repository contains the *RevBayes* scripts used to perform the
Dispersal-Extinction-Cladogenesis (DEC) analyses (and in addition one
that includes jump dispersal and full sympatry)

### The resulting ancestral range reconstruction on the nuclear tree (DEC):

![Nuclear tree](figures/simple_dec_acr.png)

### The resulting ancestral range reconstruction on the nuclear tree (DEC+J+F):

![Nuclear tree](figures/DECJ_nuclear_asr.png)

### The resulting ancestral range reconstruction on the plastome tree (DEC):

![Plastome tree](figures/plastome_simple_acr.png)

### The resulting ancestral range reconstruction on the plastome tree (DEC+J+F):

![Plastome tree](figures/DECJ_plastome_asr.png)

## B. Molecular clock model selection

That part is based on the following tutorial:
https://revbayes.github.io/tutorials/clocks/

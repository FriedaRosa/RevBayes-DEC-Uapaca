---
title: "Project README"
author: Friederike Wölke
date: 2026-06-20
format: html
embed-resources: true
standalone: true
toc: true
---

# RevBayes-DEC-Uapaca

This repository contains the *RevBayes* scripts used to perform the Dispersal-Extinction-Cladogenesis (DEC) analyses on the *Uapaca* angiosperm3535-dataset.

The folder is organized into the following subfolders: `content` and `scripts`

```{r}
#| echo: false
suppressPackageStartupMessages(library(fs))
dir_tree(recurse = FALSE)
```

Where `content` contains the data (input/output) for the RevBayes analyses, including the nuclear tree, plastome tree which were inferred in the phylogenomics pipelines:

1)  **Nuclear**: <https://github.com/FriedaRosa/HybSuite_pipeline_2026>

    ```{r}
    #| echo: false
    suppressPackageStartupMessages(library(ape))
    suppressPackageStartupMessages(library(dplyr))

    read.tree("content/data/input/phylogenetic_tree/uapaca_start_ultrametric.tre") %>% ladderize() %>% 
    plot()
    ```

2)  **Plastome**: <https://github.com/FriedaRosa/Plastome_Phylogenomisc_2026>

    ```{r}
    #| echo: false
    library(ape)
    library(dplyr)
    read.tree("content/data/input/phylogenetic_tree/uapaca_start_ultrametric_plastome.tre") %>% ladderize() %>% 
    root(outgroup = "Spondianthus_preussii", resolve.root = TRUE) %>%
    plot()
    ```

3)  it also includes the **Distribution** **Ranges**: `Uapaca_range.nex` which was written by hand with the following format:

```{r}
#| echo: false

r <- readLines("./content/data/input/Uapaca_range.nex")
cat(paste(r, collapse = "\n"))
```

4.  and some high-coverage **molecular sequence** data to estimate the rate of sequence evolution for molecular clock models

    ```{r}
    #| echo: false
    fs::dir_tree("content/data/input/molecular_data/", regexp = "(?:uapaca|plastome).*\\.nex$")
    ```

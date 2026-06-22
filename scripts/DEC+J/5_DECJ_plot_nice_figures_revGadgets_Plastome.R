fp <- "./content/data/output/DECJ_plst/"


plot_fn <- paste(fp, "DECJ_.range.pdf", sep = "")
tree_fn <- paste(fp, "DECJ_.ase.tre", sep = "")
label_fn <- paste(fp, "DECJ_.state_labels.txt", sep = "")
color_fn <- paste(fp, "range_colors.n4.txt", sep = "")


# install.packages("RevGadgets")
# if (!require("BiocManager", quietly = TRUE)) {
#   install.packages("BiocManager")
# }
# BiocManager::install("ggtree")

library(RevGadgets)
library(magick)
library(ggtree)
library(ggplot2)

tree <- readTrees(paths = tree_fn)
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Spondianthus_preussii")
plotTree(tree_rooted)


labs <- c("1" = "Afr", "2" = "Mdg", "3" = "both", "0" = "none")

ancstates <- processAncStates(tree_fn, state_labels = labs)


pp <- plotAncStatesPie(
  t = ancstates,
  tip_labels_size = 5,

  # Include cladogenetic events

  cladogenetic = T,

  # adjust tip labels

  tip_labels_offset = 0.1
)

pp
ggsave(pp, filename = "figures/DECJ_plastome_asr.png")

fp <- "./content/data/output/simple_dec/"
#plot_fn <- paste(fp, "simple_dec.range.pdf", sep = "")
#tree_fn <- paste(fp, "simple_dec.ase.tre", sep = "")
#label_fn <- paste(fp, "simple_dec.state_labels.txt", sep = "")
#color_fn <- paste(fp, "range_colors.n4.txt", sep = "")

plot_fn <- paste(fp, "test_.range.pdf", sep = "")
tree_fn <- paste(fp, "test_.ase.tre", sep = "")
label_fn <- paste(fp, "test_.state_labels.txt", sep = "")
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

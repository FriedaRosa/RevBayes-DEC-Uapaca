library(ape)
library(dplyr)


tree_file <- "./content/data/output/DECJ_nuc/DECJ_.ase.tre"
tr <- read.nexus(tree_file)

txt <- paste(readLines(tree_file), collapse = " ")

ann <- regmatches(txt, gregexpr("\\[&index=[^\\]]+\\]", txt, perl = TRUE))[[1]]

get_field <- function(x, field) {
  m <- regexec(paste0(field, "=([^,\\]]+)"), x, perl = TRUE)
  r <- regmatches(x, m)
  sapply(r, function(z) if (length(z) >= 2) z[2] else NA_character_)
}

idx <- as.integer(get_field(ann, "index"))
end_state_1 <- get_field(ann, "end_state_1")
end_state_1_pp <- as.numeric(get_field(ann, "end_state_1_pp"))

n_tip <- length(tr$tip.label)
n_all <- n_tip + tr$Nnode

state_lab <- rep(NA_character_, n_all)
pp_lab <- rep(NA_real_, n_all)

state_lab[idx] <- end_state_1
pp_lab[idx] <- end_state_1_pp

state_lab_areas <- case_when(
  state_lab == "0" ~ "0",
  state_lab == "1" ~ "A",
  state_lab == "2" ~ "M",
  state_lab == "3" ~ "both",
  TRUE ~ NA_character_
)

outgroups <- c("Spondianthus_preussii")
desired_order <- c(setdiff(tr$tip.label, outgroups), outgroups)

tr <- rotateConstr(tr, desired_order)
tr <- ladderize(tr, right = FALSE)


if (is.null(tr$root.time)) {
  tr$root.time <- max(node.depth.edgelength(tr))
}

par(mar = c(5, 2, 2, 8), xpd = NA)

plot(
  tr,
  show.tip.label = TRUE,
  cex = 1.1,
  #label.offset = 0.8,
  no.margin = FALSE,
  x.lim = c(0, max(node.depth.edgelength(tr)) * 1.15)
)

internal_nodes <- (n_tip + 1):(n_tip + tr$Nnode)

nodelabels(
  text = state_lab_areas[internal_nodes],
  node = internal_nodes,
  frame = "none",
  cex = 1.0,
  adj = c(-0.15, -0.2)
)

edge_desc <- tr$edge[, 2]
internal_edge <- edge_desc > n_tip
edge_pp <- sprintf("%.2f", pp_lab[edge_desc[internal_edge]])

edgelabels(
  text = edge_pp,
  edge = which(internal_edge),
  frame = "none",
  cex = 0.9,
  adj = c(0.8, -0.)
)

axisPhylo()
mtext("Time (relative)", side = 1, line = 3)

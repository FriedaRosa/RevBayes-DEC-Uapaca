### PART 1: EVALUATE MCMC

library(coda)


trace <- read.table(
  "data/output/ancestral-areas-DEC/MCMC_DEC_nuc.model.log",
  header = TRUE
)


m <- mcmc(trace)


burnin_fraction <- 0.25
start_iter <- floor(burnin_fraction * nrow(trace))
m_postburn <- window(m, start = start_iter)


plot(m_postburn)


mean_range_bg <- mean(m_postburn[, "rate_bg"])
ci_range_bg <- quantile(m_postburn[, "rate_bg"], probs = c(0.025, 0.975))

mean_extirpation_rate <- mean(m_postburn[, "extirpation_rate"])
ci_extirpation_rate <- quantile(
  m_postburn[, "extirpation_rate"],
  probs = c(0.025, 0.975)
)


postburn <- as.data.frame(m_postburn)
plot(density(postburn$rate_bg), main = "rate_bg")
plot(density(postburn$extirpation_rate), main = "extirpation_rate")


plot(
  density(postburn$extirpation),
  col = "red",
  lwd = 2,
  main = "extirpation_rate vs rate_bg",
  xlab = "Value"
)

lines(density(postburn$rate_bg), col = "green", lwd = 2)

legend(
  "topright",
  legend = c("extirpation_rate", "rate_bg"),
  col = c("red", "green"),
  lwd = 2
)


##### PART 2: PLOT ANCESTRAL STATES ON TREE
library(ape)
library(dplyr)


tree_file <- "./data/output/ancestral-areas-DEC/MCMC_DEC_nuc.ase.tre"
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


##### PART 3: NICE PLOTS
library(RevGadgets)
library(magick)
library(ggtree)
library(ggplot2)


fp <- "data/output/ancestral-areas-DEC/MCMC_DEC_nuc"
plot_fn <- paste(fp, ".range.pdf", sep = "")
tree_fn <- paste(fp, ".ase.tre", sep = "")
label_fn <- paste(fp, ".state_labels.txt", sep = "")
color_fn <- paste(fp, "range_colors.n4.txt", sep = "")


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
ggsave(pp, filename = "figures/final_DEC_ACR.png")


##### PART 4: STOCHASTIC CHARACTER MAP
library(ggplot2)
library(ggtree)
library(RevGadgets)
library(ape)
library(phytools)


character_file = paste0(fp, "simple_marginal_character.tree")
sim = read.simmap(file = character_file, format = "phylip")


# Define colors
colors = vector()
for (i in 1:length(sim$maps)) {
  colors = c(colors, names(sim$maps[[i]]))
}

colors = sort(as.numeric(unique(colors)))
colors
cols = setNames(c("gold", "blue", "grey"), colors)


plot_stochastic_map <- function() {
  par(mar = c(5, 4, 4, 16), xpd = TRUE)

  plotSimmap(
    sim,
    cols,
    fsize = 1.0,
    lwd = 2.0,
    split.vertical = TRUE,
    ftype = "bi",
    xlim = c(0, max(nodeHeights(sim)) * 1.45)
  )

  leg <- names(cols)

  add.simmap.legend(
    leg,
    colors = cols,
    prompt = FALSE,
    x = max(nodeHeights(sim)) * 1.20,
    y = Ntip(sim) * 0.75,
    fsize = 0.9
  )
}

# Show on screen
plot_stochastic_map()

# Save to PDF
pdf("figures/DEC_FINAL_stochastic_map.pdf", width = 8, height = 10)
plot_stochastic_map()
dev.off()


#### PART 5: Plotting posterior probabilities to stochastic map
posterior_file = paste0(fp, "simple_marginal_posterior.tree")
sim_p = read.simmap(file = posterior_file, format = "phylip")


colors = vector()
for (i in 1:length(sim_p$maps)) {
  colors = c(colors, names(sim_p$maps[[i]]))
}
colors = sort(as.numeric(unique(colors)))
cols = setNames(heat.colors(length(colors), rev = TRUE), colors)


plot_stochastic_posterior <- function() {
  par(mar = c(5, 4, 4, 26), xpd = TRUE)

  tree_depth <- max(nodeHeights(sim_p))

  plotSimmap(
    sim_p,
    cols,
    fsize = 1.25,
    lwd = 2.5,
    split.vertical = TRUE,
    ftype = "bi",
    pts = FALSE,
    xlim = c(0, tree_depth * 1.90)
  )

  leg <- names(cols)

  add.simmap.legend(
    leg,
    colors = cols,
    prompt = FALSE,
    x = tree_depth * 1.42,
    y = Ntip(sim_p) * 1.02,
    fsize = 0.65
  )
}

# Show on screen
plot_stochastic_posterior()

# Save to PDF
pdf(
  "figures/DEC_FINAL_stochastic_posterior.pdf",
  width = 14,
  height = 20
)
plot_stochastic_posterior()
dev.off()

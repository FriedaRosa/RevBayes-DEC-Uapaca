#install.packages("coda")
library(coda)
trace <- read.table(
  "content/data/output/DECJ_plst/DECJ_.model.log",
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

## For Part 1

eno <- read.csv("orig_data/eno.csv")
skin <- read.csv("orig_data/skin.csv")
env <- read.csv("orig_data/environmental.csv")
m <- merge(eno, env, by = "id")
maacs <- merge(m, skin, by = "id")

eno.model <- lm(log(eno) ~ mopos * log(pm25), data = maacs)
pm.model <- lm(log(pm25) ~ mopos, data = maacs)
mopos.p <- mean(maacs$mopos == "yes")

set.seed(234234)
n <- nrow(maacs)
mopos <- rbinom(n, 1, mopos.p)
d1 <- data.frame(id = 1:n, mopos = factor(mopos, labels = c("no", "yes")))
d1$pm25 <- exp(rnorm(n, predict(pm.model, d1), summary(pm.model)$sigma))
d1$eno <- exp(rnorm(n, predict(eno.model, d1), summary(eno.model)$sigma))

write.csv(d1, "data/maacs_sim.csv", row.names = FALSE)


## For Part 2
d0 <- read.csv("data/bmi_pm25_no2.csv")
u <- complete.cases(d0)
d <- d0[u, ]

bmi.model <- glm(bmicat ~ logpm25 + logno2_new, data = d, family = binomial)
mu.poll <- with(d, colMeans(cbind(logpm25, logno2_new)))
S.poll <- with(d, cov(cbind(logpm25, logno2_new)))

library(MASS)

sxs.model <- glm(cbind(NocturnalSympt, 14 - NocturnalSympt) ~ bmicat * logpm25 + logno2_new, data = d, family = binomial)

set.seed(32342141)

n <- nrow(d)
x <- mvrnorm(n, mu.poll, S.poll)
d1 <- data.frame(logpm25 = x[, 1], logno2_new = x[, 2])
bmi <- rbinom(n, 1, predict(bmi.model, d1, type = "response"))
d1$bmicat <- factor(bmi, labels = c("normal weight", "overweight"))
sxs <- rbinom(n, 14, predict(sxs.model, d1, type = "response"))
d1$NocturnalSympt <- sxs

write.csv(d1, "data/bmi_pm25_no2_sim.csv", row.names = FALSE)

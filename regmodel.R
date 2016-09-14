## Principal stratification model with regression model for predicting
## principal stratum membership. Monotonicity; exclude always-takers.

## Baseline covariates
## grep("_f$|^diff", sort(names(d)), perl = TRUE, invert=T, value=T)


## Setup the data
cutoff <- -20
## cutoff <- -10
pred <- c("pm25_0", "age", "no2_0", "severity2")

d <- read.csv("Preach_082212.csv")
d$severity2 <- ifelse(d$severity > 1, 1, 0)
d$symfree1 <- with(d, 14 - sym_f)
d$diffsymfree <- with(d, symfree1 - symfree0)
d$ldiffpm25 <- with(d, log2(pm25_1) - log2(pm25_0))
d$ldiffpm10 <- with(d, log2(pm10_1) - log2(pm10_0))
d$ldiffno2 <- with(d, log2(no2_1) - log2(no2_0))
d$marital2 <- ifelse(d$marital < 5, 0, 1)
ds <- d[, c("p_id", "diffpm25", "ldiffpm25", "rand_group2", "diffsymfree",
            pred)]
if("no2_0" %in% pred) {
        ds[, "no2_0"] <- log2(ds[, "no2_0"])
}
ds$pm25s <- with(ds, ifelse(diffpm25 < cutoff, 1, 0))  ## Mediator
ds$group <- unclass(ds$rand_group2) - 1
ds$sgroup <- with(ds, mapply(function(g, s) {
        if(is.na(g) || is.na(s))
                return(NA_character_)
        if(g == 0 && s == 0)
                "d"
        else if(g == 0 && s == 1)
                "c"
        else if(g == 1 && s == 0)
                "b"
        else
                "a"
}, group, pm25s))
ds$rand_group2 <- NULL

## Exclude outliers (sensitivity analysis)
## ds <- subset(ds, abs(diffsymfree) < 14)

## Make final data frame w/o missing data
dd <- ds[, c("diffsymfree", "pm25s", "group", "sgroup", pred, "p_id")]
use <- complete.cases(dd)
dd <- dd[use, ]
dd <- dd[order(dd$sgroup), ]
wh <- rep(1, nrow(dd))
nn <- table(dd$sgroup)
y <- dd$diffsymfree
sg <- dd$sgroup

ddm <- merge(dd, d[, c("p_id", setdiff(names(d), names(dd)))], by = "p_id")


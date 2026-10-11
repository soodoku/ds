close <- function(x, y, tolerance = 1e-8) {
  stopifnot(isTRUE(all.equal(as.numeric(x), as.numeric(y), tolerance = tolerance)))
}

# OLS coefficients, gradients, and orthogonal sums of squares.
x <- c(-3, -1, 0, 2, 5, 8)
y <- c(-4, 1, 0, 5, 8, 17)
fit <- lm(y ~ x)
beta <- sum((x - mean(x)) * (y - mean(y))) / sum((x - mean(x))^2)
alpha <- mean(y) - beta * mean(x)
close(c(alpha, beta), coef(fit))
X <- cbind(1, x)
close(solve(crossprod(X), crossprod(X, y)), coef(fit))
loss <- function(w) mean((y - w[1] - w[2] * x)^2)
w <- c(.7, 1.2)
h <- 1e-5
grad <- c(-2 * mean(y - w[1] - w[2] * x),
          -2 * mean(x * (y - w[1] - w[2] * x)))
numgrad <- sapply(seq_along(w), function(j) {
  step <- rep(0, length(w)); step[j] <- h
  (loss(w + step) - loss(w - step)) / (2 * h)
})
close(grad, numgrad)
r2 <- 1 - sum(resid(fit)^2) / sum((y - mean(y))^2)
close(r2, summary(fit)$r.squared)
close(r2, cor(y, fitted(fit))^2)
close(r2, sum((fitted(fit) - mean(y))^2) / sum((y - mean(y))^2))
close(1 - (1 - r2) * (length(y) - 1) / (length(y) - 2),
      summary(fit)$adj.r.squared)
fit0 <- lm(y ~ 1)
f <- ((deviance(fit0) - deviance(fit)) / 1) / (deviance(fit) / (length(y) - 2))
close(f, anova(fit0, fit)$F[2])
k <- attr(logLik(fit), "df")
close(-2 * logLik(fit) + 2 * k, AIC(fit))
close(-2 * logLik(fit) + k * log(length(y)), BIC(fit))

# Logistic loss derivatives, for both labels and several logits.
for (label in 0:1) for (z in c(-4, -.2, 0, 2, 5)) {
  a <- plogis(z)
  ell <- function(z) -label * log(plogis(z)) - (1 - label) * log1p(-plogis(z))
  close((ell(z + h) - ell(z - h)) / (2 * h), a - label)
  close((-label / a + (1 - label) / (1 - a)) * a * (1 - a), a - label)
  close((plogis(z + h) - plogis(z - h)) / (2 * h), a * (1 - a))
}

# Exact finite-distribution bias-variance decomposition, including independent noise.
ftrue <- 3
predictions <- c(1, 2, 4, 5)
noise <- c(-2, 2)
errors <- outer(predictions, noise, function(pred, err) (ftrue + err - pred)^2)
close(mean(errors), (mean(predictions) - ftrue)^2 +
        mean((predictions - mean(predictions))^2) + mean(noise^2))
close(mean(x - mean(x)), 0)
close(cor(c(10, 9, 8, 7, 6), c(500, 500, 500, 250, 200), method = "spearman"),
      cor(1:5, c(2, 2, 2, 4, 5)))

# Every randomized allocation of three out of six units: the ATE is recovered on average.
y0 <- c(0, 1, 2, 4, 5, 8)
y1 <- y0 + c(-1, 2, 1, 3, 0, 4)
assignments <- combn(6, 3)
contrasts <- apply(assignments, 2, function(treated) mean(y1[treated]) - mean(y0[-treated]))
close(mean(contrasts), mean(y1 - y0))

# Confusion matrix quiz and denominators.
tn <- 78; fp <- 10; fn <- 7; tp <- 5
precision <- tp / (tp + fp); recall <- tp / (tp + fn)
close((tp + tn) / (tp + tn + fp + fn), .83)
close(precision, 1 / 3)
close(recall, 5 / 12)
close(2 * precision * recall / (precision + recall), 10 / 27)
close(tn / (tn + fp) + fp / (tn + fp), 1)

# Power: independent normal-approximation calculation against R's implementation.
p1 <- .05; p2 <- .055; n <- 32000; pbar <- (p1 + p2) / 2
critical <- qnorm(.975) * sqrt(2 * pbar * (1 - pbar) / n)
se_alt <- sqrt((p1 * (1 - p1) + p2 * (1 - p2)) / n)
power <- pnorm((-critical - (p2 - p1)) / se_alt) +
  pnorm((critical - (p2 - p1)) / se_alt, lower.tail = FALSE)
close(power, power.prop.test(n = n, p1 = p1, p2 = p2, strict = TRUE)$power)
close(.99 * .05 * .70 * .10, .003465)
q <- qbinom(.05, 100, .3)
stopifnot(pbinom(q, 100, .3) > .05, pbinom(q - 1, 100, .3) <= .05)
pvalues <- c(.001, .02, .04, .6)
close(pmin(1, length(pvalues) * pvalues), p.adjust(pvalues, "bonferroni"))

# Bilinear interpolation reproduces any bilinear surface inside its grid cell.
fxy <- function(x, y) 2 + 3*x - 4*y + 5*x*y
xx <- .4; yy <- .7
interpolated <- (1-xx)*(1-yy)*fxy(0,0) + xx*(1-yy)*fxy(1,0) +
  (1-xx)*yy*fxy(0,1) + xx*yy*fxy(1,1)
close(interpolated, fxy(xx, yy))

# A Pareto top-share relation requires a common Pareto exponent and finite mean.
alpha_pareto <- 1 / (1 - log(.8) / log(.2))
stopifnot(alpha_pareto > 1)
close(.04^((alpha_pareto - 1) / alpha_pareto), .64)

# Execute the actual R lesson chunks in separate environments.
lessons <- list.files(pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
for (lesson in lessons) {
  script <- tempfile(fileext = ".R")
  knitr::purl(lesson, output = script, quiet = TRUE, documentation = 0)
  lesson_env <- new.env(parent = globalenv())
  source(script, local = lesson_env)
  if (grepl("exp_power", lesson)) {
    stopifnot(lesson_env$n_per_group > 0)
    stopifnot(power.prop.test(n = lesson_env$n_per_group, p1=.05, p2=.055,
                             strict=TRUE)$power >= .8)
  }
  unlink(script)
}
cat("Mathematical checks and all R lesson chunks passed.\n")

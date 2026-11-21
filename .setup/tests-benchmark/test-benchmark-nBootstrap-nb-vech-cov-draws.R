## ---- test-benchmark-nBootstrap-nb-vech-cov-draws
# Run by hand: bench is not part of the unit tests.
stopifnot(requireNamespace(package = "bench", quietly = TRUE))
lapply(
  X = c(3, 10, 20),
  FUN = function(k) {
    x <- matrix(data = stats::rnorm(n = 100 * k), nrow = 100)
    print(
      x = bench::mark(
        nBootstrap:::.NBVechCovDraws(x = x, R = 200L),
        iterations = 5,
        check = FALSE
      )
    )
  }
)

## ---- test-nBootstrap-quantile-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "identical to stats::quantile(type = 7)"),
      code = {
        set.seed(seed = 42)
        probs <- c(0, 0.0005, 0.005, 0.025, 0.5, 0.975, 0.995, 0.9995, 1)
        for (n in c(1, 2, 3, 10, 999, 5000)) {
          x <- stats::rnorm(n = n)
          testthat::expect_identical(
            object = nBootstrap:::.Quantile(x = x, probs = probs),
            expected = stats::quantile(x = x, probs = probs, names = FALSE)
          )
        }
        x <- c(1, 1, 1, 2, 2, 3)
        testthat::expect_identical(
          object = nBootstrap:::.Quantile(x = x, probs = probs),
          expected = stats::quantile(x = x, probs = probs, names = FALSE)
        )
        p <- stats::pnorm(q = seq(from = -3, to = 3, by = 0.37))
        x <- stats::rexp(n = 1234)
        testthat::expect_identical(
          object = nBootstrap:::.Quantile(x = x, probs = p),
          expected = stats::quantile(x = x, probs = p, names = FALSE)
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "empty draws give NA; invalid probs stop"),
      code = {
        testthat::expect_identical(
          object = nBootstrap:::.Quantile(x = numeric(length = 0), probs = 0.5),
          expected = NA_real_
        )
        testthat::expect_error(
          object = nBootstrap:::.Quantile(x = 1:3, probs = NaN)
        )
      }
    )
  },
  text = "test-nBootstrap-quantile-dot"
)

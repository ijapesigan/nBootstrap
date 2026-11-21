## ---- test-nBootstrap-ci-format-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        draws <- c(1, 2, 3, 4)
        out <- nBootstrap:::.CIFormat(
          thetahatstar = draws,
          thetahat = 2.5,
          probs = c(0.025, 0.975),
          ci = c(1.1, 3.9)
        )
        testthat::expect_equal(
          object = names(x = out),
          expected = c("est", "se", "R", "2.5%", "97.5%")
        )
        testthat::expect_equal(
          object = unname(obj = out),
          expected = c(2.5, stats::sd(x = draws), 4, 1.1, 3.9)
        )
      }
    )
  },
  text = "test-nBootstrap-ci-format-dot"
)

## ---- test-nBootstrap-pc-ci-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        draws <- seq_len(length.out = 100)
        probs <- c(0.025, 0.975)
        out <- nBootstrap:::.PCCI(
          thetahatstar = draws,
          thetahat = 50.5,
          probs = probs
        )
        testthat::expect_equal(
          object = unname(obj = out[4:5]),
          expected = stats::quantile(x = draws, probs = probs, names = FALSE)
        )
        testthat::expect_equal(
          object = out[["R"]],
          expected = 100
        )
        testthat::expect_equal(
          object = names(x = out),
          expected = c("est", "se", "R", "2.5%", "97.5%")
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "drops missing draws"),
      code = {
        out <- nBootstrap:::.PCCI(
          thetahatstar = c(1:10, NA, NA),
          thetahat = 5.5,
          probs = c(0.025, 0.975)
        )
        testthat::expect_equal(
          object = out[["R"]],
          expected = 10
        )
      }
    )
  },
  text = "test-nBootstrap-pc-ci-dot"
)

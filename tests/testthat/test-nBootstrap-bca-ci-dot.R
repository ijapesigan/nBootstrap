## ---- test-nBootstrap-bca-ci-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "agrees with the bias-corrected interval when a is 0"),
      code = {
        draws <- seq_len(length.out = 99)
        probs <- c(0.025, 0.975)
        z1 <- nBootstrap:::.Z1(probs = probs)
        bc <- nBootstrap:::.BCCI(
          thetahatstar = draws,
          thetahat = 40,
          probs = probs,
          z0 = 0.2,
          z1 = z1
        )
        bca <- nBootstrap:::.BCACI(
          thetahatstar = draws,
          thetahat = 40,
          probs = probs,
          z0 = 0.2,
          z1 = z1,
          acceleration = 0
        )
        testthat::expect_equal(object = bca, expected = bc)
      }
    )
  },
  text = "test-nBootstrap-bca-ci-dot"
)

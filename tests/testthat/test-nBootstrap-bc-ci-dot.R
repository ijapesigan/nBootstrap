## ---- test-nBootstrap-bc-ci-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "agrees with the percentile interval when z0 is 0"),
      code = {
        draws <- seq_len(length.out = 99)
        probs <- c(0.025, 0.975)
        bc <- nBootstrap:::.BCCI(
          thetahatstar = draws,
          thetahat = 50,
          probs = probs,
          z0 = 0,
          z1 = nBootstrap:::.Z1(probs = probs)
        )
        pc <- nBootstrap:::.PCCI(
          thetahatstar = draws,
          thetahat = 50,
          probs = probs
        )
        testthat::expect_equal(object = bc, expected = pc)
      }
    )
  },
  text = "test-nBootstrap-bc-ci-dot"
)

## ---- test-nBootstrap-bca-probs-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        z1 <- c(-1.96, 1.96)
        testthat::expect_equal(
          object = nBootstrap:::.BCAProbs(
            z0 = 0.1,
            z1 = z1,
            acceleration = 0
          ),
          expected = nBootstrap:::.BCProbs(z0 = 0.1, z1 = z1)
        )
        testthat::expect_equal(
          object = nBootstrap:::.BCAProbs(
            z0 = 0.1,
            z1 = z1,
            acceleration = 0.05
          ),
          expected = stats::pnorm(
            q = 0.1 + (0.1 + z1) / (1 - 0.05 * (0.1 + z1))
          )
        )
      }
    )
  },
  text = "test-nBootstrap-bca-probs-dot"
)

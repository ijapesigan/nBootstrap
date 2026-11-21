## ---- test-nBootstrap-acceleration-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        jackknife <- c(1, 2, 6)
        p <- mean(x = jackknife) - jackknife
        testthat::expect_equal(
          object = nBootstrap:::.Acceleration(jackknife = jackknife),
          expected = sum(p^3) / (6 * sum(p^2)^(3 / 2))
        )
        testthat::expect_equal(
          object = nBootstrap:::.Acceleration(jackknife = jackknife),
          expected = -18 / (6 * 14^(3 / 2))
        )
        testthat::expect_equal(
          object = nBootstrap:::.Acceleration(jackknife = c(1, 2, 3)),
          expected = 0
        )
      }
    )
  },
  text = "test-nBootstrap-acceleration-dot"
)

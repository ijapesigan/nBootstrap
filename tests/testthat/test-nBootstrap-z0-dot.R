## ---- test-nBootstrap-z0-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        testthat::expect_equal(
          object = nBootstrap:::.Z0(thetahatstar = 1:10, thetahat = 5.5),
          expected = 0
        )
        testthat::expect_equal(
          object = nBootstrap:::.Z0(thetahatstar = 1:10, thetahat = 3.5),
          expected = stats::qnorm(p = 0.3)
        )
        testthat::expect_equal(
          object = nBootstrap:::.Z0(thetahatstar = 1:10, thetahat = 100),
          expected = Inf
        )
        testthat::expect_equal(
          object = nBootstrap:::.Z0(
            thetahatstar = c(1:10, NA),
            thetahat = 3.5
          ),
          expected = stats::qnorm(p = 0.3)
        )
      }
    )
  },
  text = "test-nBootstrap-z0-dot"
)

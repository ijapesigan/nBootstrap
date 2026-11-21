## ---- test-nBootstrap-ci-check
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "valid input passes, invalid input stops"),
      code = {
        draws <- matrix(data = as.numeric(x = 1:20), ncol = 2)
        testthat::expect_null(
          object = nBootstrap:::.CheckCI(
            thetahatstar = draws,
            thetahat = c(1, 2),
            alpha = 0.05,
            jackknife = NULL
          )
        )
        testthat::expect_error(
          object = nBootstrap:::.CheckCI(
            thetahatstar = draws,
            thetahat = c(1, 2),
            alpha = 1.5,
            jackknife = NULL
          )
        )
        testthat::expect_error(
          object = nBootstrap:::.CheckCI(
            thetahatstar = draws,
            thetahat = c(1, 2),
            alpha = 0.05,
            jackknife = matrix(data = 1, nrow = 5, ncol = 3)
          )
        )
      }
    )
  },
  text = "test-nBootstrap-ci-check"
)

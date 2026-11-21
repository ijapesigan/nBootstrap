## ---- test-nBootstrap-bcci
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    set.seed(seed = 42)
    x <- matrix(data = stats::rnorm(n = 200), ncol = 2)
    thetahat <- c(m1 = mean(x = x[, 1]), m2 = mean(x = x[, 2]))
    thetahatstar <- t(
      x = replicate(
        n = 500,
        expr = colMeans(x = x[sample.int(n = 100, replace = TRUE), ])
      )
    )
    jackknife <- t(
      x = vapply(
        X = seq_len(length.out = 100),
        FUN = function(i) {
          colMeans(x = x[-i, ])
        },
        FUN.VALUE = numeric(length = 2)
      )
    )
    testthat::test_that(
      desc = paste(text, "equals the internal worker"),
      code = {
        out <- BCCI(
          thetahatstar = thetahatstar,
          thetahat = thetahat,
          alpha = c(0.05, 0.01)
        )
        testthat::expect_equal(
          object = out,
          expected = nBootstrap:::.CIMat(
            thetahatstar = thetahatstar,
            thetahat = thetahat,
            alpha = c(0.05, 0.01),
            type = "bc"
          )
        )
        testthat::expect_equal(
          object = rownames(x = out),
          expected = c("m1", "m2")
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "drops missing draws"),
      code = {
        draws <- thetahatstar
        draws[1:5, 1] <- NA
        out <- BCCI(
          thetahatstar = draws,
          thetahat = thetahat,
          alpha = 0.05
        )
        testthat::expect_equal(
          object = unname(obj = out[, "R"]),
          expected = c(495, 500)
        )
        testthat::expect_true(
          object = all(is.finite(x = out))
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "stops on invalid input"),
      code = {
        testthat::expect_error(
          object = BCCI(
            thetahatstar = thetahatstar,
            thetahat = 1,
            alpha = 0.05
          )
        )
      }
    )
  },
  text = "test-nBootstrap-bcci"
)

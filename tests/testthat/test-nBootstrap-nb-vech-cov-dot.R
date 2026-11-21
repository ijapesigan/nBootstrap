## ---- test-nBootstrap-nb-vech-cov-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    vech <- function(s) {
      s[lower.tri(x = s, diag = TRUE)]
    }
    testthat::test_that(
      desc = paste(text, ".NBVechCov agrees with stats::cov"),
      code = {
        set.seed(seed = 11)
        x <- matrix(data = stats::rnorm(n = 30), ncol = 3)
        idx <- matrix(
          data = sample.int(n = 10, size = 40, replace = TRUE),
          nrow = 10
        )
        out <- nBootstrap:::.NBVechCov(x = x, idx = idx)
        testthat::expect_equal(object = dim(x = out), expected = c(4L, 6L))
        testthat::expect_equal(
          object = out[3, ],
          expected = vech(s = stats::cov(x = x[idx[, 3], ]))
        )
      }
    )
    testthat::test_that(
      desc = paste(text, ".NBVechCov k = 1 and k = 2"),
      code = {
        x <- matrix(data = c(1, 2, 4, 7), ncol = 1)
        idx <- matrix(data = c(1L, 2L, 3L, 4L, 4L, 3L, 2L, 2L), nrow = 4)
        out <- nBootstrap:::.NBVechCov(x = x, idx = idx)
        testthat::expect_equal(
          object = out,
          expected = matrix(
            data = c(stats::var(x = x[1:4]), stats::var(x = x[c(4, 3, 2, 2)])),
            ncol = 1
          )
        )
        x <- cbind(c(1, 2, 4, 7), c(2, 1, 5, 3))
        out <- nBootstrap:::.NBVechCov(x = x, idx = idx)
        testthat::expect_equal(
          object = out[2, ],
          expected = vech(s = stats::cov(x = x[idx[, 2], ]))
        )
      }
    )
    testthat::test_that(
      desc = paste(text, ".JackknifeVechCov agrees with leave-one-out cov"),
      code = {
        set.seed(seed = 5)
        x <- matrix(data = stats::rnorm(n = 36), ncol = 3)
        out <- nBootstrap:::.JackknifeVechCov(x = x)
        expected <- t(
          x = vapply(
            X = seq_len(length.out = 12),
            FUN = function(i) {
              vech(s = stats::cov(x = x[-i, ]))
            },
            FUN.VALUE = numeric(length = 6)
          )
        )
        testthat::expect_equal(object = out, expected = expected)
        x <- matrix(data = c(1, 3, 2, 8, 5), ncol = 1)
        testthat::expect_equal(
          object = nBootstrap:::.JackknifeVechCov(x = x)[, 1],
          expected = vapply(
            X = 1:5,
            FUN = function(i) {
              stats::var(x = x[-i, 1])
            },
            FUN.VALUE = numeric(length = 1)
          )
        )
      }
    )
  },
  text = "test-nBootstrap-nb-vech-cov-dot"
)

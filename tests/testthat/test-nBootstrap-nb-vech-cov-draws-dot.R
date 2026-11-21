## ---- test-nBootstrap-nb-vech-cov-draws-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "same random stream as sample.int"),
      code = {
        x <- cbind(
          c(1, 3, 2, 6, 5, 9, 4),
          c(2, 1, 5, 4, 8, 7, 3),
          c(9, 2, 4, 1, 3, 3, 8)
        )
        n <- nrow(x = x)
        set.seed(seed = 7)
        idx <- lapply(
          X = seq_len(length.out = 5),
          FUN = function(r) {
            sample.int(n = n, size = n, replace = TRUE)
          }
        )
        expected <- t(
          x = vapply(
            X = idx,
            FUN = function(j) {
              s <- stats::cov(x = x[j, ])
              s[lower.tri(x = s, diag = TRUE)]
            },
            FUN.VALUE = numeric(length = 6)
          )
        )
        set.seed(seed = 7)
        out <- nBootstrap:::.NBVechCovDraws(x = x, R = 5L, block = 2L)
        testthat::expect_equal(object = out, expected = expected)
        set.seed(seed = 7)
        out <- nBootstrap:::.NBVechCovDraws(x = x, R = 5L)
        testthat::expect_equal(object = out, expected = expected)
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1 and k = 2"),
      code = {
        set.seed(seed = 3)
        out <- nBootstrap:::.NBVechCovDraws(
          x = matrix(data = stats::rnorm(n = 20), ncol = 1),
          R = 4L
        )
        testthat::expect_equal(object = dim(x = out), expected = c(4L, 1L))
        out <- nBootstrap:::.NBVechCovDraws(
          x = matrix(data = stats::rnorm(n = 40), ncol = 2),
          R = 6L
        )
        testthat::expect_equal(object = dim(x = out), expected = c(6L, 3L))
      }
    )
  },
  text = "test-nBootstrap-nb-vech-cov-draws-dot"
)

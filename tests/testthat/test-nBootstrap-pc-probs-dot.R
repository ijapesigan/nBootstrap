## ---- test-nBootstrap-pc-probs-dot
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
          object = nBootstrap:::.PCProbs(alpha = c(0.05, 0.01)),
          expected = c(0.005, 0.025, 0.975, 0.995)
        )
        testthat::expect_equal(
          object = nBootstrap:::.PCProbs(alpha = 0.05),
          expected = c(0.025, 0.975)
        )
      }
    )
  },
  text = "test-nBootstrap-pc-probs-dot"
)

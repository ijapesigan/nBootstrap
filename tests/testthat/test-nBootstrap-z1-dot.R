## ---- test-nBootstrap-z1-dot
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
          object = nBootstrap:::.Z1(probs = c(0.025, 0.5, 0.975)),
          expected = c(-1.959963984540054, 0, 1.959963984540054)
        )
      }
    )
  },
  text = "test-nBootstrap-z1-dot"
)

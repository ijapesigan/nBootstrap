## ---- test-nBootstrap-ci-mat-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)

    testthat::test_that(
      desc = paste(text, "agrees with looping the interval functions"),
      code = {
        set.seed(seed = 42)
        draws <- matrix(data = stats::rnorm(n = 600), nrow = 200)
        theta <- c(a = 0.1, b = -0.1, c = 0)
        jack <- matrix(data = stats::rnorm(n = 60), nrow = 20)
        probs <- nBootstrap:::.PCProbs(alpha = c(0.05, 0.01))
        z1 <- nBootstrap:::.Z1(probs = probs)
        pc <- nBootstrap:::.CIMat(
          thetahatstar = draws,
          thetahat = theta,
          alpha = c(0.05, 0.01),
          type = "pc"
        )
        testthat::expect_equal(
          object = rownames(x = pc),
          expected = c("a", "b", "c")
        )
        testthat::expect_equal(
          object = colnames(x = pc),
          expected = c("est", "se", "R", "0.5%", "2.5%", "97.5%", "99.5%")
        )
        testthat::expect_equal(
          object = pc[2, ],
          expected = nBootstrap:::.PCCI(
            thetahatstar = draws[, 2],
            thetahat = theta[[2]],
            probs = probs
          )
        )
        bc <- nBootstrap:::.CIMat(
          thetahatstar = draws,
          thetahat = theta,
          alpha = c(0.05, 0.01),
          type = "bc"
        )
        testthat::expect_equal(
          object = bc[3, ],
          expected = nBootstrap:::.BCCI(
            thetahatstar = draws[, 3],
            thetahat = theta[[3]],
            probs = probs,
            z0 = nBootstrap:::.Z0(
              thetahatstar = draws[, 3],
              thetahat = theta[[3]]
            ),
            z1 = z1
          )
        )
        bca <- nBootstrap:::.CIMat(
          thetahatstar = draws,
          thetahat = theta,
          alpha = c(0.05, 0.01),
          type = "bca",
          jackknife = jack
        )
        testthat::expect_equal(
          object = bca[1, ],
          expected = nBootstrap:::.BCACI(
            thetahatstar = draws[, 1],
            thetahat = theta[[1]],
            probs = probs,
            z0 = nBootstrap:::.Z0(
              thetahatstar = draws[, 1],
              thetahat = theta[[1]]
            ),
            z1 = z1,
            acceleration = nBootstrap:::.Acceleration(jackknife = jack[, 1])
          )
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1"),
      code = {
        set.seed(seed = 1)
        out <- nBootstrap:::.CIMat(
          thetahatstar = matrix(data = stats::rnorm(n = 100), ncol = 1),
          thetahat = c(m = 0),
          type = "pc"
        )
        testthat::expect_equal(
          object = dim(x = out),
          expected = c(1L, 9L)
        )
      }
    )
  },
  text = "test-nBootstrap-ci-mat-dot"
)

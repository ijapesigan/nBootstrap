#' Bias-Corrected Confidence Intervals
#'
#' Returns bias-corrected confidence intervals
#' from the draws of a nonparametric bootstrap:
#' the quantiles of the draws at
#' \eqn{\Phi \left( 2 \hat{z}_{0} + z_{p} \right)},
#' where \eqn{\hat{z}_{0} = \Phi^{-1} \left(
#' \# \{ \hat{\theta}^{*} < \hat{\theta} \} / R \right)}
#' and \eqn{z_{p}} is the standard normal quantile of each limit.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param thetahatstar Numeric matrix.
#'   Sampling distribution: one row per draw, one column per parameter.
#'   A numeric vector is taken as one parameter.
#'   Missing draws (`NA`) are dropped, parameter by parameter.
#' @param thetahat Numeric vector.
#'   Parameter estimates, one per column of `thetahatstar`.
#'   Its names name the rows of the result.
#' @param alpha Numeric vector.
#'   Significance levels \eqn{\alpha}.
#'
#' @return Returns a numeric matrix with one row per parameter:
#'   the estimate (`est`), the standard deviation of the draws (`se`),
#'   the number of draws used (`R`), and the confidence limits.
#'
#' @references
#' Efron, B., & Tibshirani, R. J. (1993).
#' *An introduction to the bootstrap*.
#' Chapman & Hall/CRC.
#' \doi{10.1201/9780429246593}
#'
#' @examples
#' set.seed(seed = 42)
#' x <- matrix(data = rnorm(n = 200), ncol = 2)
#' thetahat <- c(m1 = mean(x = x[, 1]), m2 = mean(x = x[, 2]))
#' thetahatstar <- t(
#'   x = replicate(
#'     n = 1000,
#'     expr = colMeans(x = x[sample.int(n = 100, replace = TRUE), ])
#'   )
#' )
#' BCCI(
#'   thetahatstar = thetahatstar,
#'   thetahat = thetahat,
#'   alpha = 0.05
#' )
#'
#' @family Confidence Intervals Functions
#' @keywords nBootstrap ci
#' @export
BCCI <- function(thetahatstar,
                 thetahat,
                 alpha = c(0.05, 0.01, 0.001)) {
  thetahatstar <- as.matrix(x = thetahatstar)
  .CheckCI(
    thetahatstar = thetahatstar,
    thetahat = thetahat,
    alpha = alpha,
    jackknife = NULL
  )
  .CIMat(
    thetahatstar = thetahatstar,
    thetahat = thetahat,
    alpha = alpha,
    type = "bc"
  )
}

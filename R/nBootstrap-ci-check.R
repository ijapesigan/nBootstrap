#' Check the Input of the Confidence Interval Functions
#'
#' Stops with an error when the draws, the estimates,
#' the significance levels, or the jackknife estimates are not valid.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param thetahatstar Numeric matrix.
#'   Sampling distribution: one row per draw, one column per parameter.
#' @param thetahat Numeric vector.
#'   Parameter estimates, one per column of `thetahatstar`.
#' @param alpha Numeric vector.
#'   Significance levels \eqn{\alpha}.
#' @param jackknife Numeric matrix or `NULL`.
#'   Jackknife estimates, one column per parameter.
#'
#' @return Returns `NULL`, invisibly.
#'
#' @examples
#' .CheckCI(
#'   thetahatstar = matrix(data = 1:10),
#'   thetahat = 5,
#'   alpha = 0.05,
#'   jackknife = NULL
#' )
#'
#' @family Confidence Intervals Functions
#' @keywords nBootstrap ci internal
#' @noRd
.CheckCI <- function(thetahatstar,
                     thetahat,
                     alpha,
                     jackknife) {
  stopifnot(
    is.numeric(x = thetahatstar),
    is.matrix(x = thetahatstar),
    is.numeric(x = thetahat),
    length(x = thetahat) == ncol(x = thetahatstar),
    is.numeric(x = alpha),
    length(x = alpha) > 0,
    all(alpha > 0 & alpha < 1)
  )
  if (!is.null(x = jackknife)) {
    jackknife <- as.matrix(x = jackknife)
    stopifnot(
      is.numeric(x = jackknife),
      ncol(x = jackknife) == length(x = thetahat),
      nrow(x = jackknife) > 2
    )
  }
  invisible(x = NULL)
}

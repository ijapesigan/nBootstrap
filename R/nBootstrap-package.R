#' nBootstrap: Nonparametric Bootstrap Confidence Intervals
#'
#' Percentile, bias-corrected, and bias-corrected and accelerated
#' confidence intervals from a matrix of draws,
#' and nonparametric bootstrap and jackknife
#' half-vectorized covariance matrices computed in C++.
#' `PCCI()`, `BCCI()`, and `BCaCI()` are exported;
#' the internal workers are copied by other projects.
#'
#' @author Ivan Jacob Agaloos Pesigan
#' @aliases nBootstrap-package
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib nBootstrap, .registration = TRUE
## usethis namespace: end
NULL

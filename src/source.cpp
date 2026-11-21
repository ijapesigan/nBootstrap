// -----------------------------------------------------------------------------
// edit .setup/cpp/000-forward-declarations.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

arma::mat JackknifeVechCov(const arma::mat& x);

arma::mat NBVechCov(const arma::mat& x, const arma::umat& idx);

Rcpp::NumericVector Quantile(const arma::vec& x, const arma::vec& probs);

arma::rowvec VechCpp(const arma::mat& x);
// -----------------------------------------------------------------------------
// edit .setup/cpp/linearAlgebra-vech-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' Half-Vectorization of a Square Matrix (C++)
//'
//' Stacks the lower triangle of a square matrix,
//' diagonal included, column by column, as `.Vech()` in R.
//' Called from other C++ functions; not exported to R.
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param x Numeric \eqn{k \times k} matrix.
//'
//' @return Numeric row vector of length \eqn{k (k + 1) / 2}.
//'
//' @examples
//' # C++ only: VechCpp(x = sigma)
//'
//' @noRd
arma::rowvec VechCpp(const arma::mat& x) {
  const arma::uword k = x.n_rows;
  arma::rowvec out(k * (k + 1) / 2);
  arma::uword idx = 0;
  for (arma::uword j = 0; j < k; j++) {
    for (arma::uword i = j; i < k; i++) {
      out(idx) = x(i, j);
      idx++;
    }
  }
  return out;
}
// -----------------------------------------------------------------------------
// edit .setup/cpp/nBootstrap-nb-vech-cov-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' Nonparametric Bootstrap Half-Vectorized Covariance Matrices (C++)
//'
//' Half-vectorization of the sample covariance matrix
//' (denominator \eqn{n - 1}, as `stats::cov()`)
//' of `x[idx[, r], ]` for each bootstrap sample `r`.
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param x Numeric \eqn{n \times k} matrix.
//'   Data.
//' @param idx Integer matrix.
//'   1-based row indices, one column per bootstrap sample.
//'
//' @return Numeric matrix with one row per bootstrap sample
//'   and \eqn{k (k + 1) / 2} columns.
//'
//' @examples
//' x <- matrix(data = c(1, 2, 4, 3, 5, 9), nrow = 3)
//' idx <- matrix(data = c(1L, 2L, 3L, 3L, 2L, 1L), nrow = 3)
//' .NBVechCov(x = x, idx = idx)
//'
//' @noRd
// [[Rcpp::export(.NBVechCov)]]
arma::mat NBVechCov(const arma::mat& x, const arma::umat& idx) {
  const arma::uword k = x.n_cols;
  const arma::uword n_boot = idx.n_cols;
  arma::mat out(n_boot, k * (k + 1) / 2);
  for (arma::uword r = 0; r < n_boot; r++) {
    const arma::mat xr = x.rows(idx.col(r) - 1);
    out.row(r) = VechCpp(arma::cov(xr));
  }
  return out;
}

//' Leave-One-Out Half-Vectorized Covariance Matrices (C++)
//'
//' Half-vectorization of the leave-one-out sample covariance matrices
//' of `x` (row `i` is `stats::cov(x[-i, ])`),
//' by the closed-form downdate
//' \eqn{S_{(-i)} = [(n - 1) S - n / (n - 1) d_i d_i'] / (n - 2)},
//' with \eqn{d_i = x_i - \bar{x}}.
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param x Numeric \eqn{n \times k} matrix.
//'   Data.
//'
//' @return Numeric matrix with \eqn{n} rows
//'   and \eqn{k (k + 1) / 2} columns.
//'
//' @examples
//' x <- matrix(data = c(1, 2, 4, 7, 3, 5, 9, 8), nrow = 4)
//' .JackknifeVechCov(x = x)
//'
//' @noRd
// [[Rcpp::export(.JackknifeVechCov)]]
arma::mat JackknifeVechCov(const arma::mat& x) {
  const arma::uword n = x.n_rows;
  const arma::uword k = x.n_cols;
  const double nd = static_cast<double>(n);
  const arma::rowvec mu = arma::mean(x, 0);
  const arma::mat ss = (nd - 1.0) * arma::cov(x);
  arma::mat out(n, k * (k + 1) / 2);
  for (arma::uword i = 0; i < n; i++) {
    const arma::vec d = (x.row(i) - mu).t();
    out.row(i) = VechCpp((ss - (nd / (nd - 1.0)) * (d * d.t())) / (nd - 2.0));
  }
  return out;
}
// -----------------------------------------------------------------------------
// edit .setup/cpp/nBootstrap-quantile-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' Sample Quantiles, Type 7 (C++)
//'
//' Returns the sample quantiles of `x` at `probs`
//' with the same arithmetic as `stats::quantile(type = 7)`:
//' with \eqn{h = 1 + (n - 1) p}, \eqn{l = \lfloor h \rfloor},
//' and \eqn{u = \lceil h \rceil},
//' the quantile is \eqn{(1 - (h - l)) x_{(l)} + (h - l) x_{(u)}},
//' or \eqn{x_{(l)}} when \eqn{h = l} or \eqn{x_{(u)} = x_{(l)}}.
//' `x` has no missing values (the callers drop them).
//' An empty `x` gives `NA`, as in R;
//' a probability outside \eqn{\left[ 0, 1 \right]} or missing stops.
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param x Numeric vector.
//'   Draws, without missing values.
//' @param probs Numeric vector.
//'   Probabilities.
//'
//' @return Numeric vector of the length of `probs`.
//'
//' @examples
//' .Quantile(x = c(3, 1, 2, 5), probs = c(0.025, 0.5, 0.975))
//'
//' @noRd
// [[Rcpp::export(.Quantile)]]
Rcpp::NumericVector Quantile(const arma::vec& x, const arma::vec& probs) {
  const arma::vec xs = arma::sort(x);
  const arma::uword n = xs.n_elem;
  Rcpp::NumericVector out(probs.n_elem, NA_REAL);
  if (n == 0) {
    return out;
  }
  const double nm1 = static_cast<double>(n - 1);
  for (arma::uword i = 0; i < probs.n_elem; i++) {
    if (!(probs(i) >= 0.0 && probs(i) <= 1.0)) {
      Rcpp::stop("probabilities must be in [0, 1].");
    }
    // 1-based index as in R
    const double index = 1.0 + nm1 * probs(i);
    const double lo = std::floor(index);
    const double hi = std::ceil(index);
    const double qs = xs(static_cast<arma::uword>(lo) - 1);
    const double xhi = xs(static_cast<arma::uword>(hi) - 1);
    if (index > lo && xhi != qs) {
      const double h = index - lo;
      out[i] = (1.0 - h) * qs + h * xhi;
    } else {
      out[i] = qs;
    }
  }
  return out;
}

# Changelog

## nBootstrap 0.1.0

### New features

- [`PCCI()`](https://ijapesigan.github.io/nBootstrap/reference/PCCI.md),
  [`BCCI()`](https://ijapesigan.github.io/nBootstrap/reference/BCCI.md),
  and
  [`BCaCI()`](https://ijapesigan.github.io/nBootstrap/reference/BCaCI.md):
  exported percentile, bias-corrected, and bias-corrected and
  accelerated confidence intervals from a matrix of draws, with input
  checks (`.CheckCI()`), documentation, examples, and tests.

### Improvements

- The interval quantiles are computed in C++ (`.Quantile()`), with the
  arithmetic of `stats::quantile(type = 7)`: the results equal those of
  [`stats::quantile()`](https://rdrr.io/r/stats/quantile.html) to a
  relative tolerance of `1e-12` (not bit for bit: compilers may fuse the
  interpolation into one multiply-add, as on the CI runners).

### Bug fixes

- `.Z0()` drops missing draws, as the interval functions do: a draw that
  failed (`NA`) no longer makes the bias-corrected and the
  bias-corrected and accelerated intervals fail. Results without missing
  draws are unchanged.

### Other changes

- `make lint` runs with `lint_error = TRUE` (rProject 0.0.76 recognizes
  the locked copy `linearAlgebra-vech-dot.cpp`).

## nBootstrap 0.0.1

### Initial release

- The rProject template (0.0.68); private `jeksterslab-psu/nBootstrap`,
  public `ijapesigan/nBootstrap`.
- Confidence intervals from a matrix of draws (percentile,
  bias-corrected, bias-corrected and accelerated), and nonparametric
  bootstrap and jackknife half-vectorized covariance matrices in C++.
- Complete roxygen for every function; internal functions use `@noRd`.
- C++ moves from `cpp/` to `.setup/cpp/` with `Makevars` and forward
  declarations; `VechCpp()` is a locked copy from `linearAlgebra`.
- A test file for every function.

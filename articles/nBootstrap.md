# nBootstrap: Nonparametric Bootstrap Confidence Intervals

## Description

Nonparametric bootstrap helpers in R (R Core Team, 2026): percentile,
bias-corrected, and bias-corrected and accelerated confidence intervals
from a matrix of draws, and nonparametric bootstrap and jackknife
half-vectorized covariance matrices computed in C++. The functions are
internal; other projects copy them.

## Installation

You can install the development version of `nBootstrap` from
[GitHub](https://github.com/ijapesigan/nBootstrap) with:

\
`if`` ``(``!`[`require`](https://rdrr.io/r/base/library.html)`(`[`"pak"`](https://pak.r-lib.org/)`)``)`` `[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`\
`pak``::`[`pkg_install`](https://pak.r-lib.org/reference/pkg_install.html)`(``"ijapesigan/nBootstrap"``)`

## Example

The functions are internal.

\
[`set.seed`](https://rdrr.io/r/base/Random.html)`(``seed ``=`` ``42``)`\
`x`` ``<-`` `[`as.matrix`](https://rdrr.io/r/base/matrix.html)`(``x ``=`` ``datasets``::`[`mtcars`](https://rdrr.io/r/datasets/mtcars.html)`[``, `[`c`](https://rdrr.io/r/base/c.html)`(``"mpg"``, ``"wt"``)``]``)`

Bootstrap draws of the half-vectorized covariance matrix.

\
`draws`` ``<-`` ``nBootstrap``:::``.NBVechCovDraws``(``x ``=`` ``x``, R ``=`` ``1000L``)`\
[`dim`](https://rdrr.io/r/base/dim.html)`(``x ``=`` ``draws``)`\
`#> [1] 1000    3`

Percentile confidence intervals for every column of the draws.

\
`theta_hat`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``stats``::`[`cov`](https://rdrr.io/r/stats/cor.html)`(``x ``=`` ``x``)``)``[`[`c`](https://rdrr.io/r/base/c.html)`(``1``, ``2``, ``4``)``]`\
[`names`](https://rdrr.io/r/base/names.html)`(``x ``=`` ``theta_hat``)`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"var_mpg"``, ``"cov"``, ``"var_wt"``)`\
[`colnames`](https://rdrr.io/r/base/colnames.html)`(``x ``=`` ``draws``)`` ``<-`` `[`names`](https://rdrr.io/r/base/names.html)`(``x ``=`` ``theta_hat``)`\
`nBootstrap``:::``.CIMat``(`\
`  thetahatstar ``=`` ``draws``,`\
`  thetahat ``=`` ``theta_hat``,`\
`  alpha ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``0.05``, ``0.01``)``,`\
`  type ``=`` ``"pc"`\
`)`\
`#>               est        se    R       0.5%       2.5%     97.5%     99.5%`\
`#> var_mpg 36.324103 8.2878501 1000 15.6449379 20.4642755 52.335445 56.567037`\
`#> cov     -5.116685 1.1974755 1000 -8.1858457 -7.5797050 -2.761651 -2.235399`\
`#> var_wt   0.957379 0.2412427 1000  0.4045389  0.4841965  1.418687  1.597035`

## Documentation

See [GitHub Pages](https://ijapesigan.github.io/nBootstrap) for package
documentation.

## References

R Core Team. (2026). *R: A language and environment for statistical
computing*. R Foundation for Statistical Computing.
<https://www.R-project.org/>

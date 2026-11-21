# Percentile Confidence Intervals

Returns percentile confidence intervals from the draws of a
nonparametric bootstrap (or any sampling distribution): the \\(\alpha /
2\\) and \\(1 - \alpha / 2\\) quantiles of the draws of each parameter.

## Usage

``` r
PCCI(thetahatstar, thetahat, alpha = c(0.05, 0.01, 0.001))
```

## Arguments

- thetahatstar:

  Numeric matrix. Sampling distribution: one row per draw, one column
  per parameter. A numeric vector is taken as one parameter. Missing
  draws (`NA`) are dropped, parameter by parameter.

- thetahat:

  Numeric vector. Parameter estimates, one per column of `thetahatstar`.
  Its names name the rows of the result.

- alpha:

  Numeric vector. Significance levels \\(\alpha\\).

## Value

Returns a numeric matrix with one row per parameter: the estimate
(`est`), the standard deviation of the draws (`se`), the number of draws
used (`R`), and the confidence limits.

## References

Efron, B., & Tibshirani, R. J. (1993). *An introduction to the
bootstrap*. Chapman & Hall/CRC.
[doi:10.1201/9780429246593](https://doi.org/10.1201/9780429246593)

## See also

Other Confidence Intervals Functions:
[`BCCI()`](https://ijapesigan.github.io/nBootstrap/reference/BCCI.md),
[`BCaCI()`](https://ijapesigan.github.io/nBootstrap/reference/BCaCI.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
set.seed(seed = 42)
x <- matrix(data = rnorm(n = 200), ncol = 2)
thetahat <- c(m1 = mean(x = x[, 1]), m2 = mean(x = x[, 2]))
thetahatstar <- t(
  x = replicate(
    n = 1000,
    expr = colMeans(x = x[sample.int(n = 100, replace = TRUE), ])
  )
)
PCCI(
  thetahatstar = thetahatstar,
  thetahat = thetahat,
  alpha = 0.05
)
#>            est         se    R       2.5%      97.5%
#> m1  0.03251482 0.10589716 1000 -0.1711675 0.23293449
#> m2 -0.08748371 0.08960159 1000 -0.2557318 0.09845637
```

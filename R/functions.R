#' Maximum likelihood estimated distribution
#'
#' Density, distribution function, quantile function and random generation for
#'    a univariate distribution estimated by maximum likelihood.
#'
#' `dml` is the density, `pml` is the distribution function,
#' `qml` is the quantile function, and `rml` is the random variable
#' generator.
#'
#' These functions work like their counterparts in `stats`, e.g.
#' [Normal][stats::Normal]. The `univariateML` object contains both maximum
#' likelihood estimates and the identity of the model these estimates were
#' calculated under. These functions are wrappers around underlying density,
#' distribution, quantile and random generation functions where unknown
#' parameters are filled with the maximum likelihood estimates.
#' See the example.
#'
#' @param x,q vector of quantiles.
#' @param p vector of probabilities.
#' @param n number of observations. If `length(n) > 1`, the length is
#'     taken to be the number required.
#' @param obj an `univariateML` object.
#' @param log,log.p logical; if `TRUE`, the probabilities p are gives as
#'     `log(p)`.
#' @param lower.tail logical; if `TRUE` (default), the probabilities are
#'     \eqn{P[X \le x]} otherwise, \eqn{P[X > x]}
#' @return `dml` gives the density, `pml` gives the distribution
#'     function, `qml` gives the quantile function, and `rml`
#'     generates random deviates.
#' @examples
#' ## Simple example
#' obj <- mlnorm(airquality$Wind)
#' dml(0.5, obj) == dnorm(0.5, mean = obj[1], sd = obj[2])
#'
#' obj <- mlbetapr(airquality$Wind)
#'
#' # Plot the logarithm of the beta prime distribution.
#' plot(function(x) dml(x, obj, log = TRUE),
#'   from = 0, to = 20,
#'   main = "Logarithm of Density", ylab = NA, lwd = 2
#' )
#'
#' @name MaximumLikelihoodDistribution
#' @export
dml <- function(x, obj, log = FALSE) {
  univariateML_to_function(obj, type = "d")(x = x, log = log)
}

#' @rdname MaximumLikelihoodDistribution
#' @export
pml <- function(q = q, obj, lower.tail = TRUE, log.p = FALSE) {
  univariateML_to_function(obj, type = "p")(
    q = q,
    lower.tail = lower.tail,
    log.p = log.p
  )
}

#' @rdname MaximumLikelihoodDistribution
#' @export
qml <- function(p = p, obj, lower.tail = TRUE, log.p = FALSE) {
  univariateML_to_function(obj, type = "q")(
    p = p,
    lower.tail = lower.tail,
    log.p = log.p)
}

#' @rdname MaximumLikelihoodDistribution
#' @export
rml <- function(n = n, obj) {
  univariateML_to_function(obj, type = "r")(n = n)
}

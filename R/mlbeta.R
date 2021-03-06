#' Beta distribution maximum likelihood estimation
#'
#' Uses `stat::nlm` to estimate the parameters of the Beta distribution.
#'
#' For the density function of the Beta distribution see [Beta][stats::Beta].
#'
#' @param x a (non-empty) numeric vector of data values.
#' @param na.rm logical. Should missing values be removed?
#' @param ... `start` contains optional starting parameter values for the
#'   minimization, passed to the `stats::nlm` function. `type` specifies whether
#'   a dedicated `"gradient"`, `"hessian"`, or `"none"` should be passed to
#'   `stats::nlm`.
#' @return `mlbeta` returns an object of [class][base::class]
#'    `univariateML`. This is a named numeric vector with maximum
#'    likelihood estimates for `shape1` and `shape2` and the
#'    following attributes:
#'     \item{`model`}{The name of the model.}
#'     \item{`density`}{The density associated with the estimates.}
#'     \item{`logLik`}{The loglikelihood at the maximum.}
#'     \item{`support`}{The support of the density.}
#'     \item{`n`}{The number of observations.}
#'     \item{`call`}{The call as captured my `match.call`}
#' @details For `type`, the option `none` is fastest.
#' @seealso [Beta][stats::Beta] for the Beta density, [nlm][stats::nlm] for the
#'   optimizer this function uses.
#' @references Johnson, N. L., Kotz, S. and Balakrishnan, N. (1995)
#' Continuous Univariate Distributions, Volume 2, Chapter 25. Wiley, New York.
#'
#' @examples
#' AIC(mlbeta(USArrests$Rape / 100))
#' @export

mlbeta <- function(x, na.rm = FALSE, ...) {
  if (na.rm) x <- x[!is.na(x)] else assertthat::assert_that(!anyNA(x))
  ml_input_checker(x)
  assertthat::assert_that(min(x) > 0)
  assertthat::assert_that(max(x) < 1)

  val1 <- mean(log(x))
  val2 <- mean(log(1 - x))

  dots <- list(...)
  type <- if (!is.null(dots$type)) dots$type else "none"
  type <- match.arg(type, c("none", "gradient", "hessian"))

  if (!is.null(dots$start)) {
    start <- dots$start
  } else {
    G1 <- exp(val1)
    G2 <- exp(val2)
    denom <- 1 / 2 * (1 / (1 - G1 - G2))
    start <- c(1 / 2 + G1 * denom, 1 / 2 + G2 * denom)
  }

  objective <- function(p) {
    lbeta(p[1], p[2]) - (p[1] - 1) * val1 - (p[2] - 1) * val2
  }

  gradient <- function(p) {
    digamma_alpha_beta <- digamma(p[1] + p[2])
    c(
      digamma(p[1]) - digamma_alpha_beta - val1,
      digamma(p[2]) - digamma_alpha_beta - val2
    )
  }

  if (type == "gradient") {
    beta_objective <- function(p) {
      result <- objective(p)
      attr(result, "gradient") <- gradient(p)
      result
    }
  } else if (type == "hessian") {
    hessian <- function(p) {
      trigamma_alpha_beta <- -trigamma(p[1] + p[2])
      matrix(trigamma_alpha_beta, nrow = 2, ncol = 2) +
        diag(c(trigamma(p[1]), trigamma(p[2])))
    }

    beta_objective <- function(p) {
      result <- objective(p)
      attr(result, "gradient") <- gradient(p)
      attr(result, "hessian") <- hessian(p)
      result
    }
  } else {
    beta_objective <- objective
  }

  object <- stats::nlm(beta_objective, p = start, typsize = start)$estimate
  names(object) <- c("shape1", "shape2")
  class(object) <- "univariateML"
  attr(object, "model") <- "Beta"
  attr(object, "density") <- "stats::dbeta"
  attr(object, "logLik") <- -length(x) *
    stats::setNames(objective(object), NULL)
  attr(object, "support") <- c(0, 1)
  attr(object, "n") <- length(x)
  attr(object, "call") <- match.call()
  object
}

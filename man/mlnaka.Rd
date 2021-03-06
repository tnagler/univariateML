% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mlnaka.R
\name{mlnaka}
\alias{mlnaka}
\title{Nakagami distribution maximum likelihood estimation}
\usage{
mlnaka(x, na.rm = FALSE, ...)
}
\arguments{
\item{x}{a (non-empty) numeric vector of data values.}

\item{na.rm}{logical. Should missing values be removed?}

\item{...}{passed to \code{\link{mlgamma}}.}
}
\value{
\code{mlgamma} returns an object of \link[base:class]{class}
\code{univariateML}. This is a named numeric vector with maximum
likelihood estimates for \code{shape} and \code{rate} and the following
attributes:
\item{\code{model}}{The name of the model.}
\item{\code{density}}{The density associated with the estimates.}
\item{\code{logLik}}{The loglikelihood at the maximum.}
\item{\code{support}}{The support of the density.}
\item{\code{n}}{The number of observations.}
\item{\code{call}}{The call as captured my \code{match.call}}
}
\description{
The maximum likelihood estimates of \code{shape} and \code{scale} are calculated by
calling \code{mlgamma} on the transformed data.
}
\details{
For the density function of the Nakagami distribution see
\link[nakagami:Nakagami]{Nakagami}.
}
\examples{
mlgamma(precip)
}
\references{
Choi, S. C, and R. Wette. "Maximum likelihood estimation of the
parameters of the gamma distribution and their bias." Technometrics 11.4
(1969): 683-690.

Johnson, N. L., Kotz, S. and Balakrishnan, N. (1995) Continuous Univariate
Distributions, Volume 1, Chapter 17. Wiley, New York.
}
\seealso{
\link[nakagami:Nakagami]{Nakagami} for the Nakagami distribution.
\link[stats:GammaDist]{GammaDist} for the closely related Gamma density.
See \code{\link{mlgamma}} for the machinery underlying this function.
}

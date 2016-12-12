% Please edit documentation in R/render.R
\name{infinite_moon_reader}
\alias{inf_mr}
\alias{infinite_moon_reader}
\title{Serve and live reload slides}
\usage{
infinite_moon_reader(moon)

inf_mr(moon)
}
\arguments{
\item{moon}{The input Rmd file path (if missing and in RStudio, the current
active document is used).}
}
\description{
Use the \pkg{servr} package to serve and reload slides on change.
\code{inf_mr()} is an alias of \code{infinite_moon_reader()}.
}
\details{
The Rmd document is compiled continuously to trap the world in the Infinite
Tsukuyomi.
}
\note{
This function is not really tied to the output format
  \code{\link{moon_reader}()}. You can use it to serve any single-HTML-file R
  Markdown output.
}
\references{
\url{http://naruto.wikia.com/wiki/Infinite_Tsukuyomi}
}
\seealso{
\code{servr::\link{httw}}
}

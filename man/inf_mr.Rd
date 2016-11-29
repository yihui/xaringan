% Please edit documentation in R/render.R
\name{infinite_moon_reader}
\alias{inf_mr}
\alias{infinite_moon_reader}
\title{Serve and live reload slides}
\usage{
infinite_moon_reader(input)

inf_mr(input)
}
\arguments{
\item{input}{The input Rmd file path (if missing and in RStudio, the current
active document is used).}
}
\description{
Use the \pkg{servr} package to serve and reload slides on change.
\code{inf_mr()} is an alias of \code{infinite_moon_reader()}.
}

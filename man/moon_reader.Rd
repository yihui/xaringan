% Please edit documentation in R/render.R
\name{moon_reader}
\alias{moon_reader}
\title{An R Markdown output format for remark.js slides}
\usage{
moon_reader(fig_width = 7, fig_height = 5, dev = "png", css = "default", 
    lib_dir = "libs", title_slide = FALSE, yolo = FALSE, 
    chakra = "https://remarkjs.com/downloads/remark-latest.min.js", 
    nature = list())
}
\arguments{
\item{fig_width, fig_height, dev}{The figure width/height and graphical device
for R plots.}

\item{css}{A vector of CSS file paths. A default CSS file is provided in this
package for minimal styling (borrowed from
\url{https://github.com/gnab/remark/wiki}).}

\item{lib_dir}{A directory name for HTML dependencies.}

\item{title_slide}{Whether to generate a title slide automatically using the
YAML metadata of the R Markdown document.}

\item{chakra}{A path to the remark.js library (can be either local or
remote).}

\item{nature}{(Nature transformation) A list of configurations to be passed
to \code{remark.create()}, e.g. \code{list(ratio = '16:9')}; see
\url{https://github.com/gnab/remark/wiki/Configuration}.}
}
\description{
This output format produces an HTML file that contains the Markdown source
(knitted from R Markdown) and JavaScript code to render slides.
}

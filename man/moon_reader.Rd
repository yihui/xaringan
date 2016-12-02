% Please edit documentation in R/render.R
\name{moon_reader}
\alias{moon_reader}
\alias{tsukuyomi}
\title{An R Markdown output format for remark.js slides}
\usage{
moon_reader(fig_width = 7, fig_height = 5, dev = "png", css = "default", 
    self_contained = FALSE, lib_dir = "libs", seal = FALSE, yolo = FALSE, 
    chakra = "https://remarkjs.com/downloads/remark-latest.min.js", nature = list(), 
    ...)

tsukuyomi(...)
}
\arguments{
\item{fig_width, fig_height, dev}{The figure width/height and graphical device
for R plots.}

\item{css}{A vector of CSS file paths. A default CSS file is provided in this
package for minimal styling (borrowed from
\url{https://github.com/gnab/remark/wiki}).}

\item{self_contained}{Whether to produce a self-contained HTML file.}

\item{lib_dir}{A directory name for HTML dependencies.}

\item{seal}{Whether to generate a title slide automatically using the YAML
metadata of the R Markdown document.}

\item{yolo}{Whether to insert the
\href{https://kbroman.wordpress.com/2014/08/28/the-mustache-photo/}{Mustache
 Karl (TM)} randomly in the slides. \code{TRUE} means insert his picture on
one slide, and if you want him to be on multiple slides, set \code{yolo} to
a positive integer or a percentage (e.g. 0.3 means 30\% of your slides will
be the Mustache Karl). Alternatively, \code{yolo} can also be a list of the
form \code{list(times = n, img = path)}: \code{n} is the number of times to
show an image, and \code{path} is the path to an image (by default, it is
Karl).}

\item{chakra}{A path to the remark.js library (can be either local or
remote).}

\item{nature}{(Nature transformation) A list of configurations to be passed
to \code{remark.create()}, e.g. \code{list(ratio = '16:9', navigation =
list(click = TRUE))}; see
\url{https://github.com/gnab/remark/wiki/Configuration}. Besides the
options provided by remark.js, you can also set \code{autoplay} to a number
(the number of milliseconds) so the slides will be played every
\code{autoplay} seconds.}

\item{...}{For \code{tsukuyomi()}, arguments passed to \code{moon_reader()};
for \code{moon_reader()}, ignored.}
}
\description{
This output format produces an HTML file that contains the Markdown source
(knitted from R Markdown) and JavaScript code to render slides.
\code{tsukuyomi()} is an alias of \code{moon_reader()}.
}
\details{
Tsukuyomi is a genjutsu to trap the target in an illusion on eye contact.
}
\note{
Do not stare at Karl's picture for too long after you turn on the
  \code{yolo} mode. I believe he has Sharingan.

  Local images that you inserted via the Markdown syntax
  \command{![](path/to/image)} will not be embedded into the HTML file when
  \code{self_contained = TRUE} (only CSS, JavaScript, and R plot files will
  be embedded). You may also download remark.js (via
  \code{\link{summon_remark}()}) and use a local copy instead of the default
  \code{chakra} argument when \code{self_contained = TRUE}, because it may be
  time-consuming for Pandoc to download remark.js each time you compile your
  slides.
}
\references{
\url{http://naruto.wikia.com/wiki/Tsukuyomi}
}

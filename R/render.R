#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides.
#' \code{tsukuyomi()} is an alias of \code{moon_reader()}.
#'
#' Tsukuyomi is a genjutsu to trap the target in an illusion on eye contact.
#' @param fig_width,fig_height,dev The figure width/height and graphical device
#'   for R plots.
#' @param css A vector of CSS file paths. A default CSS file is provided in this
#'   package for minimal styling (borrowed from
#'   \url{https://github.com/gnab/remark/wiki}).
#' @param self_contained Whether to produce a self-contained HTML file. Please
#'   note local images that you inserted via the Markdown syntax
#'   \command{![](path/to/image)} will not be embedded into the HTML file when
#'   \code{self_contained = TRUE} (only CSS, JavaScript, and R plot files will
#'   be embedded).
#' @param lib_dir A directory name for HTML dependencies.
#' @param seal Whether to generate a title slide automatically using the YAML
#'   metadata of the R Markdown document.
#' @param yolo Whether to insert the
#'   \href{https://kbroman.wordpress.com/2014/08/28/the-mustache-photo/}{Mustache
#'    Karl (TM)} randomly in the slides. \code{TRUE} means insert his picture on
#'   one slide, and if you want him to be on multiple slides, set \code{yolo} to
#'   a positive integer or a percentage (e.g. 0.3 means 30\% of your slides will
#'   be the Mustache Karl). Alternatively, \code{yolo} can also be a list of the
#'   form \code{list(times = n, img = path)}: \code{n} is the number of times to
#'   show an image, and \code{path} is the path to an image (by default, it is
#'   Karl).
#' @param chakra A path to the remark.js library (can be either local or
#'   remote).
#' @param nature (Nature transformation) A list of configurations to be passed
#'   to \code{remark.create()}, e.g. \code{list(ratio = '16:9')}; see
#'   \url{https://github.com/gnab/remark/wiki/Configuration}. Besides the
#'   options provided by remark.js, you can also set \code{autoplay} to a number
#'   (the number of milliseconds) so the slides will be played every
#'   \code{autoplay} seconds.
#' @param ... For \code{tsukuyomi()}, arguments passed to \code{moon_reader()};
#'   for \code{moon_reader()}, ignored.
#' @note Do not stare at Karl's picture for too long after you turn on the
#'   \code{yolo} mode. I believe he has Sharingan.
#' @references \url{http://naruto.wikia.com/wiki/Tsukuyomi}
#' @importFrom htmltools tagList tags htmlEscape HTML
#' @export
moon_reader = function(
  fig_width = 7, fig_height = 5, dev = 'png', css = 'default',
  self_contained = FALSE, lib_dir = 'libs', seal = FALSE, yolo = FALSE,
  chakra = 'https://remarkjs.com/downloads/remark-latest.min.js', nature = list(),
  ...
) {
  deps = if (identical(css, 'default')) {
    css = NULL
    list(example_css())
  }
  tmp_js = tempfile('xaringan', fileext = '.js')  # write JS config to this file
  tmp_md = tempfile('xaringan', fileext = '.md')  # store md content here (bypass Pandoc)

  play_js = if (is.numeric(autoplay <- nature[['autoplay']]) && autoplay > 0)
    sprintf('setInterval(function() {slideshow.gotoNextSlide();}, %d);', autoplay)
  nature[['autoplay']] = NULL

  writeUTF8(as.character(tagList(
    tags$script(src = chakra),
    tags$script(HTML(paste(c(sprintf(
      'var slideshow = remark.create(%s);', if (length(nature)) tojson(nature) else ''
    ), play_js), collapse = '\n')))
  )), tmp_js)
  includes = rmarkdown::includes(before_body = tmp_md, after_body = tmp_js)
  # when rendering in shiny mode, this resolver will be replaced by a special
  # resolver; see shiny_dependency_resolver in rmarkdown/R/shiny.R
  dependency_resolver = list(...)[['dependency_resolver']]

  optk = list()

  rmarkdown::output_format(
    NULL, NULL, clean_supporting = self_contained,
    pre_knit = function(...) {
      optk <<- knitr::opts_knit$get()
      if (self_contained) knitr::opts_knit$set(upload.fun = knitr::image_uri)
    },
    pre_processor = function(
      metadata, input_file, runtime, knit_meta, files_dir, output_dir
    ) {
      res = split_yaml_body(input_file)
      writeUTF8(res$yaml, input_file)
      body = res$body
      res$body = protect_math(body)
      writeUTF8(htmlEscape(yolofy(res$body, yolo)), tmp_md)
      c(
        if (seal) c('--variable', 'title-slide=true'),
        if (!identical(body, res$body)) c('--variable', 'math=true')
      )
    },
    on_exit = function() {
      unlink(c(tmp_md, tmp_js))
      if (self_contained) knitr::opts_knit$restore(optk)
    },
    base_format = rmarkdown::html_document(
      fig_width = fig_width, fig_height = fig_height, dev = dev, css = css,
      includes = includes, lib_dir = lib_dir, self_contained = self_contained,
      theme = NULL, highlight = NULL, extra_dependencies = deps,
      dependency_resolver = dependency_resolver,
      template = pkg_resource('default.html')
    )
  )
}

#' @export
#' @rdname moon_reader
tsukuyomi = function(...) moon_reader(...)

#' Serve and live reload slides
#'
#' Use the \pkg{servr} package to serve and reload slides on change.
#' \code{inf_mr()} is an alias of \code{infinite_moon_reader()}.
#'
#' The Rmd document is compiled continuously to trap the world in the Infinite
#' Tsukuyomi.
#' @param moon The input Rmd file path (if missing and in RStudio, the current
#'   active document is used).
#' @references \url{http://naruto.wikia.com/wiki/Infinite_Tsukuyomi}
#' @export
#' @rdname inf_mr
infinite_moon_reader = function(moon) {
  # when this function is called via the RStudio addin, use the dir of the
  # current active document
  if (missing(moon) && requireNamespace('rstudioapi', quietly = TRUE)) {
    context_fun = tryCatch(
      getFromNamespace('rstudioapi', 'getSourceEditorContext'),
      error = function(e) rstudioapi::getActiveDocumentContext
    )
    moon = context_fun()[['path']]
    if (is.null(moon)) stop('Cannot find the current active document in RStudio')
    if (!grepl('[.]R?md', moon, ignore.case = TRUE)) stop(
      'The current active document must be an R Markdown or Markdown document'
    )
  }
  moon = normalizePath(moon, mustWork = TRUE)
  rebuild = function(...) {
    if (moon %in% normalizePath(c(...))) rmarkdown::render(
      moon, 'xaringan::moon_reader', envir = globalenv()
    )
  }
  html = rebuild(moon)  # render slides initially
  servr::httw(dirname(moon), initpath = basename(html), handler = rebuild)
}

#' @export
#' @rdname inf_mr
inf_mr = infinite_moon_reader

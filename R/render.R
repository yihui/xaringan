#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides.
#' @param fig_width,fig_height,dev The figure width/height and graphical device
#'   for R plots.
#' @param css A vector of CSS file paths. A default CSS file is provided in this
#'   package for minimal styling (borrowed from
#'   \url{https://github.com/gnab/remark/wiki}).
#' @param lib_dir A directory name for HTML dependencies.
#' @param title_slide Whether to generate a title slide automatically using the
#'   YAML metadata of the R Markdown document.
#' @param chakra A path to the remark.js library (can be either local or
#'   remote).
#' @param nature (Nature transformation) A list of configurations to be passed
#'   to \code{remark.create()}, e.g. \code{list(ratio = '16:9')}; see
#'   \url{https://github.com/gnab/remark/wiki/Configuration}.
#' @importFrom htmltools tagList tags htmlEscape
#' @export
moon_reader = function(
  fig_width = 7, fig_height = 5, dev = 'png', css = 'default',
  lib_dir = 'libs', title_slide = FALSE,
  chakra = 'https://remarkjs.com/downloads/remark-latest.min.js', nature = list()
) {
  deps = if (identical(css, 'default')) {
    css = NULL
    list(example_css())
  }
  tmp_js = tempfile('xaringan', fileext = '.js')  # write JS config to this file
  tmp_md = tempfile('xaringan', fileext = '.md')  # store md content here (bypass Pandoc)

  writeUTF8(as.character(tagList(
    tags$script(src = chakra),
    tags$script(sprintf(
      'var slideshow = remark.create(%s);', if (length(nature)) tojson(nature) else ''
    ))
  )), tmp_js)
  includes = rmarkdown::includes(before_body = tmp_md, after_body = tmp_js)
  rmarkdown::output_format(
    NULL, NULL, clean_supporting = FALSE,
    pre_processor = function(
      metadata, input_file, runtime, knit_meta, files_dir, output_dir
    ) {
      res = split_yaml_body(input_file)
      writeUTF8(res$yaml, input_file)
      writeUTF8(htmlEscape(res$body), tmp_md)
      if (title_slide) c('--variable', 'title-slide=true')
    },
    base_format = rmarkdown::html_document(
      fig_width = fig_width, fig_height = fig_height, dev = dev, css = css,
      includes = includes, lib_dir = lib_dir, self_contained = FALSE, theme = NULL,
      highlight = NULL, extra_dependencies = deps, template = pkg_resource('default.html')
    )
  )
}

#' Serve and live reload slides
#'
#' Use the \pkg{servr} package to serve and reload slides on change.
#' \code{inf_mr()} is an alias of \code{infinite_moon_reader()}.
#' @param input The input Rmd file path (if missing and in RStudio, the current
#'   active document is used).
#' @export
#' @rdname inf_mr
infinite_moon_reader = function(input) {
  # when this function is called via the RStudio addin, use the dir of the
  # current active document
  if (missing(input) && requireNamespace('rstudioapi', quietly = TRUE)) {
    context_fun = tryCatch(
      getFromNamespace('rstudioapi', 'getSourceEditorContext'),
      error = function(e) rstudioapi::getActiveDocumentContext
    )
    input = context_fun()[['path']]
    if (is.null(input)) stop('Cannot find the current active document in RStudio')
    if (!grepl('[.]R?md', input, ignore.case = TRUE)) stop(
      'The current active document must be an R Markdown or Markdown document'
    )
  }
  input = normalizePath(input, mustWork = TRUE)
  rebuild = function(...) {
    if (input %in% normalizePath(c(...))) rmarkdown::render(
      input, 'xaringan::moon_reader', envir = globalenv()
    )
  }
  html = rebuild(input)  # render slides initially
  servr::httw(dirname(input), initpath = basename(html), handler = rebuild)
}

#' @export
#' @rdname inf_mr
inf_mr = infinite_moon_reader

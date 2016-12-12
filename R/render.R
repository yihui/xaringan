#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides.
#' \code{tsukuyomi()} is an alias of \code{moon_reader()}.
#'
#' Tsukuyomi is a genjutsu to trap the target in an illusion on eye contact.
#' @param css A vector of CSS file paths. A default CSS file is provided in this
#'   package, which was borrowed from \url{https://remarkjs.com}. If the
#'   character vector \code{css} contains the value \code{'default'}, the
#'   default CSS will be used (e.g. \code{css = c('default', 'extra.css')}).
#' @param self_contained Whether to produce a self-contained HTML file.
#' @param seal Whether to generate a title slide automatically using the YAML
#'   metadata of the R Markdown document (if \code{FALSE}, you should write the
#'   title slide by yourself).
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
#'   to \code{remark.create()}, e.g. \code{list(ratio = '16:9', navigation =
#'   list(click = TRUE))}; see
#'   \url{https://github.com/gnab/remark/wiki/Configuration}. Besides the
#'   options provided by remark.js, you can also set \code{autoplay} to a number
#'   (the number of milliseconds) so the slides will be played every
#'   \code{autoplay} seconds.
#' @param ... For \code{tsukuyomi()}, arguments passed to \code{moon_reader()};
#'   for \code{moon_reader()}, arguments passed to
#'   \code{rmarkdown::\link{html_document}()}.
#' @note Do not stare at Karl's picture for too long after you turn on the
#'   \code{yolo} mode. I believe he has Sharingan.
#'
#'   Local images that you inserted via the Markdown syntax
#'   \command{![](path/to/image)} will not be embedded into the HTML file when
#'   \code{self_contained = TRUE} (only CSS, JavaScript, and R plot files will
#'   be embedded). You may also download remark.js (via
#'   \code{\link{summon_remark}()}) and use a local copy instead of the default
#'   \code{chakra} argument when \code{self_contained = TRUE}, because it may be
#'   time-consuming for Pandoc to download remark.js each time you compile your
#'   slides.
#' @references \url{http://naruto.wikia.com/wiki/Tsukuyomi}
#' @importFrom htmltools tagList tags htmlEscape HTML
#' @export
moon_reader = function(
  css = 'default', self_contained = FALSE, seal = TRUE, yolo = FALSE,
  chakra = 'https://remarkjs.com/downloads/remark-latest.min.js', nature = list(),
  ...
) {
  deps = if ('default' %in% css) {
    css = setdiff(css, 'default')
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
    ), "if (window.HTMLWidgets) slideshow.on('showSlide', function (slide) {setTimeout(function() {window.dispatchEvent(new Event('resize'));}, 100)});",
    play_js), collapse = '\n')))
  )), tmp_js)

  html_document2 = function(..., includes = list()) {
    if (length(includes) == 0) includes = list()
    includes$before_body = c(includes$before_body, tmp_md)
    includes$after_body = c(tmp_js, includes$after_body)
    rmarkdown::html_document(..., includes = includes)
  }

  optk = list()
  hook_highlight = if (isTRUE(nature$highlightLines)) {
    # an ugly way to access the `source` hook of markdown output in knitr
    hook_source = local({
      ohooks = knitr::knit_hooks$get(); on.exit(knitr::knit_hooks$restore(ohooks))
      knitr::render_markdown()
      knitr::knit_hooks$get('source')
    })

    function(x, options) {
      res = hook_source(x, options)
      # replace {{code}} with *code so that this line can be highlighted
      gsub('(^|\n)([ \t]*)\\{\\{([^\n]+?)\\}\\}', '\\1\\2*\\3', res)
    }
  }

  rmarkdown::output_format(
    if (!is.null(hook_highlight)) {
      rmarkdown::knitr_options(knit_hooks = list(source = hook_highlight))
    },
    NULL, clean_supporting = self_contained,
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
    base_format = html_document2(
      css = css, self_contained = self_contained, theme = NULL, highlight = NULL,
      extra_dependencies = deps, template = pkg_resource('default.html'), ...
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
#' @note This function is not really tied to the output format
#'   \code{\link{moon_reader}()}. You can use it to serve any single-HTML-file R
#'   Markdown output.
#' @seealso \code{servr::\link{httw}}
#' @export
#' @rdname inf_mr
infinite_moon_reader = function(moon) {
  # when this function is called via the RStudio addin, use the dir of the
  # current active document
  if (missing(moon) && requireNamespace('rstudioapi', quietly = TRUE)) {
    context_fun = tryCatch(
      getFromNamespace('getSourceEditorContext', 'rstudioapi'),
      error = function(e) rstudioapi::getActiveDocumentContext
    )
    moon = context_fun()[['path']]
    if (is.null(moon)) stop('Cannot find the current active document in RStudio')
    if (moon == '') stop(
      'Please click the RStudio source editor first, or save the current document'
    )
    if (!grepl('[.]R?md', moon, ignore.case = TRUE)) stop(
      'The current active document must be an R Markdown document. I saw "',
      basename(moon), '".'
    )
  }
  moon = normalizePath(moon, mustWork = TRUE)
  rebuild = function(...) {
    if (moon %in% normalizePath(c(...))) rmarkdown::render(
      moon, envir = globalenv()
    )
  }
  html = rebuild(moon)  # render slides initially
  servr::httw(dirname(moon), initpath = basename(html), handler = rebuild)
}

#' @export
#' @rdname inf_mr
inf_mr = infinite_moon_reader

#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides.
#' \code{tsukuyomi()} is an alias of \code{moon_reader()}.
#'
#' Tsukuyomi is a genjutsu to trap the target in an illusion on eye contact.
#'
#' If you are unfamiliar with CSS, please see the
#' \href{https://github.com/yihui/xaringan/wiki}{xaringan wiki on Github}
#' providing CSS slide modification examples.
#' @param css A vector of CSS file paths. Two default CSS files
#'   (\file{default.css} and \file{default-fonts.css}) are provided in this
#'   package, which was borrowed from \url{https://remarkjs.com}. If the
#'   character vector \code{css} contains a value that does not end with
#'   \code{.css}, it is supposed to be a built-in CSS file in this package,
#'   e.g., for \code{css = c('default', 'extra.css')}), it means
#'   \code{default.css} in this package and a user-provided \code{extra.css}. To
#'   find out all built-in CSS files, use \code{xaringan:::list_css()}.
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
#'   \code{autoplay} milliseconds. You can also set \code{countdown} to a number
#'   (the number of milliseconds) to include a countdown timer on each slide. If
#'   using \code{autoplay}, you can optionally set \code{countdown} to
#'   \code{TRUE} to include a countdown equal to \code{autoplay}. To alter the
#'   set of classes applied to the title slide, you can optionally set
#'   \code{titleSlideClass} to a vector of classes; the default is
#'   \code{c("center", "middle", "inverse")}.
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
#'
#'   Each page has its own countdown timer (when the option \code{countdown} is
#'   set in \code{nature}), and the timer is (re)initialized whenever you
#'   navigate to a new page. If you need a global timer, you can use the
#'   presenter's mode (press \kbd{P}).
#' @references \url{http://naruto.wikia.com/wiki/Tsukuyomi}
#' @importFrom htmltools tagList tags htmlEscape HTML
#' @export
#' @examples
#' # rmarkdown::render('foo.Rmd', 'xaringan::moon_reader')
moon_reader = function(
  css = c('default', 'default-fonts'), self_contained = FALSE, seal = TRUE, yolo = FALSE,
  chakra = 'https://remarkjs.com/downloads/remark-latest.min.js', nature = list(),
  ...
) {
  theme = grep('[.]css$', css, value = TRUE, invert = TRUE)
  deps = if (length(theme)) {
    css = setdiff(css, theme)
    check_builtin_css(theme)
    list(css_deps(theme))
  }
  tmp_js = tempfile('xaringan', fileext = '.js')  # write JS config to this file
  tmp_md = tempfile('xaringan', fileext = '.md')  # store md content here (bypass Pandoc)

  play_js = if (is.numeric(autoplay <- nature[['autoplay']]) && autoplay > 0)
    sprintf('setInterval(function() {slideshow.gotoNextSlide();}, %d);', autoplay)

  if (isTRUE(countdown <- nature[['countdown']])) countdown = autoplay
  countdown_js = if (is.numeric(countdown) && countdown > 0) sprintf(
    '(%s)(%d);', pkg_file('js/countdown.js'), countdown
  )

  if (is.null(title_cls <- nature[['titleSlideClass']]))
    title_cls = c('center', 'middle', 'inverse')
  title_cls = paste(c(title_cls, 'title-slide'), collapse = ", ")

  before = nature[['beforeInit']]
  for (i in c('countdown', 'autoplay', 'beforeInit', "titleSlideClass")) nature[[i]] = NULL

  write_utf8(as.character(tagList(
    tags$script(src = chakra),
    if (is.character(before)) if (self_contained) {
      tags$script(HTML(file_content(before)))
    } else {
      lapply(before, function(s) tags$script(src = s))
    },
    tags$script(HTML(paste(c(sprintf(
      'var slideshow = remark.create(%s);', if (length(nature)) xfun::tojson(nature) else ''
    ), pkg_file('js/show-widgets.js'), pkg_file('js/print-css.js'),
    play_js, countdown_js), collapse = '\n')))
  )), tmp_js)

  html_document2 = function(
    ..., includes = list(), mathjax = 'default', pandoc_args = NULL
  ) {
    if (length(includes) == 0) includes = list()
    includes$before_body = c(includes$before_body, tmp_md)
    includes$after_body = c(tmp_js, includes$after_body)
    if (identical(mathjax, 'local'))
      stop("mathjax = 'local' does not work for moon_reader()")
    if (!is.null(mathjax)) {
      if (identical(mathjax, 'default')) {
        mathjax = 'https://cdn.bootcss.com/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML'
      }
      pandoc_args = c(pandoc_args, '-V', paste0('mathjax-url=', mathjax))
      mathjax = NULL
    }
    pandoc_args = c(pandoc_args, '-V', paste0('title-slide-class=', title_cls))
    rmarkdown::html_document(
      ..., includes = includes, mathjax = mathjax, pandoc_args = pandoc_args
    )
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
      highlight_code(res)
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
      write_utf8(res$yaml, input_file)
      res$body = protect_math(res$body)
      content = htmlEscape(yolofy(res$body, yolo))
      Encoding(content) = 'UTF-8'
      write_utf8(content, tmp_md)
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
#' Tsukuyomi. The genjutsu is cast from the directory specified by
#' \code{cast_from}, and the Rinne Sharingan will be reflected off of the
#' \code{moon}.
#' @param moon The input Rmd file path (if missing and in RStudio, the current
#'   active document is used).
#' @param cast_from The root directory of the server.
#' @references \url{http://naruto.wikia.com/wiki/Infinite_Tsukuyomi}
#' @note This function is not really tied to the output format
#'   \code{\link{moon_reader}()}. You can use it to serve any single-HTML-file R
#'   Markdown output.
#' @seealso \code{servr::\link{httw}}
#' @export
#' @rdname inf_mr
infinite_moon_reader = function(moon, cast_from = '.') {
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
  moon = normalize_path(moon)
  rebuild = function() {
    rmarkdown::render(moon, envir = globalenv(), encoding = 'UTF-8')
  }
  build = local({
    mtime = function() file.info(moon)[, 'mtime']
    time1 = mtime()
    function(...) {
      time2 = mtime()
      if (identical(time1, time2)) return(FALSE)
      # moon has been changed, recompile it and reload in browser
      rebuild()
      time1 <<- time2
      TRUE
    }
  })
  html = normalize_path(rebuild())  # render slides initially
  d = normalize_path(cast_from)
  f = rmarkdown::relative_to(d, html)
  # see if the html output file is under the dir cast_from
  if (f == html) {
    d = dirname(html)
    f = basename(html)
    warning(
      "Cannot use '", cast_from, "' as the root directory of the server because ",
      "the HTML output is not under this directory. Using '", d, "' instead."
    )
  }
  servr:::dynamic_site(d, initpath = f, build = build)
}

#' @export
#' @rdname inf_mr
inf_mr = infinite_moon_reader

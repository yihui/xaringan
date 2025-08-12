#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides. `tsukuyomi()`
#' is an alias of `moon_reader()`.
#'
#' Tsukuyomi is a genjutsu to trap the target in an illusion on eye contact.
#'
#' If you are unfamiliar with CSS, please see the [xaringan wiki on
#' Github](https://github.com/yihui/xaringan/wiki) providing CSS slide
#' modification examples.
#' @param css A vector of CSS file paths. Two default CSS files
#'   (\file{default.css} and \file{default-fonts.css}) are provided in this
#'   package, which was borrowed from <https://remarkjs.com>. If the character
#'   vector `css` contains a value that does not end with `.css`, it is supposed
#'   to be a built-in CSS file in this package, e.g., for `css = c('default',
#'   'extra.css')`), it means `default.css` in this package and a user-provided
#'   `extra.css`. To find out all built-in CSS files, use
#'   `xaringan:::list_css()`. With \pkg{rmarkdown} >= 2.8, Sass files (filenames
#'   ending with \file{.scss} or \file{.sass}) can also be used, and they will
#'   be processed by the \pkg{sass} package, which needs to be installed.
#' @param self_contained Whether to produce a self-contained HTML file by
#'   embedding all external resources into the HTML file. See the \sQuote{Note}
#'   section below.
#' @param seal Whether to generate a title slide automatically using the YAML
#'   metadata of the R Markdown document (if `FALSE`, you should write the title
#'   slide by yourself).
#' @param yolo Whether to insert the [Mustache Karl
#'   (TM)](https://kbroman.wordpress.com/2014/08/28/the-mustache-photo/)
#'   randomly in the slides. `TRUE` means insert his picture on one slide, and
#'   if you want him to be on multiple slides, set `yolo` to a positive integer
#'   or a percentage (e.g. 0.3 means 30\% of your slides will be the Mustache
#'   Karl). Alternatively, `yolo` can also be a list of the form `list(times =
#'   n, img = path)`: `n` is the number of times to show an image, and `path` is
#'   the path to an image (by default, it is Karl).
#' @param chakra A path to the remark.js library (can be either local or
#'   remote). Please note that if you use the default remote latest version of
#'   remark.js, your slides will not work when you do not have Internet access.
#'   They might also be broken after a newer version of remark.js is released.
#'   If these issues concern you, you should download remark.js locally (e.g.,
#'   via [summon_remark()]), and use the local version instead.
#' @param nature (Nature transformation) A list of configurations to be passed
#'   to `remark.create()`, e.g. `list(ratio = '16:9', navigation = list(click =
#'   TRUE))`; see <https://github.com/gnab/remark/wiki/Configuration>. Besides
#'   the options provided by remark.js, you can also set `autoplay` to a number
#'   (the number of milliseconds) so the slides will be played every `autoplay`
#'   milliseconds; alternatively, `autoplay` can be a list of the form
#'   `list(interval = N, loop = TRUE)`, so the slides will go to the next page
#'   every `N` milliseconds, and optionally go back to the first page to restart
#'   the play when `loop = TRUE`. You can also set `countdown` to a number (the
#'   number of milliseconds) to include a countdown timer on each slide. If
#'   using `autoplay`, you can optionally set `countdown` to `TRUE` to include a
#'   countdown equal to `autoplay`. To alter the set of classes applied to the
#'   title slide, you can optionally set `titleSlideClass` to a vector of
#'   classes; the default is `c("center", "middle", "inverse")`.
#' @param anchor_sections,... For `tsukuyomi()`, arguments passed to
#'   `moon_reader()`; for `moon_reader()`, arguments passed to
#'   [rmarkdown::html_document()].
#' @note Do not stare at Karl's picture for too long after you turn on the
#'   `yolo` mode. I believe he has Sharingan.
#'
#'   For the option `self_contained = TRUE`, it encodes images as base64 data in
#'   the HTML output file. The image path should not contain the string `")"`
#'   when the image is written with the syntax `![](PATH)` or `background-image:
#'   url(PATH)`, and should not contain the string `"/>"` when it is written
#'   with the syntax `<img src="PATH" />`. Rendering slides in the
#'   self-contained mode can be time-consuming when you have remote resources
#'   (such as images or JS libraries) in your slides because these resources
#'   need to be downloaded first. We strongly recommend that you download
#'   remark.js (via [summon_remark()]) and use a local copy instead of the
#'   default `chakra` argument when `self_contained = TRUE`, so remark.js does
#'   not need to be downloaded each time you compile your slides.
#'
#'   When the slides are previewed via [xaringan::inf_mr()], `self_contained`
#'   will be temporarily changed to `FALSE` even if the author of the slides set
#'   it to `TRUE`. This will make it faster to preview slides locally (by
#'   avoiding downloading remote resources explicitly and base64 encoding them).
#'   You can always click the Knit button in RStudio or call
#'   `rmarkdown::render()` to render the slides in the self-contained mode
#'   (these approaches will respect the `self_contained` setting).
#'
#'   Each page has its own countdown timer (when the option `countdown` is set
#'   in `nature`), and the timer is (re)initialized whenever you navigate to a
#'   new page. If you need a global timer, you can use the presenter's mode
#'   (press \kbd{P}).
#' @references <https://naruto.fandom.com/wiki/Tsukuyomi>
#' @importFrom htmltools tagList tags htmlEscape HTML
#' @export
#' @examples
#' # rmarkdown::render('foo.Rmd', 'xaringan::moon_reader')
moon_reader = function(
  css = c('default', 'default-fonts'), self_contained = FALSE, seal = TRUE, yolo = FALSE,
  chakra = 'https://remarkjs.com/downloads/remark-latest.min.js', nature = list(),
  anchor_sections = FALSE, ...
) {
  theme = grep('[.](?:sa|sc|c)ss$', css, value = TRUE, invert = TRUE)
  deps = if (length(theme)) {
    css = setdiff(css, theme)
    check_builtin_css(theme)
    list(css_deps(theme))
  }
  tmp_js = tempfile('xaringan', fileext = '.js')  # write JS config to this file
  tmp_md = tempfile('xaringan', fileext = '.md')  # store md content here (bypass Pandoc)
  options(xaringan.page_number.offset = if (seal) 0L else -1L)
  if (self_contained && isTRUE(getOption('xaringan.inf_mr.running'))) {
    if (interactive()) xfun::do_once({
      message(
        'You are currently using xaringan::inf_mr() to preview your slides, and ',
        'you have turned on the self_contained option in xaringan::moon_reader. ',
        'To make it faster for you to preview slides, I have temporarily turned ',
        'this option off. If you need self-contained slides at the end, you may ',
        'click the Knit button in RStudio, or call rmarkdown::render() to render ',
        'this document.'
      )
      readline('Press Enter to continue...')
    }, 'xaringan.self_contained.message')
    self_contained = FALSE
  }

  if (is.numeric(autoplay <- nature[['autoplay']])) {
    autoplay = list(interval = autoplay, loop = FALSE)
  }
  play_js = if (is.numeric(intv <- autoplay$interval) && intv > 0) sprintf(
    'setInterval(function() {slideshow.gotoNextSlide();%s}, %d);',
    if (!isTRUE(autoplay$loop)) '' else
      ' if (slideshow.getCurrentSlideIndex() == slideshow.getSlideCount() - 1) slideshow.gotoFirstSlide();',
    intv
  )

  if (isTRUE(countdown <- nature[['countdown']])) countdown = autoplay
  countdown_js = if (is.numeric(countdown) && countdown > 0) sprintf(
    '(%s)(%d);', pkg_file('js/countdown.js'), countdown
  )

  hl_pre_js = if (isTRUE(nature$highlightLines))
    pkg_file('js/highlight-pre-parent.js')

  if (is.null(title_cls <- nature[['titleSlideClass']]))
    title_cls = c('center', 'middle', 'inverse')
  title_cls = paste(c(title_cls, 'title-slide'), collapse = ', ')

  before = nature[['beforeInit']]
  for (i in c('countdown', 'autoplay', 'beforeInit', 'titleSlideClass')) nature[[i]] = NULL

  write_utf8(as.character(tagList(
    tags$style(`data-target` = 'print-only', '@media screen {.remark-slide-container{display:block;}.remark-slide-scaler{box-shadow:none;}}'),
    tags$script(src = chakra),
    if (is.character(before)) if (self_contained) {
      tags$script(HTML(file_content(before)))
    } else {
      lapply(before, function(s) tags$script(src = s))
    },
    tags$script(HTML(paste(c(sprintf(
      'var slideshow = remark.create(%s);', if (length(nature)) xfun::tojson(nature) else ''
    ), pkg_file(sprintf('js/%s.js', c(
      'show-widgets', 'print-css', 'after', 'script-tags', 'target-blank'
    ))),
    play_js, countdown_js, hl_pre_js), collapse = '\n')))
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
        mathjax = 'https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-MML-AM_CHTML'
      }
      pandoc_args = c(pandoc_args, '-V', paste0('mathjax-url=', mathjax))
      mathjax = NULL
    }
    pandoc_args = c(pandoc_args, '-V', paste0('title-slide-class=', title_cls))
    # avoid automatic wrapping: https://github.com/yihui/xaringan/issues/345
    if (!length(grep('--wrap', pandoc_args)))
      pandoc_args = c('--wrap', 'preserve', pandoc_args)
    rmarkdown::html_document(
      ..., includes = includes, mathjax = mathjax, pandoc_args = pandoc_args
    )
  }

  highlight_hooks = NULL
  if (isTRUE(nature$highlightLines)) {
    hooks = knitr::hooks_markdown()[c('source', 'output')]
    highlight_hooks = list(
      source = function(x, options) {
        hook = hooks[['source']]
        res = hook(x, options)
        highlight_code(res)
      },
      output = function(x, options) {
        hook = hooks[['output']]
        res = highlight_output(x, options)
        hook(res, options)
      }
    )
  }

  opts = list()

  rmarkdown::output_format(
    rmarkdown::knitr_options(knit_hooks = highlight_hooks),
    NULL, clean_supporting = self_contained,
    pre_knit = function(input, ...) {
      opts <<- options(
        htmltools.preserve.raw = FALSE,  # don't use Pandoc raw blocks ```{=} (#293)
        knitr.sql.html_div = FALSE  # do not add <div> to knitr's sql output (#307)
      )
    },
    pre_processor = function(
      metadata, input_file, runtime, knit_meta, files_dir, output_dir
    ) {
      res = split_yaml_body(input_file)
      write_utf8(res$yaml, input_file)
      res$body = protect_math(res$body)
      if (self_contained) {
        clean_env_images()
        res$body = encode_images(res$body)
        cat(sprintf(
          "<script>(%s)(%s, '%s');</script>", pkg_file('js/data-uri.js'),
          xfun::tojson(as.list(env_images, all.names = TRUE)), url_token
        ), file = tmp_js, append = TRUE)
      }
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
      options(opts)
    },
    base_format = html_document2(
      css = css, self_contained = self_contained, theme = NULL, highlight = NULL,
      extra_dependencies = deps, template = pkg_resource('default.html'),
      anchor_sections = anchor_sections, ...
    )
  )
}

#' @export
#' @rdname moon_reader
tsukuyomi = function(...) moon_reader(...)

#' Serve and live reload slides
#'
#' Use the \pkg{servr} package to serve and reload slides on change.
#' `inf_mr()` and `mugen_tsukuyomi()` are aliases of
#' `infinite_moon_reader()`.
#'
#' The Rmd document is compiled continuously to trap the world in the Infinite
#' Tsukuyomi. The genjutsu is cast from the directory specified by
#' `cast_from`, and the Rinne Sharingan will be reflected off of the
#' `moon`. Use `servr::daemon_stop()` to perform a genjutsu Kai and
#' break the spell.
#' @param moon The input Rmd file path (if missing and in RStudio, the current
#'   active document is used).
#' @param cast_from The root directory of the server.
#' @param ... Passed to [rmarkdown::render()].
#' @references <https://naruto.fandom.com/wiki/Infinite_Tsukuyomi>
#' @note This function is not really tied to the output format
#'   [moon_reader()]. You can use it to serve any single-HTML-file R
#'   Markdown output.
#' @seealso [servr::httw()]
#' @export
#' @rdname inf_mr
infinite_moon_reader = function(moon, cast_from = '.', ...) {
  # when this function is called via the RStudio addin, use the dir of the
  # current active document
  if (missing(moon) && requireNamespace('rstudioapi', quietly = TRUE)) {
    moon = rstudioapi::getSourceEditorContext()[['path']]
    if (is.null(moon)) stop('Cannot find an open document in the RStudio editor')
    if (moon == '') stop('Please save the current document')
    if (!grepl('[.]R?md$', moon, ignore.case = TRUE)) stop(
      'The current active document must be an R Markdown document. I saw "',
      basename(moon), '".'
    )
  }
  moon = normalize_path(moon)
  dots = list(...)
  dots$envir = parent.frame()
  dots$input = moon
  rebuild = function() {
    # set an option so we know that the inf moon reader is running
    opts = options(xaringan.inf_mr.running = TRUE)
    on.exit(options(opts), add = TRUE)
    do.call(rmarkdown::render, dots)
  }
  html = NULL
  # rebuild if moon or any dependencies (CSS/JS/images) have been updated
  build = local({
    # if Rmd is inside a package, listen to changes under the inst/ dir,
    # otherwise watch files under the dir of the moon
    d = if (p <- is_package()) 'inst' else dirname(moon)
    files = if (getOption('xaringan.inf_mr.aggressive', TRUE)) function() {
      list.files(
        d, '[.](css|js|png|gif|jpeg|Rmd)$', full.names = TRUE, recursive = TRUE
      )
    } else function() moon
    mtime = function() {
      fs = files()
      setNames(file.info(fs)[, 'mtime'], fs)
    }
    html <<- normalize_path(rebuild())  # render Rmd initially
    l = max(m <- mtime())  # record the latest timestamp of files
    r = servr:::is_rstudio(); info = if (r) slide_context()
    function(message) {
      m2 = mtime(); u = !any(m2 > l)
      # when running inside RStudio and only Rmd is possibly changed
      if (u) {
        if (!r || missing(message)) return(FALSE)
        ctx = rstudioapi::getSourceEditorContext()
        if (identical(normalize_path(as.character(ctx[['path']])), moon)) {
          if (is.character(message)) message = jsonlite::fromJSON(message)
          if (isTRUE(message[['focused']])) {
            # auto-navigate to the slide source corresponding to current HTML
            # page only when the slides are on focus
            slide_navigate(ctx, message)
          } else {
            # navigate to HTML page and update it incrementally if necessary
            info2 = slide_context(ctx)
            # incremental update only if the total number of pages (N) matches
            if (!is.null(info2) && identical(message$N, info2$N)) {
              on.exit(info <<- info2, add = TRUE)
              return(list(page = info2$n, markdown = if (
                identical(info$c, info2$c) || is.null(info2$c) || !identical(info$n, info2$n)
              ) FALSE else process_slide(info2$c)))
            }
          }
        }
        return(FALSE)
      }
      # is any Rmd updated?
      u2 = !u && any(m2[grep('[.]Rmd$', names(m2))] > l)
      l <<- max(m2)
      # moon or dependencies have been updated, recompile and reload in browser
      if (p || u2) {
        rebuild(); if (r) info <<- slide_context()
      }
      l <<- max(m <<- mtime())
      TRUE
    }
  })
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
  servr:::dynamic_site(
    d, initpath = f, build = build, ws_handler = pkg_resource('js', 'ws-handler.js')
  )
}

#' @export
#' @rdname inf_mr
inf_mr = infinite_moon_reader

#' @export
#' @rdname inf_mr
mugen_tsukuyomi = infinite_moon_reader


#' Convert HTML presentations to PDF via DeckTape
#'
#' This function can use either the \command{decktape} command or the hosted
#' docker image of the \pkg{decktape} library to convert HTML slides to PDF
#' (including slides produced by \pkg{xaringan}).
#' @param file The path to the HTML presentation file. When `docker = FALSE`,
#'   this path could be a URL to online slides.
#' @param output The desired output path of the PDF file.
#' @param args Command-line arguments to be passed to `decktape`.
#' @param docker Whether to use Docker (`TRUE`) or use the \command{decktape}
#'   command directly (`FALSE`). By default, if \pkg{decktape} has been
#'   installed in your system and can be found via `Sys.which('decktape')`, it
#'   will be uesd directly.
#' @param version The \pkg{decktape} version when you use Docker.
#' @param open Whether to open the resulting PDF with your system PDF viewer.
#' @note For some operating systems you may need to
#'   \href{https://stackoverflow.com/questions/48957195}{add yourself to the
#'   \command{docker} group} and restart your machine if you use DeckTape via
#'   Docker. By default, the latest version of the \pkg{decktape} Docker image
#'   is used. In case of errors, you may want to try older versions (e.g.,
#'   `version = '2.8.0'`).
#' @references DeckTape: <https://github.com/astefanutti/decktape>. Docker:
#'   <https://www.docker.com>.
#' @return The output file path (invisibly).
#' @export
#' @examplesIf interactive()
#' xaringan::decktape('https://slides.yihui.org/xaringan', 'xaringan.pdf', docker = FALSE)
decktape = function(
  file, output, args = '--chrome-arg=--allow-file-access-from-files',
  docker = Sys.which('decktape') == '', version = '', open = FALSE
) {
  args = shQuote(c(args, file, output))
  res = if (docker) system2('docker', c(
    'run', '--rm', '-t', '-v', '`pwd`:/slides', '-v', '$HOME:$HOME',
    paste0('astefanutti/decktape', if (version != '') ':', version), args
  )) else system2('decktape', args)
  if (res != 0) stop('Failed to convert ', file, ' to PDF')
  if (open) open_file(output)
  invisible(output)
}

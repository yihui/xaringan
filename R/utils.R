#' @import utils
#' @import stats
#' @importFrom xfun read_utf8 write_utf8 normalize_path prose_index protect_math

pkg_resource = function(...) system.file(
  'rmarkdown', 'templates', 'xaringan', 'resources', ..., package = 'xaringan',
  mustWork = TRUE
)

css_deps = function(theme) {
  htmltools::htmlDependency(
    'remark-css', '0.0.1', pkg_resource(), stylesheet = paste0(theme, '.css'),
    all_files = FALSE
  )
}

list_css = function() {
  css = list.files(pkg_resource(), '[.]css$', full.names = TRUE)
  setNames(css, gsub('.css$', '', basename(css)))
}

check_builtin_css = function(theme) {
  valid = names(list_css())
  if (length(invalid <- setdiff(theme, valid)) == 0) return()
  invalid = invalid[1]
  maybe = sort(agrep(invalid, valid, value = TRUE))[1]
  hint = if (is.na(maybe)) '' else paste0('; did you mean "', maybe, '"?')
  stop(
    '"', invalid, '" is not a valid xaringan theme', if (hint != "") hint else ".",
    " Use `xaringan:::list_css()` to view all built-in themes.", call. = FALSE
  )
}

split_yaml_body = function(file) {
  x = readLines(file, encoding = 'UTF-8')
  i = grep('^---\\s*$', x)
  n = length(x)
  if (length(i) < 2) {
    list(yaml = character(), body = x)
  } else {
    list(yaml = x[i[1]:i[2]], body = if (i[2] == n) character() else x[(i[2] + 1):n])
  }
}

karl = 'https://github.com/yihui/xaringan/releases/download/v0.0.2/karl-moustache.jpg'

yolo = function(img = karl, ...) {
  knitr::include_graphics(img, ...)
}

yolofy = function(x, config) {
  if (!is.list(config)) config = list(times = config, img = karl)
  n = as.numeric(config$times); img = config$img
  if (!is.character(img)) img = karl
  if (n <= 0) return(x)
  i = grep('^---$', x)
  b = sprintf('background-image: url(%s)', img)
  if (length(i) == 0) return(c(x, '---', b))
  if (n < 1) n = ceiling(n * length(i))
  n = min(n, length(i))
  j = sample2(i, n)
  # randomly add Karl above or below a slide
  x[j] = paste(c('---', b, '---'), collapse = '\n')
  x
}

# sample() without surprise
sample2 = function(x, size, ...) {
  if (length(x) == 1) {
    rep(x, size)  # should consider replace = FALSE in theory
  } else sample(x, size, ...)
}

#' Summon remark.js to your local disk
#'
#' Download a version of the remark.js script to your local disk, so you can
#' render slides offline. You need to change the \code{chakra} argument of
#' \code{\link{moon_reader}()} after downloading remark.js.
#' @param version The version of remark.js (e.g. \code{latest}, \code{0.13}, or
#'   \code{0.14.1}).
#' @param to The destination directory.
#' @export
summon_remark = function(version = 'latest', to = 'libs/') {
  name = sprintf('remark-%s.min.js', version)
  if (!utils::file_test('-d', to)) dir.create(to, recursive = TRUE)
  download.file(
    paste0('https://remarkjs.com/downloads/', name),
    file.path(to, name)
  )
}

# replace {{code}} with *code so that this line can be highlighted in remark.js;
# this also works with multiple lines
highlight_code = function(x) {
  x = paste0('\n', x)  # prepend \n and remove it later
  r = '(\n)([ \t]*)\\{\\{(.+?)\\}\\}(?=(\n|$))'
  m = gregexpr(r, x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    z = gsub(r, '\\1\\2\\3', z, perl = TRUE)  # remove {{ and }}
    z = gsub('\n', '\n*', z)     # add * after every \n
    z
  })
  x = gsub('^\n', '', x)
  # adds support for `#<<` line highlight marker at line end in code segments
  # catch `#<<` at end of the line but ignores lines that start with `*` since
  # they came from above
  x = gsub('^\\s?([^*].+?)\\s*#<<\\s*$', '*\\1', split_lines(x))
  paste(x, collapse = '\n')
}

highlight_output = function(x, options) {
  if (is.null(i <- options$highlight.output) || xfun::isFALSE(i)) return(x)
  x = split_lines(x)
  x[i] = paste0('*', x[i])
  paste(x, collapse = '\n')
}

# make sure blank lines and trailing \n are not removed by strsplit()
split_lines = function(x) {
  unlist(strsplit(paste0(x, '\n'), '\n'))
}

file_content = function(file) {
  paste(unlist(lapply(file, read_utf8)), collapse = '\n')
}

pkg_file = function(file) file_content(pkg_resource(file))

open_file = function(path){
  if (xfun::is_windows()) {
    shell.exec(path)
  } else {
    system2(if (xfun::is_macos()) 'open' else 'xdg-open', shQuote(path))
  }
}

# does the current dir look like an R package dir?
is_package = function() {
  all(c(file.exists(c('DESCRIPTION', 'NAMESPACE')), dir.exists(c('R', 'inst'))))
}

# obtain the context of Rmd for xaringan slides
slide_context = function(ctx = rstudioapi::getSourceEditorContext()) {
  x = ctx$contents
  if (length(x) < 3 || length(s <- which(x == '---')) < 2 || s[1] != 1) return()
  if (length(grep(' xaringan::.+', x[1:s[2]])) == 0) return()
  l = ctx$selection[[1]]$range$end[1]  # line number of cursor
  i = prose_index(x, warn = FALSE); x2 = x; if (length(i)) x2[-i] = ''
  s = grep('^---?$', x2)  # line numbers of slide separators; first two are YAML

  # remove hidden slides from the source
  k = unlist(lapply(grep(reg_hidden, x2), function(i) {
    i1 = tail(s[s < i], 1); if (length(i1) == 0) i1 = 1
    i2 = head(s[s > i], 1); if (length(i2) == 0) i2 = length(x)
    (i1 + 1):i2
  }))
  if (length(k)) {
    x[k] = ''; x2[k] = ''; s = grep('^---?$', x2)
  }

  i = which(x2 == '---')
  n = max(sum(s <= l), 1)
  i1 = tail(i[i <= l], 1); if (length(i1) == 0) i1 = 1
  i2 = s[n + 1]; if (is.na(i2)) i2 = length(x)
  txt = x[i1:i2]; i = grep('^---?$', txt)
  if (length(i)) txt = txt[-i]
  o = getOption('xaringan.page_number.offset', 0L)
  # total # of pages; current page #; Markdown content of current page
  list(
    N = as.integer(length(s) + o), n = n + o, c = if (i1 > 1) txt
  )
}

reg_hidden = '^(layout|exclude): true\\s*$'

slide_navigate = function(ctx = rstudioapi::getSourceEditorContext(), message) {
  if (!is.list(message) || !is.numeric(p <- message$n)) return()
  sel = ctx$selection[[1]]
  if (sel$text != '') return()  # when user has selected some text, don't navigate
  l = sel$range$end[1]; x = ctx$contents
  i = prose_index(x, warn = FALSE); x2 = x; if (length(i)) x2[-i] = ''
  s = grep('^---?$', x2); o = getOption('xaringan.page_number.offset', 0L)
  k = unlist(lapply(grep(reg_hidden, x2), function(i) sum(s < i)))
  k = unique(k[k > 0])
  if (length(k)) s = s[-k]
  if (length(s) + o != message$N) return()
  n = max(sum(s <= l), 1); p = p - o
  # don't move cursor if already on the current page
  if (n != p && p <= length(s))
    rstudioapi::setCursorPosition(rstudioapi::document_position(s[p] + 1, 1))
}

flatten_chunk = function(x) {
  if (length(i <- grep(knitr::all_patterns$md$chunk.begin, x)) == 0) return(x)
  k = grepl('\\W(echo|include)\\s*=\\s*FALSE\\W', x[i])
  x[i][!k] = gsub('\\{.+', '', x[i][!k])
  x[i][k]  = gsub('\\{.+', '.hidden', x[i][k])
  x
}

process_slide = function(x) {
  x = protect_math(flatten_chunk(x))
  paste(x, collapse = '\n')
}

# store the base64 data of images (indexed by image paths)
env_images = new.env(parent = emptyenv())
clean_env_images = function() {
  rm(list = ls(env_images, all.names = TRUE), envir = env_images)
}
url_token = 'data:image/png;base64,#'

# find images in Markdown, encode them in base64, and store the data in JSON
# (the data will be used when post-processing remark.js slides in browser)
encode_images = function(x) {
  # only process prose lines and not code blocks
  if (length(p <- prose_index(x)) == 0) return(x)
  xp = x[p]
  # opening and closing tags of images
  r1 = c('!\\[.*?\\]\\(', '<img .*?src\\s*=\\s*"', '^background-image: url\\("?')
  r2 = c('\\)',           '".*?/>',                '"?\\)')
  regs = paste0('(?<!`)(', r1, ')(.*?)(', r2, ')(?!`)')
  for (r in regs) xp = encode_reg(r, xp)
  x[p] = xp
  x
}

# given a regex for images, base64 encode these images
encode_reg = function(r, x) {
  m = gregexpr(r, x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(imgs) {
    if ((n <- length(imgs)) == 0) return(imgs)
    x1 = gsub(r, '\\1', imgs, perl = TRUE)
    x2 = gsub(r, '\\2', imgs, perl = TRUE)
    x3 = gsub(r, '\\3', imgs, perl = TRUE)
    for (i in seq_len(n)) {
      f = x2[i]
      if (f == '') next  # src shouldn't be empty
      # don't re-encode if the file has been encoded previously
      if (!(ok <- !is.null(env_images[[f]]))) {
        b = encode_file(f)
        if (b == f) next
        env_images[[f]] = b
        ok = TRUE
      }
      # dirty hack: hide paths after a base64 string and we'll replace it
      # will the actual base64 data after the slides are rendered in browser
      if (ok) x2[i] = paste0(url_token, f)
    }
    paste0(x1, x2, x3)
  })
  x
}

encode_file = function(x) {
  if (grepl('^data:[^/]+/[^;]+;base64,', x)) return(x)  # already encoded
  tf = x
  if (grepl('^https?://.+', x)) {
    tf = tempfile(fileext = xfun::url_filename(x))
    xfun::download_file(x, tf, mode = 'wb', quiet = TRUE)
    on.exit(unlink(tf), add = TRUE)
  }
  if (!file.exists(tf)) {
    warning('Failed to encode the file ', x)
    return(x)
  }
  xfun::base64_uri(tf)
}

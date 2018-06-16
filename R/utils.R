#' @import utils
#' @import stats
#' @importFrom xfun read_utf8 write_utf8 normalize_path

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

prose_index = function(x) xfun::prose_index(x)
protect_math = function(x) xfun::protect_math(x)

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
  r = '(\n)([ \t]*)\\{\\{(.+?)\\}\\}'
  m = gregexpr(r, x)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    z = gsub(r, '\\1\\2\\3', z)  # remove {{ and }}
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

# make sure blank lines and trailing \n are not removed by strsplit()
split_lines = function(x) {
  unlist(strsplit(paste0(x, '\n'), '\n'))
}

file_content = function(file) {
  paste(unlist(lapply(file, read_utf8)), collapse = '\n')
}

pkg_file = function(file) file_content(pkg_resource(file))

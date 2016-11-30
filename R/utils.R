#' @import utils

writeUTF8 = function(x, ...) writeLines(enc2utf8(x), ..., useBytes = TRUE)

pkg_resource = function(...) system.file(
  'rmarkdown', 'templates', 'xaringan', 'resources', ..., package = 'xaringan',
  mustWork = TRUE
)

example_css = function() htmltools::htmlDependency(
  'remark-css', '0.0.1', pkg_resource(), stylesheet = 'example.css', all_files = FALSE
)

# a simple JSON serializer
tojson = function(x) {
  if (is.null(x)) return('null')
  if (is.logical(x)) {
    if (length(x) != 1 || any(is.na(x)))
      stop('Logical values of length > 1 and NA are not supported')
    return(tolower(as.character(x)))
  }
  if (is.character(x) || is.numeric(x)) {
    return(json_vector(x, length(x) != 1 || inherits(x, 'AsIs'), is.character(x)))
  }
  if (is.list(x)) {
    if (length(x) == 0) return('{}')
    return(if (is.null(names(x))) {
      json_vector(unlist(lapply(x, tojson)), TRUE, quote = FALSE)
    } else {
      nms = paste0('"', names(x), '"')
      paste0('{\n', paste(nms, unlist(lapply(x, tojson)), sep = ': ', collapse = ',\n'), '\n}')
    })
  }
  stop('The class of x is not supported: ', paste(class(x), collapse = ', '))
}

json_vector = function(x, toArray = FALSE, quote = TRUE) {
  if (quote) {
    x = gsub('(["\\])', "\\\\\\1", x)
    x = gsub('[[:space:]]', " ", x)
    if (length(x)) x = paste0('"', x, '"')
  }
  if (toArray) paste0('[', paste(x, collapse = ', '), ']') else x
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

protect_math = function(x) {
  # replace $x$ with `\(x\)` (protect inline math in <code></code>)
  m = gregexpr('(?<![`$])[$](?! )[^$]+?(?<! )[$](?![$])', x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    if (length(z) == 0) return(z)
    z = sub('^[$]', '`\\\\(', z)
    z = sub('[$]$', '\\\\)`', z)
    z
  })
  # replace $$x$$ with `$$x$$` (protect display math)
  m = gregexpr('(?<!`)[$][$](?! )[^$]+?(?<! )[$][$]', x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    if (length(z) == 0) return(z)
    paste0('`', z, '`')
  })
  x
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

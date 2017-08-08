#' @import utils

writeUTF8 = function(x, ...) writeLines(enc2utf8(x), ..., useBytes = TRUE)

pkg_resource = function(...) system.file(
  'rmarkdown', 'templates', 'xaringan', 'resources', ..., package = 'xaringan',
  mustWork = TRUE
)

example_css = function() htmltools::htmlDependency(
  'remark-css', '0.0.1', pkg_resource(), stylesheet = 'example.css', all_files = FALSE
)

normalize_path = function(path) {
  normalizePath(path, winslash = '/', mustWork = TRUE)
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

# filter out the lines between ``` ```
prose_index = function(x) {
  idx = seq_along(x)
  fence = grep('^\\s*```', x)
  if (length(fence) %% 2 != 0) {
    # treat all lines as prose
    warning('Code fences are not balanced'); return(idx)
  }
  idx2 = matrix(fence, nrow = 2)
  idx2 = unlist(mapply(seq, idx2[1, ], idx2[2, ], SIMPLIFY = FALSE))
  setdiff(idx, idx2)
}

protect_math = function(x) {
  i = prose_index(x)
  if (length(i)) x[i] = escape_math(x[i])
  x
}

escape_math = function(x) {
  # replace $x$ with `\(x\)` (protect inline math in <code></code>)
  m = gregexpr('(?<=^|[\\s])[$](?! )[^$]+?(?<! )[$](?![$0123456789])', x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    if (length(z) == 0) return(z)
    z = sub('^[$]', '`\\\\(', z)
    z = sub('[$]$', '\\\\)`', z)
    z
  })
  # replace $$x$$ with `$$x$$` (protect display math)
  m = gregexpr('(?<=^|[\\s])[$][$](?! )[^$]+?(?<! )[$][$]', x, perl = TRUE)
  regmatches(x, m) = lapply(regmatches(x, m), function(z) {
    if (length(z) == 0) return(z)
    paste0('`', z, '`')
  })
  # if a line start or end with $$, treat it as math under some conditions
  i = !grepl('^[$].+[$]$', x)
  if (any(i)) {
    x[i] = gsub('^([$][$])([^ ]+)', '`\\1\\2', x[i], perl = TRUE)
    x[i] = gsub('([^ ])([$][$])$', '\\1\\2`', x[i], perl = TRUE)
  }
  # equation environments
  i = grep('^\\\\begin\\{[^}]+\\}$', x)
  x[i] = paste0('`', x[i])
  i = grep('^\\\\end\\{[^}]+\\}$', x)
  x[i] = paste0(x[i], '`')
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
  gsub('^\n', '', x)
}

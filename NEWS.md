# CHANGES IN xaringan VERSION 0.4

## NEW FEATURES

- The PDF printed from the slides in browser looks much nicer now (no extra margins) (thanks, @cboettig and @ekstroem, #65).

## BUG FIXES

- Line highlighting using `{{}}` does not work with multiple lines (thanks, @HeidiSeibold #53 and @aj2duncan #54).

- The option `mathjax: null` does not work for `moon_reader()`, i.e., it was not possible to exclude MathJax.

# CHANGES IN xaringan VERSION 0.3

## NEW FEATURES

- A new option `countdown` in the `nature` option of `moon_reader()` can be set so that a countdown timer is added to each page of slides. See `?xaringan::moon_reader` and https://slides.yihui.name/xaringan/ for more information (thanks, @slopp, #43).

# CHANGES IN xaringan VERSION 0.2

## NEW FEATURES

- A class `title-slide` was added to the automatically generated title slide (`moon_reader(seal = TRUE)`) so that you can customize the this slide using CSS (thanks, @ekstroem, #7).

- Added an argument `cast_from` to `infinite_moon_reader()` to specify the root directory of the server. Previously the root directory is the directory of the Rmd input file, which makes it impossible for the Rmd document to use resources in upper-level directories (e.g. `![](../gif/cute-kittens.gif)`). Now you can set the working directory to the upper-level directory and call `inf_mr('relative/path/to/input.Rmd')`, so that `input.Rmd` can use any files under the current working directory `./` (thanks, @pat-s, #29).

- Added a Wiki on Github thanks to @pat-s for those who are new to CSS: https://github.com/yihui/xaringan/wiki

## BUG FIXES

- A local copy of MathJax should work with `moon_reader()` (thanks, @bnicenboim, #13).

- Skip fenced code blocks when detecting LaTeX math expressions, e.g. `$api$` in R code `session$api$plot <- ...` should not be treated as a math expression (thanks, @jcheng5).

- Unicode characters can be rendered correctly on Windows now (thanks, @Lchiffon, #20).

# CHANGES IN xaringan VERSION 0.1

## NEW FEATURES

- Initial CRAN release. See the documentation at https://slides.yihui.name/xaringan/

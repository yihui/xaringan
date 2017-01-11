# CHANGES IN xaringan VERSION 0.2 (unreleased)

## NEW FEATURES

- A class `title-slide` was added to the automatically generated title slide (`moon_reader(seal = TRUE)`) so that you can customize the this slide using CSS (thanks, @ekstroem, #7).

## BUG FIXES

- A local copy of MathJax should work with `moon_reader()` (thanks, @bnicenboim, #13).

- Skip fenced code blocks when detecting LaTeX math expressions, e.g. `$api$` in R code `session$api$plot <- ...` should not be treated as a math expression (thanks, @jcheng5).

- Unicode characters can be rendered correctly on Windows now (thanks, @Lchiffon, #20).

# CHANGES IN xaringan VERSION 0.1

## NEW FEATURES

- Initial CRAN release. See the documentation at https://slides.yihui.name/xaringan/

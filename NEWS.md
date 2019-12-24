# CHANGES IN xaringan VERSION 0.14

## NEW FEATURES

- Added a theme following the Karolinska Institutet design guidelines (@ellessenne, #238).

- Added the argument `params` to `infinite_moon_reader()` (@paulklemm, #240).

## BUG FIXES

- Removed the `xmlns` attribute in the `<html>` tag in the default HTML template (thanks, @pat-s, #197).

# CHANGES IN xaringan VERSION 0.13

## NEW FEATURES

- In the `metropolis` theme, added support for automatic orange break lines under the subtitle in the title slide and in `inverse` slides using the new class `mline` (@Enchufa2, #231).

## BUG FIXES

- In the `metropolis` theme, fixed titles to look the same everywhere, and added support to gray out non-active h2 and h3 titles in a `.left-column` (@Enchufa2, #229).

# CHANGES IN xaringan VERSION 0.12

## NEW FEATURES

- Added the class `.remark-code-has-line-highlighted` to the `<pre>` parent element containing code with highlighted lines (@gadenbuie, #220).

# CHANGES IN xaringan VERSION 0.11

## BUG FIXES

- `{{ }}` in source code could incorrectly highlight a line when `}}` is not at the end of a line (thanks, @filipwastberg, #215).

# CHANGES IN xaringan VERSION 0.10

## NEW FEATURES

- Added the ability to specify an `institute` in the YAML header that is automatically added to the title slide (@paullemmens, #200).

## BUG FIXES

- The Infinite Moon Reader (`xaringan::inf_mr()`) didn't take slide properties `layout: true` and `exclude: true` into consideration (thanks, @fmmattioni, #198).

# CHANGES IN xaringan VERSION 0.9

## NEW FEATURES

- The Infinite Moon Reader (`xaringan::inf_mr()`) has been significantly enhanced for a much smoother user experience of authoring slides with the `xaringan::moon_reader` format in RStudio. The preview of the current slide will be instant (as you type in the RStudio editor), and the navigation in the source editor will be linked to the navigation of slides output. See https://yihui.org/en/2019/02/ultimate-inf-mr/ for details.

- When printing slides to PDF, only the last slide of a series of incremental slides will be printed (thanks, @sebpardo @@benjie, #192).

- Added a function `decktape()` to export slides to PDF via the DeckTape library (thanks, @pat-s, #177).

- Added a CSS theme `uol` (University of Leicester) (thanks, @ellessenne, #183).

- Added a CSS theme `fc` (thanks, @Yue-Jiang, #189).

- `xaringan::inf_mr()` can detect changes in CSS/JS and common images now. When any of these files are changed, it will rebuild the Rmd document and reload the output in the browser (thanks, @mrchypark @tcgriffith, #185).

- External links (URLs starting with `http://` or `https://`) on slides will be opened in new browser tabs/windows.

## BUG FIXES

- Fixed several long-lasting issues related to MathJax fonts and printing to PDF (#62, #73, #143, #148, #168).

# CHANGES IN xaringan VERSION 0.8

## NEW FEATURES

- Added output highlighting using the chunk option `highlight.output` (thanks, @malcolmbarrett, #175).

- Added a CSS theme `chocolate`. See [here](https://liao961120.github.io/slides/xaringan/) for an example slide (thanks, @liao961120, #171).

- Added a set of CSS theme `kunoichi`, `shinobi` and `ninjutsu` - see [here for example](https://emitanaka.github.io/ninja-theme) (thanks, @emitanaka, #165).

- Added a CSS theme `lucy` (thanks, @LucyMcGowan, #163).

# CHANGES IN xaringan VERSION 0.7

## NEW FEATURES

- Added a CSS theme `middlebury` (Middlebury College) (thanks, @jvcasillas, #150).

- Added a CSS theme `tamu` (Texas A&M) (thanks, @nanhung, #115).

- Added a CSS theme `rutgers` (Rutgers University) (#121).

- Added a CSS theme `uo` (University of Oregon) (#125).

- Added a CSS theme `robot` (inspired by the Roboto Google font) (#126).

- Added a CSS theme `duke-blue` and corresponding `hygge-duke` (Duke University) (thanks, @libjohn, #133).

- In the `metropolis` theme, updated weights and margins of all headers, and added a new CSS class `clear` that disables the colored box at the top of each slide (#107).

- It is possible to customize the CSS classes of the title slide using the option `titleSlideClass` under the `nature` option of `xaringan::moon_reader()` now (thanks, @gadenbuie, #139, #136).

## BUG FIXES

- An informative error message is now returned when trying to use an invalid or misspelled CSS theme name (thanks, @gadenbuie, #129).

- LaTeX math expressions will no longer be rendered inside the `<code></code>` tags (thanks, @garthtarr, #137).

- The default CSS style for tables should not be applied to the help page of the slides (thanks, @KevCaz, #138).

# CHANGES IN xaringan VERSION 0.6

## NEW FEATURES

- Added CSS `hygge` - some template-independent CSS code for general formatting. Add as argument to `xaringan::moon_reader` (thanks, @ekstroem, #113).

# CHANGES IN xaringan VERSION 0.5

## NEW FEATURES

- The default CSS file was split into two files default.css and default-fonts.css to make it easier to define custom font styles without copying all base CSS definitions. For example, the `css` argument of `xaringan::moon_reader` can take a vector of `default` and `extra.css`, and you define your custom font styles in `extra.css`.

- For the `css` argument, if a value does not end with `.css`, it is assumed to be a built-in CSS file in this package. Currently all available CSS files can be found at https://github.com/yihui/xaringan/tree/master/inst/rmarkdown/templates/xaringan/resources. See `?xaringan::moon_reader` for more details. This change was to make it easier for users to contribute custom themes (https://yihui.org/en/2017/10/xaringan-themes/).

- Added a new sub-option `beforeInit` under the `nature` option, which can be used to specify JavaScript files to be executed before the instantiation of slides (i.e., before `remark.create()`). One application of this new feature is to define custom remark.js macros; see the slide "Macros" at https://slides.yihui.org/xaringan/ for more info (thanks, @gavinsimpson, #80).

- Line highlighting can also be turned on using a special comment `#<<` at the end of a line of code now (thanks, @gadenbuie, #103).

# CHANGES IN xaringan VERSION 0.4

## NEW FEATURES

- The PDF printed from the slides in browser looks much nicer now (no extra margins) (thanks, @cboettig and @ekstroem, #65).

## BUG FIXES

- Line highlighting using `{{}}` does not work with multiple lines (thanks, @HeidiSeibold #53 and @aj2duncan #54).

- The option `mathjax: null` does not work for `moon_reader()`, i.e., it was not possible to exclude MathJax.

# CHANGES IN xaringan VERSION 0.3

## NEW FEATURES

- A new option `countdown` in the `nature` option of `moon_reader()` can be set so that a countdown timer is added to each page of slides. See `?xaringan::moon_reader` and https://slides.yihui.org/xaringan/ for more information (thanks, @slopp, #43).

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

- Initial CRAN release. See the documentation at https://slides.yihui.org/xaringan/

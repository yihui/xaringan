# xaringan

<img src="https://user-images.githubusercontent.com/163582/45438104-ea200600-b67b-11e8-80fa-d9f2a99a03b0.png" align="right" alt="Sharingan" width="180" />

[ʃaː.'riŋ.ɡan]

<!-- badges: start -->
[![R-CMD-check](https://github.com/yihui/xaringan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yihui/xaringan/actions/workflows/R-CMD-check.yaml)
[![CRAN release](https://www.r-pkg.org/badges/version/xaringan)](https://cran.r-project.org/package=xaringan)
[![Codecov test coverage](https://codecov.io/gh/yihui/xaringan/branch/master/graph/badge.svg)](https://app.codecov.io/gh/yihui/xaringan?branch=master)
<!-- badges: end -->

An R package for creating slideshows with [remark.js](https://remarkjs.com) through R Markdown. The package name **xaringan** comes from [Sharingan](https://naruto.fandom.com/wiki/Sharingan), a dōjutsu in Naruto with two abilities: the "Eye of Insight" and the "Eye of Hypnotism". A presentation ninja should have these basic abilities, and I think remark.js may help you acquire these abilities, even if you are not a member of the Uchiha clan.

Please see the full documentation as a [presentation here](https://slides.yihui.org/xaringan/) ([中文版在此](https://slides.yihui.org/xaringan/zh-CN.html)). The [remark.js](https://remarkjs.com) website provides a quick introduction to the underlying syntax upon which **xaringan** builds. If you prefer reading a book, **xaringan** is also documented in [the R Markdown book (Chapter 7)](https://bookdown.org/yihui/rmarkdown/xaringan.html). You can use **remotes** to install the package:

```r
remotes::install_github('yihui/xaringan')
```

If you use RStudio, it is easy to get started from the menu `File -> New File -> R Markdown -> From Template -> Ninja Presentation`, and you will see an R Markdown example. Press the `Knit` button to compile it, or use the RStudio Addin `Infinite Moon Reader` to live preview the slides (every time you update and save the Rmd document, the slides will be automatically reloaded; make sure the Rmd document is on focus when you click the addin). Please see the [issue #2](https://github.com/yihui/xaringan/issues/2) if you do not see the template or addin in RStudio.

The main R Markdown output format in this package is `moon_reader()`. See the R help page `?xaringan::moon_reader` for all possible configurations.

## Slide formatting

The [remark.js Wiki](https://github.com/gnab/remark/wiki) contains detailed documentation about how to format slides and use the presentation (keyboard shortcuts). The **xaringan** package has simplified several things compared to the official remark.js guide, e.g. you don't need a boilerplate HTML file, you can set the autoplay mode via an option of `moon_reader()`, and LaTeX math basically just works (TM). Please note that remark.js does not support Pandoc's Markdown, so you will not be able to use any fancy Pandoc features, but that is probably fine for presentations. BTW, you can use raw HTML when you feel there is something you desperately want but cannot get from the basic Markdown syntax (e.g. `knitr::kable(head(iris), 'html')`).

As the package title indicates, this package is designed for ninja. If you are a beginner of HTML/CSS, you may have to stick with the default CSS (which is not bad). The more you know about CSS, the more you can achieve with this package. The sky is your limit.

We have a [wiki](https://github.com/yihui/xaringan/wiki) that might help you to use CSS to alter the appearance of your presentation. 
Make sure to check it out before opening an issue. 
You might also consider posting simple usage questions on [stackoverflow](https://stackoverflow.com/questions/tagged/xaringan) using the `#xaringan`tag.
We will read all questions with the `#xaringan` tag so please be patient if we don't answer within a day :smile:

Do not forget to try [the option `yolo: true`](https://github.com/yihui/xaringan/issues/1) under `xaringan::moon_reader` in the YAML metadata of your R Markdown document. Big thanks to [Karl Broman](https://slides.yihui.org/xaringan/karl.html)!

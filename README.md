# xaringan

[![Build Status](https://travis-ci.org/yihui/xaringan.svg)](https://travis-ci.org/yihui/xaringan)

<img src="https://upload.wikimedia.org/wikipedia/commons/b/be/Sharingan_triple.svg" align="right" alt="Sharingan" width="100" />
An R package for creating slideshows with [remark.js](http://remarkjs.com) through R Markdown. The package name **xaringan** comes from [Sharingan](http://naruto.wikia.com/wiki/Sharingan), a dōjutsu in Naruto with two abilities: the "Eye of Insight" and the "Eye of Hypnotism". A presentation ninja should have these basic abilities, and I think remark.js may help you acquire these abilities, even if you are not a member of the Uchiha clan.

You can use **devtools** to install the package:

```r
devtools::install_github('yihui/xaringan')
```

If you use RStudio, it is easy to get started from the menu `File -> New File -> R Markdown -> From Template -> Presentation Ninja`, and you will see an R Markdown example. Press the `Knit` button to compile it, or use the RStudio Addin `Infinite Moon Reader` to live preview the slides (every time you update and save the Rmd document, the slides will be automatically reloaded; make sure the Rmd document is on focus when you click the addin).

The main R Markdown output format in this package is `moon_reader()`. See the R help page `?xaringan::moon_reader` for all possible configurations.

The [remark.js Wiki](https://github.com/gnab/remark/wiki) contains detailed documentation about the usage. The **xaringan** package has simplified a lot of things, e.g. you don't need a boilerplate HTML file, you can set the autoplay mode via an option of `moon_reader()`, and LaTeX math basically just works (TM). Please note that remark.js does not support Pandoc's Markdown, so you will not be able to use any fancy Pandoc features, but that is probably fine for presentations. BTW, you can use raw HTML when you feel there is something you desparately want but cannot get from the basic Markdown syntax (e.g. `knitr::kable(head(iris), 'html')`).

As the package title indicates, this package is designed for ninja. If you are a beginner of HTML/CSS, you may have to stick with the default CSS (which is not bad). The more you know about CSS, the more you can achieve with this package. The sky is your limit.

Do not forget to try [the option `yolo: true`](https://github.com/yihui/xaringan/issues/1) under `xaringan::moon_reader` in the YAML metadata of your R Markdown document.

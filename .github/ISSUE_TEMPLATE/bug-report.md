---
name: Bug report
about: Create a report to help us improve
---

Before reporting a bug, please make sure to test the current development version of this package and [update all your R packages](https://yihui.name/en/2017/05/when-in-doubt-upgrade/) (and R itself) if possible:

```r
remotes::install_github('yihui/xaringan')
update.packages(ask = FALSE, checkBuilt = TRUE)
```

If the bug still persists, please [provide a minimal, self-contained, and reproducible example](https://yihui.name/en/2017/09/the-minimal-reprex-paradox/) (reprex) that is [easy for others to run](https://yihui.name/en/2018/06/copy-and-run/), and also provide `xfun::session_info('xaringan')`. Screenshots can be helpful to illustrate problems. Please also [make sure your issue is correctly formatted](https://yihui.name/en/2018/05/github-issue-format/).

If you are not sure if it is a bug or not, please consider [asking a question on Stack Overflow](https://yihui.name/en/2017/08/so-gh-email/) (with at least tags `r` and [`xaringan`](https://stackoverflow.com/tags/xaringan)) or in [RStudio Community](https://community.rstudio.com) first. We are more committed to fixing bugs than answering general questions here on Github due to limited human resources. Thanks for your understanding!

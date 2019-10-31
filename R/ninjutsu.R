#' Use a new xaringan theme.
#'
#' This function clones an xaringan theme for you to use. Include it in a code chunk in the xaringan slide source.
#'
#'
#' @param theme Either a built-in theme shipped with xaringan, or the repository address of the theme in the format of username/repo
#' @param ref desired git reference. could be a commit SHA, or a branch name. Defauts to master
#'
#'
#' @return The cloned theme
#' @export
#'
#' @examples
#' # built-in
#' shadow_clone("kunoichi")
#' # remote
#' shadow_clone("tcgriffith/xaringan_theme_example")
#'
shadow_clone = function(theme=NULL, ref="master"){

  ## retrieve built-in themes
  builtin_css = list_css()
  builtin_theme = names(builtin_css)

  ## similar to remotes::install_github, convert repo into full url on github
  ## theme=tcgriffith/xaringan_theme_example ->
  ## css_remote = https://raw.githubusercontent.com/tcgriffith/xaringan_theme_example/master/xaringan_theme_example.css

  if (is.null(theme)) return(NULL)

  bn = basename(theme)
  css_remote = sprintf("https://raw.githubusercontent.com/%s/%s/%s.css",
                       theme,
                       ref,
                       bn)
  css_local = basename(css_remote)

  ## built-in theme
  if (theme %in% builtin_theme) {
    message("Theme: ", theme)
    message(sprintf("To use the same theme, try shadow_clone(%s)",theme))
    css_local = builtin_css[theme]
  }
  ## remote theme
  else {
    ## extract git hash as ref and print out as message
    repo = paste0("https://github.com/", theme)
    cmd = paste0("git ls-remote ",repo," refs/heads/master")
    rslt = system(command=cmd, intern=TRUE)
    ref = substr(rslt, 1,8)

    message("Theme repo:", repo)
    message("ref: ", ref)
    message(sprintf("To use the same theme, try shadow_clone(%s,%s)",theme, ref))

    ## download remote css when css_local doesn't exist
    if (!file.exists(css_local)){
      try_dl = try(xfun::download_file(css_remote))
      ## if download failed, fallback to default CSS. warning
      if(try_dl != 0 ) {
        warning("# Shadow clone failed. Theme not found.")
        css_local = NULL
      }
    }
  }

  ## include CSS in the final xaringan html.

  if(!is.null(css_local)){
    htmltools::includeCSS(css_local)
  }
}

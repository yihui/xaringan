library(testit)

assert(
  'sample2() does not make an exception on length-1 x',
  sample2(5, 2) %==% c(5, 5),
  length(sample2(1:5, 2)) == 2
)

assert(
  'protect_math() puts math in ` `',
  protect_math('$a$') %==% '`\\(a\\)`',
  protect_math('$500 $600') %==% '$500 $600',
  protect_math('$ a $') %==% '$ a $',
  protect_math('`$a$`') %==% '`$a$`',
  protect_math('b$a$') %==% 'b$a$',  # no space before $; unlikely to be math
  protect_math(' $a$') %==% ' `\\(a\\)`',
  protect_math('$$a$$') %==% '`$$a$$`',
  protect_math('$$ a$$') %==% '$$ a$$',
  protect_math('$$a$') %==% '$$a$'
)

assert(
  "highlight_code handles {{ .code. }} and ...code #<< formats",
  highlight_code("{{paste('a')}}") %==% "*paste('a')",
  highlight_code("paste('a') #<<") %==% "*paste('a')",
  highlight_code(" {{paste('a')}}") %==% "* paste('a')",
  highlight_code(" paste('a') #<<") %==% "*paste('a')",
  highlight_code("{{paste('a')}} #<<") %==% "*paste('a') #<<",
  highlight_code("*paste('a') #<<") %==% "*paste('a') #<<",
  highlight_code("paste('a') #comment #<<") %==% "*paste('a') #comment",
  highlight_code("paste('a') #<<    ") %==% "*paste('a')",
  highlight_code("paste('a')    #<<    ") %==% "*paste('a')",
  highlight_code("   paste('a') #<<") %==% "*  paste('a')",
  highlight_code("*  paste('a') #<<") %==% "*  paste('a') #<<",
  highlight_code("paste('a')#<<") %==% "*paste('a')",
  # A space is added in following (can't overwrite first space when 2nd char is *)
  highlight_code(" * paste('a') #<<") %==% "* * paste('a')"
)

test_uri = "data:text/plain;base64,R0lGODdhAgACAIAAAAAAAP///ywAAAAAAgACAAACAoRRADs="
assert(
  "process_self_contained_images handles image specifications correctly",
  process_self_contained_images("background-image: url(https://www.htmlgoodies.com/images/1x1.gif)") %==%
    paste0("background-image: url(", test_uri, ")"),
  process_self_contained_images("testing, testing <img src='https://www.htmlgoodies.com/images/1x1.gif'/>") %==%
    paste0("testing, testing <img src='", test_uri, "'/>"),
  process_self_contained_images("testing, testing <img src='https://www.htmlgoodies.com/images/1x1.gif'></img>") %==%
    paste0("testing, testing <img src='", test_uri, "'></img>"),
  process_self_contained_images("testing, testing `<img src='https://www.htmlgoodies.com/images/1x1.gif'/>`") %==%
    "testing, testing `<img src='https://www.htmlgoodies.com/images/1x1.gif'/>`",
  process_self_contained_images("testing, testing !()[https://www.htmlgoodies.com/images/1x1.gif]") %==%
    paste0("testing, testing !()[https://www.htmlgoodies.com/images/1x1.gif]"),
  process_self_contained_images("testing, testing `!()[https://www.htmlgoodies.com/images/1x1.gif]`") %==%
    "testing, testing `!()[https://www.htmlgoodies.com/images/1x1.gif]`"
)

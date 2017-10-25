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

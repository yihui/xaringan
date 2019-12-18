library(testit)

assert('sample2() does not make an exception on length-1 x', {
  (sample2(5, 2) %==% c(5, 5))
  (length(sample2(1:5, 2)) == 2)
})

assert('highlight_code handles {{ .code. }} and ...code #<< formats', {
  (highlight_code('{{paste(1)}}') %==% '*paste(1)')
  (highlight_code('paste(1) #<<') %==% '*paste(1)')
  (highlight_code(' {{paste(1)}}') %==% '* paste(1)')
  (highlight_code(' paste(1) #<<') %==% '*paste(1)')
  (highlight_code('{{paste(1)}} # }} not at the end') %==% '{{paste(1)}} # }} not at the end')
  (highlight_code('{{paste(1)}} #<<') %==% '*{{paste(1)}}')
  (highlight_code('*paste(1) #<<') %==% '*paste(1) #<<')
  (highlight_code('paste(1) #comment #<<') %==% '*paste(1) #comment')
  (highlight_code('paste(1) #<<    ') %==% '*paste(1)')
  (highlight_code('paste(1)    #<<    ') %==% '*paste(1)')
  (highlight_code('   paste(1) #<<') %==% '*  paste(1)')
  (highlight_code('*  paste(1) #<<') %==% '*  paste(1) #<<')
  (highlight_code('paste(1)#<<') %==% '*paste(1)')
  # A space is added in following (can't overwrite first space when 2nd char is *)
  (highlight_code(' * paste(1) #<<') %==% '* * paste(1)')
})

assert('code fence blocks are correctly identified', {
  (outside_chunk(c('', '```', '', '```', '')) %==% c(TRUE, FALSE, FALSE, FALSE, TRUE))
  (outside_chunk(c('', '``', '', '``', '')) %==% rep(TRUE, 5))
  (outside_chunk(c('', '```', '````', '```', '')) %==% c(TRUE, FALSE, FALSE, FALSE, TRUE))
  (outside_chunk(c('', '````', '```', '````', '')) %==% c(TRUE, FALSE, FALSE, FALSE, TRUE))
})

assert('bare script tags are correctly identified', {
  body1 <- c('', '<script>', 'line', '</script>')
  body2 <- c('', '<script>line</script>', '')
  body3 <- c('', 'blah `<script>`', '')
  body4 <- c('', '```', '<script>something</script>', '```', '', '<script>line</script')
  body5 <- c("", "<script type=\"text/javascript\">", "line", "</script>", "")
  (bare_script_lines(body1) %==% 2:4)
  (bare_script_lines(body2) %==% 2L)
  (bare_script_lines(body3) %==% integer(0))
  (bare_script_lines(body4) %==% 6L)
  (bare_script_lines(body5) %==% 2:4)
})

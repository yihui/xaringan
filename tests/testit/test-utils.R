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

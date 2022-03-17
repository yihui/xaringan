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

test_uri = 'data:image/gif;base64,R0lGODdhAgACAIAAAAAAAP///ywAAAAAAgACAAACAoRRADs='
clean_env_images()
assert('encode_images() identifies images, process their paths, and stores base64 data', {
  (encode_images('background-image: url(1x1.gif)') %==%
    paste0('background-image: url(', url_token, '1x1.gif)'))
  (env_images[['1x1.gif']] %==% test_uri)

  (encode_images('background-image: url(./1x1.gif)') %==%
      paste0('background-image: url(', url_token, './1x1.gif)'))
  (env_images[['./1x1.gif']] %==% test_uri)

  (encode_images('testing <img src="1x1.gif" />') %==%
    paste0('testing <img src="', url_token, '1x1.gif" />'))

  (encode_images('testing ![test](1x1.gif)') %==%
      paste0('testing ![test](', url_token, '1x1.gif)'))

  # the image doesn't exist
  (encode_images('testing ![test](2x2.gif)') %==% 'testing ![test](2x2.gif)')
  (is.null(env_images[['2x2.gif']]))

  # incorrect Markdown syntax
  (encode_images('testing !()[1x1.gif]') %==% 'testing !()[1x1.gif]')

  # surrounded by backticks
  (encode_images('testing `!()[1x1.gif]`') %==% 'testing `!()[1x1.gif]`')

  (encode_images('testing `<img src="1x1.gif"/>`') %==% 'testing `<img src="1x1.gif"/>`')
})

# this requires Internet connection, so only run in CI environments like Travis
if (!is.na(Sys.getenv('NOT_CRAN', NA))) assert('encode_images() works with online images', {
  (encode_images("background-image: url(https://github.com/yihui/xaringan/raw/master/tests/testit/1x1.gif)") %==%
     paste0("background-image: url(", url_token, "https://github.com/yihui/xaringan/raw/master/tests/testit/1x1.gif)"))
  (env_images[['https://github.com/yihui/xaringan/raw/master/tests/testit/1x1.gif']] %==% test_uri)
})

clean_env_images()

library(testit)

tmpin = tempfile(fileext = ".Rmd")
file.copy("parameterized.Rmd", tmpin)
tmpout = tempfile(fileext = ".html")
tmpout_file = basename(tmpout)

options(servr.daemon = TRUE)
s = xaringan::inf_mr(
  tmpin, dirname(tmpout), output_file = tmpout_file, quiet = TRUE
)
s$stop_server()
params_top_level = readLines(tmpout)

count_matches = function(pattern, text) sum(grepl(pattern, text, fixed = TRUE))

assert('parameterized slides uses top-level `params` in YAML', {
  (count_matches("params$foo = oof", params_top_level) %==% 1L)
  (count_matches("params$bar = rab", params_top_level) %==% 1L)
  (count_matches("params$baz = zab", params_top_level) %==% 1L)
})

s = xaringan::inf_mr(
  tmpin, dirname(tmpout), params = list(foo = "hello", bar = "world"),
  output_file = tmpout_file, quiet = TRUE
)
s$stop_server()
params_top_level = readLines(tmpout)

assert('inf_mr(...) overrides `params` in YAML', {
  (count_matches("params$foo = oof", params_top_level) %==% 0L)
  (count_matches("params$foo = hello", params_top_level) %==% 1L)
  (count_matches("params$bar = rab", params_top_level) %==% 0L)
  (count_matches("params$bar = world", params_top_level) %==% 1L)
})

assert('inf_mr(...) params falls back to top-level `params` in YAML', {
  (count_matches("params$baz = zab", params_top_level) %==% 1L)
})

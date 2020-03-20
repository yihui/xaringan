library(testit)
test_pkg('xaringan')
if (rmarkdown::pandoc_available('1.12.3')) test_pkg('xaringan', 'test2')

library(testit)

assert(
  "check if the PDF conversion works",
  export_pdf("inst/rmarkdown/templates/xaringan/skeleton/skeleton.html", "~/out.pdf",
             decktape_version = "2.8.0")
)

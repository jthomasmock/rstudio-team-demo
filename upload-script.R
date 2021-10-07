library(rsconnect)

rmarkdown::render("index.Rmd")

c(
  format(fs::file_info("index.html")$modification_time, tz = "US/Central"),
  format(Sys.time(), tz = "US/Central")
)

deployDoc("index.html",
          appId = "f134d358-a12c-4f62-afb8-1e0b917efa4a",
          account = "thomas",
          server = "colorado.rstudio.com",
          forceUpdate = TRUE
          )
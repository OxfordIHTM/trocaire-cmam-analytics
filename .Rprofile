## Load .env if present
if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}

options(
  repos = c(
    IHTM = "https://oxfordihtm.r-universe.dev",
    RAPIDSURVEYS = "https://rapidsurveys.r-universe.dev",
    CRAN = "https://cloud.r-project.org"
  ),
  renv.config.repos.override = getOption("repos"),
  renv.config.auto.snapshot = FALSE, 
  renv.config.rspm.enabled = TRUE, 
  renv.config.install.shortcuts = TRUE, 
  renv.config.cache.enabled = TRUE,
  renv.config.synchronized.check = FALSE
)

source("renv/activate.R")

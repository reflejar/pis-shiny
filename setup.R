#!/usr/bin/env Rscript

# This script installs some development packages that are needed for various
# apps. It can be sourced from RStudio, or run with Rscript.

is_installed <- function(pkg) {
  if (system.file(package = pkg) == "")
    FALSE
  else
    TRUE
}



# Install a package or packages if not already installed.
install_if_needed <- function(pkgs) {
  pkgs <- sort(unique(pkgs))
  message("Intentando instalar: ", paste0(pkgs, collapse = ", "))
  installed_idx <- vapply(pkgs, is_installed, TRUE)
  needed <- pkgs[!installed_idx]
  if (length(needed) > 0) {
    message("Instalando paquetes requeridos desde CRAN: ", paste(needed, collapse = ", "))
    install.packages(needed, dependences=TRUE)
  }
}

PKGS <- c('shiny', 'shinyjs', 'data.table','units', 'sf','dplyr','tidyr', 'leaflet', 'leaflet.extras2', 'arrow', 'sfarrow')

# Core packages
install_if_needed(PKGS)
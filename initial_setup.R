pak::pkg_install("OFB-IdF/FichesSRC")
if (!file.exists((".github/workflows/ci.yml"))) {
  file.copy(system.file("extdata", ".github", package = "FichesSRC"), ".", overwrite = TRUE, recursive = TRUE)
}
if (!file.exists("deploiement.R")) {
  file.copy(system.file("extdata", "deploiement.R", package = "FichesSRC"), ".")
}
FichesSRC::recuperer_fiches_excel()
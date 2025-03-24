# pak::pkg_install("OFB-IdF/FichesSRC")

purrr::walk(
    paste0("www/", c("history.png", "standing-up-man.png")),
    function(x) {
        file.copy(
            from = system.file(x, package = "FichesSRC"),
            to = x)
    }
)

metadata <- "16U2L1TXC7ZtkEPT2QBquJWDEDXPEvt1PDaQp6SlhF4Q"

intitules <- FichesSRC::charger_suivis(metadata)
intitules <- intitules |>
  dplyr::left_join(
    intitules$suivi |>
      purrr::map(
        function(suivi_x) {
          info_x <- FichesSRC::charger_informations(metadata, suivi_x, 11)
          tibble::tibble(suivi = info_x$suivi, intitule = info_x$intitule)
        }
      ) |>
      purrr::list_rbind(),
    by = "suivi"
  )

FichesSRC::creer_toutes_fiches(
    metadata,
    dossier_fiches = getwd(),
    region = 11
    )

paste0(intitules$suivi, ".qmd") |>
    purrr::walk(
        function(fiche) {
            fiche_txt <- readLines(fiche)
            if (all(!stringr::str_detect(
                fiche_txt,
                pattern = '- <script data-goatcounter="https://ofb-idf.goatcounter.com/count"
                async src="//gc.zgo.at/count.js"></script>'
            ))) {
                fiche_txt |>
                    sapply(
                        function(ligne) {
                            stringr::str_replace(
                                ligne,
                                pattern = 'include-in-header:',
                                replacement = 'include-in-header:
  - text: |
        <script data-goatcounter="https://ofb-idf.goatcounter.com/count"
        async src="//gc.zgo.at/count.js"></script>'
                )
                        }
                    )|>
                    writeLines(con = fiche)
            }

            }
    )

brew::brew(
    file = "data-raw/index.qmd.template",
    output = "index.qmd"
)
brew::brew(
  file = "data-raw/calendrier.qmd.template",
  output = "calendrier.qmd"
)

quarto::quarto_render(as_job = FALSE)

FichesSRC::ajuster_html(dossier = "_site")



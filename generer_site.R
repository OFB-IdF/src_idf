pak::pkg_install("OFB-IdF/FichesSRC")

'%>%' <- dplyr::'%>%'

purrr::walk(
    paste0("www/", c("history.png", "standing-up-man.png")),
    function(x) {
        file.copy(
            from = system.file(x, package = "FichesSRC"),
            to = x)
    }
)

metadata <- openxlsx2::read_xlsx("data-raw/metadata.xlsx") |>
    dplyr::filter(publiable == "oui")

FichesSRC::creer_toutes_fiches(
    fichier_info = "data-raw/metadata.xlsx",
    dossier_fiches = getwd(),
    region = 11
    )

metadata$suivi |>
    paste0(".qmd") |>
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
    file = "data-raw/index_template.qmd",
    output = "index.qmd"
)

quarto::quarto_render(as_job = FALSE)

FichesSRC::ajuster_html(dossier = "_site")

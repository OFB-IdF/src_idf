pak::pkg_install("OFB-IdF/FichesSRC")

'%>%' <- dplyr::'%>%'

FichesSRC::creer_toutes_fiches(
    fichier_info = "data-raw/metadata.xlsx",
    dossier_fiches = getwd(),
    region = 11
    )

quarto::quarto_render(as_job = FALSE)

Sys.sleep(5)

readLines("_site/index.html") %>%
    stringr::str_replace(
        pattern = '<a href="./index.html" class="navbar-brand navbar-brand-logo">',
        replacement = '<a href="https://www.ofb.gouv.fr" class="navbar-brand navbar-brand-logo">'
    ) %>%
    writeLines("_site/index.html")

Sys.sleep(5)

list.files("_site", pattern = ".html", full.names = TRUE) %>%
    purrr::walk(
        .f = function(path) {
            readLines(path) %>%
                stringr::str_replace(
                    pattern = '<h2 id="toc-title">On this page</h2>',
                    replacement = '<h2 id="toc-title">Menu</h2>'
                ) %>%
                writeLines(path)
        }
    )

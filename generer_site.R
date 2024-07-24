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

FichesSRC::creer_toutes_fiches(
    fichier_info = "data-raw/metadata.xlsx",
    dossier_fiches = getwd(),
    region = 11
    )

quarto::quarto_render(as_job = FALSE)

FichesSRC::ajuster_html(dossier = "_site")

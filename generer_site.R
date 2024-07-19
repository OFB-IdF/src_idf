pak::pkg_install("OFB-IdF/FichesSRC")

'%>%' <- dplyr::'%>%'

FichesSRC::creer_toutes_fiches(
    fichier_info = "data-raw/metadata.xlsx",
    dossier_fiches = getwd(),
    region = 11
    )

quarto::quarto_render(as_job = FALSE)

FichesSRC::ajuster_html(dossier = "_site")

pak::pkg_install("OFB-IdF/FichesSRC")

FichesSRC::creer_toutes_fiches(
    fichier_info = "data-raw/metadata.xlsx",
    dossier_fiches = getwd(),
    region = 11
    )

quarto::quarto_render()

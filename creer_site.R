pak::pkg_install("OFB-IdF/FichesSRC")

# FichesSRC::recuperer_fiches_excel()

FichesSRC::generer_site(
  fichier_infos = "suivis_connaissance",
  source_fichier = "google_sheet",
  dossier_travail = "pages",
  region = 11,
  goatcounter_id = "ofb-idf"
)

rstudioapi::documentOpen(path = "pages/productions.qmd")
rstudioapi::documentOpen(path = "pages/ressources.qmd")

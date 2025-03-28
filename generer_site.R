pak::pkg_install("OFB-IdF/FichesSRC")

FichesSRC::generer_site(
  fichier_infos = "suivis_connaissance", source_fichier = "google_sheet",
  dossier_travail = ".",
  region = 11,
  goatcounter_id = "ofb-idf"
)

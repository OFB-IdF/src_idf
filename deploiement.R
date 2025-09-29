# Configuration
## Fichier JSON d'authentification Google Drive (NULL si fichier local)
auth_json <- Sys.getenv("GOOGLE_SERVICE_ACCOUNT_JSON", "")
# Écrire le JSON dans un fichier
writeLines(auth_json, "service-account.json")
# Authentification avec fichier
googledrive::drive_auth(path = "service-account.json")
## Tableau excel ou google sheet contenant les informations sur les suivis
fichier_infos <- googledrive::drive_find(pattern = "suivis_connaissance")$name
source_fichier <- "google_sheet"
## Dossier dans lequel le site sera généré
dossier_travail <- "tableau_de_bord"
## Numéro INSEE de la région
region <- "11"
## Si suivi du trafic par GoatCounter, indiquer l'id du compte GoatCounter
goatcounter_id <- "ofb-idf"

# Générer le site
FichesSRC::initier_site(dossier_travail)
# rstudioapi::documentOpen(path = file.path(dossier_travail, "productions.qmd"))
# rstudioapi::documentOpen(path = file.path(dossier_travail, "ressources.qmd"))
FichesSRC::generer_site(fichier_infos, source_fichier, dossier_travail, region, goatcounter_id)

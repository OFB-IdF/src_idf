# Configuration
## Tableau excel ou google sheet contenant les informations sur les suivis
fichier_infos <- "suivis_connaissance"
source_fichier <- "google_sheet"
## Dossier dans lequel le site sera généré
dossier_travail <- "tableau_de_bord"
## Numéro INSEE de la région
region <- "11"
## Si suivi du trafic par GoatCounter, indiquer l'id du compte GoatCounter
goatcounter_id <- "ofb-idf"
## Fichier JSON d'authentification Google Drive (NULL si fichier local)
auth_json <- Sys.getenv("GOOGLE_SERVICE_ACCOUNT_JSON", "")

# Générer le site
FichesSRC::initier_site(dossier_travail)
# rstudioapi::documentOpen(path = file.path(dossier_travail, "productions.qmd"))
# rstudioapi::documentOpen(path = file.path(dossier_travail, "ressources.qmd"))
FichesSRC::generer_site(fichier_infos, source_fichier, dossier_travail, region, goatcounter_id)

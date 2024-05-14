# Préparation données
departements <- sf::st_read("C:/QGIS-CUSTOM/DATA/VECTEUR/administration/ADMIN EXPRESS/ADE_3-1_SHP_LAMB93_FXX/DEPARTEMENT.shp") %>%
    dplyr::filter(INSEE_REG == 11) %>%
    sf::st_transform(crs = 4326)

stations_dce <- dplyr::bind_rows(
    sf::st_read("C:/QGIS-CUSTOM/DATA/VECTEUR/surveillance/Stations de mesure de la qualité des eaux/RCS-IdF_DRIEE.shp") %>%
        dplyr::mutate(reseau = "RCS"),
    sf::st_read("C:/QGIS-CUSTOM/DATA/VECTEUR/surveillance/Stations de mesure de la qualité des eaux/RCO-IdF_DRIEE.shp") %>%
        dplyr::mutate(reseau = "RCO")
) %>%
    dplyr::mutate(
        STATION = as.character(paste0("0", STATION)),
        reseau = reseau %>%
            factor(levels = c("RCO", "RCS"))
    ) %>%
    sf::st_transform(crs = 4326) %>% rmapshaper::ms_clip(departements) %>%
    dplyr::group_by(STATION) %>%
    dplyr::filter(as.numeric(reseau) == max(as.numeric(reseau))) %>%
    dplyr::mutate(
        riviere = RIVIERE %>%
            stringr::str_remove(pattern = "\\)") %>%
            stringr::str_split(pattern = ", | \\(") %>%
            purrr::map(
                function(x) {
                    if (stringr::str_detect(x[[2]], "^d")) {
                        paste0("le ", x[[3]], " ", x[[2]], ifelse(test = stringr::str_detect(x[[2]], "'"), yes = "", no = " "), x[[1]])
                    } else {
                        paste0(x[[2]], ifelse(test = stringr::str_detect(x[[2]], "'"), yes = "", no = " "), x[[1]])
                    }
                }
            ) %>%
            purrr::list_c()
    ) %>%
    dplyr::ungroup()


cours_eau <- sf::st_read("C:/QGIS-CUSTOM/DATA/VECTEUR/hydrographie/bdtopage_idf.gpkg", layer = "cours_eau_2022") %>%
    sf::st_transform(crs = 4326) %>%
    rmapshaper::ms_clip(departements) %>%
    dplyr::filter(!stringr::str_detect(string = TopoOH, pattern = "Canal|Aqueduc"))

save(departements, stations_dce, cours_eau, file = "data/data.rda")

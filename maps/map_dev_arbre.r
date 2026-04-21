library(sf)
library(leaflet)

data <- read.csv("projet_ia_web_bd/data/Data_Arbre_Clean.csv")

# Classification simple des arbres
# Bleu   : Jeune
# Vert  : Adulte
# Orange  : Vieux
# Rouge : Senescent
data$couleur <- "yellow"

data$couleur[
    data$fk_stadedev == "jeune" &
    !is.na(data$clc_quartier) &
    data$clc_quartier != ""
] <- "blue"

data$couleur[
    data$fk_stadedev == "adulte" &
    !is.na(data$clc_quartier) &
    data$clc_quartier != ""
] <- "green"

data$couleur[
    data$fk_stadedev == "vieux" &
    !is.na(data$clc_quartier) &
    data$clc_quartier != ""
] <- "orange"

data$couleur[
    data$fk_stadedev == "senescent" &
    !is.na(data$clc_quartier) &
    data$clc_quartier != ""
] <- "red"

# texte pour legende
data$categorie <- "Aucune données du développement"
data$categorie[data$couleur == "blue"] <- "Arbre jeune"
data$categorie[data$couleur == "green"] <- "Arbre adulte"
data$categorie[data$couleur == "orange"] <- "Arbre vieux"
data$categorie[data$couleur == "red"] <- "Arbre senescent"

# Conversion des coordonnees vers le format des cartes web
arbres_sf <- st_as_sf(data, coords = c("X", "Y"), crs = 3949)
arbres_wgs84 <- st_transform(arbres_sf, 4326)

coords <- st_coordinates(arbres_wgs84)
arbres_wgs84$lon <- coords[, 1]
arbres_wgs84$lat <- coords[, 2]

# Creation de la carte
carte <- leaflet(arbres_wgs84) %>%
    addTiles() %>%
    addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        radius = 3,
        color = ~couleur,
        stroke = FALSE,
        fillOpacity = 0.7
    ) %>%
    addLegend(
        position = "bottomright",
        colors = c("blue", "green", "orange", "red", "yellow"),
        labels = c(
            "Arbre jeune",
            "Arbre adulte",
            "Arbre vieux",
            "Arbre senescent",
            "Aucune données du développement"
        ),
        title = "Type d'arbre"
    )
print(carte)

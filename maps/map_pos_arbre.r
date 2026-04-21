library(sf)
library(leaflet)

chemin_csv <- "projet_ia_web_bd/data/Data_Arbre_Clean.csv"
if (!file.exists(chemin_csv)) {
    chemin_csv <- "../data/Data_Arbre_Clean.csv"
}
data <- read.csv(chemin_csv)

# Classification simple des arbres
# Vert   : arbre en place et associe a un quartier
# Jaune  : arbre en place mais sans quartier
# Rouge  : arbre coupe, absent ou non en place
data$couleur <- "red"

data$couleur[
    data$fk_arb_etat == "EN PLACE" &
    !is.na(data$clc_quartier) &
    data$clc_quartier != ""
] <- "green"

data$couleur[
    data$fk_arb_etat == "EN PLACE" &
    (is.na(data$clc_quartier) | data$clc_quartier == "")
] <- "orange"

# texte pour legende
data$categorie <- "Arbre coupe ou absent"
data$categorie[data$couleur == "green"] <- "Arbre declare dans un quartier"
data$categorie[data$couleur == "orange"] <- "Arbre sans quartier"

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
        colors = c("green", "orange", "red"),
        labels = c(
            "Declare dans un quartier",
            "Sans quartier",
            "Coupe ou absent"
        ),
        title = "Type d'arbre"
    )
print(carte)
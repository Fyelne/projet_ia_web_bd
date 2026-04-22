library(sf)
library(leaflet)

data <- read.csv("projet_ia_web_bd/data/Data_Arbre_Clean.csv")

# On garde seulement les arbres remarquables
arbres_remarquables <- data[
    !is.na(data$remarquable) & data$remarquable == TRUE,
]
arbres_remarquables <- arbres_remarquables[
    !is.na(arbres_remarquables$X) & !is.na(arbres_remarquables$Y),
]

# Conversion des coordonnées pour la carte
arbres_sf <- st_as_sf(arbres_remarquables, coords = c("X", "Y"), crs = 3949)
arbres_wgs84 <- st_transform(arbres_sf, 4326)

coords <- st_coordinates(arbres_wgs84)
arbres_wgs84$lon <- coords[, 1]
arbres_wgs84$lat <- coords[, 2]

# Création de la carte
carte <- leaflet(arbres_wgs84) %>%
    addTiles() %>%
    addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        radius = 4,
        color = "#ff0000",
        stroke = FALSE,
        fillOpacity = 0.8
    ) %>%
    addLegend(
        position = "bottomright",
        colors = "ff0000",
        labels = "Arbre remarquable",
        title = "Type d'arbre"
    )
print(carte)

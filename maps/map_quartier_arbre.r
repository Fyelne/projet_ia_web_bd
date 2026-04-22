library(sf)
library(leaflet)

data <- read.csv("projet_ia_web_bd/data/Data_Arbre_Clean.csv")
data <- data[!is.na(data$X) & !is.na(data$Y), ]

# Classification des arbres par quartier
data$categorie <- data$clc_quartier
data$categorie[is.na(data$categorie) | data$categorie == ""] <- "Sans quartier"

quartiers <- sort(unique(data$categorie))
palette_base <- c(
    "red",
    "blue",
    "green",
    "yellow",
    "orange",
    "purple",
    "cyan",
    "magenta"
)
palette_quartiers <- setNames(
    rep(palette_base, length.out = length(quartiers)),
    quartiers
)

data$couleur <- unname(palette_quartiers[data$categorie])

# Conversion des coordonnées vers le format des cartes web
arbres_sf <- st_as_sf(data, coords = c("X", "Y"), crs = 3949)
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
        radius = 3,
        color = ~couleur,
        stroke = FALSE,
        fillOpacity = 0.7
    ) %>%
    addLegend(
        position = "bottomright",
        colors = unname(palette_quartiers),
        labels = names(palette_quartiers),
        title = "Quartiers"
    )
print(carte)

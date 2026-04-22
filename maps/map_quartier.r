library(sf) # Pour la manipulation de données géographiques
library(leaflet) # Pour la création de cartes interactives

data <- read.csv("projet_ia_web_bd/data/Data_Arbre_Clean.csv")

# Les coordonnées X et Y sont deja nettoyées
# On garde les lignes avec coordonnées, puis on compte a part celles sans quartier
arbres <- data %>%
    filter(!is.na(X), !is.na(Y))

nb_sans_quartier <- arbres %>%
    filter(is.na(clc_quartier) | clc_quartier == "") %>%
    nrow()

arbres_avec_quartier <- arbres %>%
    filter(!is.na(clc_quartier), clc_quartier != "")

# Conversion des coordonnées vers un format compatible avec OpenStreetMap.
arbres_sf <- st_as_sf(arbres_avec_quartier, coords = c("X", "Y"), crs = 3949)
arbres_wgs84 <- st_transform(arbres_sf, 4326)

# On compte les arbres par quartier, puis on calcule un point central
quartiers <- arbres_wgs84 %>%
    group_by(clc_quartier) %>%
    summarise(nombre_arbres = n()) %>%
    st_centroid()

coords <- st_coordinates(quartiers)
quartiers$lon <- coords[, 1]
quartiers$lat <- coords[, 2]

# Création de la carte
carte <- leaflet(quartiers) %>%
    addTiles() %>%
    addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        radius = ~sqrt(nombre_arbres) / 2,
        color = "darkred",
        fillColor = "red",
        fillOpacity = 0.7,
        popup = ~paste0(clc_quartier, " : ", nombre_arbres, " arbres")
    ) %>%
    addControl(
        html = paste0("Arbres sans quartier : ", nb_sans_quartier),
        position = "topright"
    )

print(carte)

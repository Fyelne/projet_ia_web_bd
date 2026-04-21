library(sf) # Pour la manipulation de données géographiques
library(leaflet) # Pour la création de cartes interactives

chemin_csv <- "projet_ia_web_bd/data/Data_Arbre_Clean.csv"
if (!file.exists(chemin_csv)) {
    chemin_csv <- "../data/Data_Arbre_Clean.csv"
}
data <- read.csv(chemin_csv)

# Les coordonnées X et Y sont deja nettoyées.
# On garde les lignes avec coordonnées, puis on compte a part celles sans secteur.
arbres <- data %>%
    filter(!is.na(X), !is.na(Y))

nb_sans_secteur <- arbres %>%
    filter(is.na(clc_secteur) | clc_secteur == "") %>%
    nrow()

arbres_avec_secteur <- arbres %>%
    filter(!is.na(clc_secteur), clc_secteur != "")

# Conversion des coordonnées vers un format compatible avec OpenStreetMap.
arbres_sf <- st_as_sf(arbres_avec_secteur, coords = c("X", "Y"), crs = 3949)
arbres_wgs84 <- st_transform(arbres_sf, 4326)

# On compte les arbres par secteur, puis on calcule un point central.
secteurs <- arbres_wgs84 %>%
    group_by(clc_secteur) %>%
    summarise(nombre_arbres = n()) %>%
    st_centroid()

coords <- st_coordinates(secteurs)
secteurs$lon <- coords[, 1]
secteurs$lat <- coords[, 2]

# Creation de la carte.
carte <- leaflet(secteurs) %>%
    addTiles() %>%
    addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        radius = ~sqrt(nombre_arbres) / 2,
        color = "darkred",
        fillColor = "red",
        fillOpacity = 0.7,
        popup = ~paste0(clc_secteur, " : ", nombre_arbres, " arbres")
    ) %>%
    addControl(
        html = paste0("Arbres sans secteur : ", nb_sans_secteur),
        position = "topright"
    )

print(carte)

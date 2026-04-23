# =========================
# PROJET IA - CLUSTERING ARBRES
# =========================

from pathlib import Path
import pandas as pd
import numpy as np

# Machine Learning
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans

# Conversion coordonnées (GPS)
from pyproj import Transformer

# Visualisation
import plotly.express as px

import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning)
# =========================
# 1. CHARGEMENT DES DONNÉES
# =========================

csv_path = Path(__file__).resolve().parents[2] / "data" / "Data_Arbre_Clean.csv"
data = pd.read_csv(csv_path)

# =========================
# 2. NETTOYAGE DES DONNÉES
# =========================

# On garde uniquement les colonnes utiles
data = data[['haut_tot', 'tronc_diam', 'X', 'Y']]

# Suppression des valeurs manquantes
data = data.dropna()

# Suppression des valeurs incohérentes (arbres inexistants)
data = data[(data['haut_tot'] > 0) & (data['tronc_diam'] > 0)]

# =========================
# 3. CLUSTERING (IA NON SUPERVISÉE)
# =========================

# Variables utilisées pour le clustering
X = data[['haut_tot', 'tronc_diam']].copy()

# Normalisation (important pour KMeans)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Modèle KMeans
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X_scaled)

# Ajout des clusters dans le dataset
data = data.loc[X.index].copy()
data['cluster'] = clusters

# =========================
# 4. CONVERSION EN COORDONNÉES GPS
# =========================
print("X min/max :", data["X"].min(), data["X"].max())
print("Y min/max :", data["Y"].min(), data["Y"].max())
# Les données sont en Lambert 93 (EPSG:2154)
# On les convertit en latitude / longitude (EPSG:4326)

transformer = Transformer.from_crs("EPSG:3949", "EPSG:4326", always_xy=True)

lon, lat = transformer.transform(data["X"].values, data["Y"].values)

data["lon"] = lon
data["lat"] = lat

# =========================
# 5. VISUALISATION SUR CARTE
# =========================

'''fig = px.scatter_mapbox(
    data,
    lat="lat",
    lon="lon",
    color="cluster",
    zoom=12,
    title="Carte des arbres par taille (Clustering IA)"
)

# Fond de carte OpenStreetMap
fig.update_layout(mapbox_style="open-street-map")

fig.show()'''

# =========================
# 5. VISUALISATION SUR CARTE (AMÉLIORÉE)
# =========================

fig = px.scatter_mapbox(
    data,
    lat="lat",
    lon="lon",
    color="cluster",

    # 👇 meilleure lisibilité
    opacity=0.6,
    size_max=6,

    # 👇 infos au survol
    hover_data={
        "haut_tot": True,
        "tronc_diam": True,
        "cluster": True,
        "lat": False,
        "lon": False
    },

    title="Carte des arbres par taille"
)

# =========================
# STYLE DE CARTE
# =========================

fig.update_layout(
    mapbox_style="open-street-map",
    margin={"r":0,"t":40,"l":0,"b":0},

    # 👇 centre automatique sur tes données
    mapbox=dict(
        center=dict(
            lat=data["lat"].mean(),
            lon=data["lon"].mean()
        ),
        zoom=13
    )
)

fig.show()
# =========================
# 6. AFFICHAGE RAPIDE DES RÉSULTATS
# =========================

print("Aperçu des données finales :")
print(data[['haut_tot', 'tronc_diam', 'cluster', 'lat', 'lon']].head())
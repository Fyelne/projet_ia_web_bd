from pathlib import Path
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from pyproj import Transformer
import plotly.express as px

# Suppresion des erreurs n'empêchant pas l'exécution
import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning)


''' CHARGEMENT DES DONNÉES '''
csv_path = Path(__file__).resolve().parents[2] / "data" / "Data_Arbre_Clean.csv"
data = pd.read_csv(csv_path)


''' NETTOYAGE DES DONNÉES '''
# Colonnes utiles uniquement
data = data[['haut_tot', 'X', 'Y']]

# Suppression des valeurs manquantes et incohérentes
data = data.dropna()
data = data[(data['haut_tot'] > 0)]


''' CLUSTERING (IA NON SUPERVISÉE) '''

# Variables utilisées
X = data[['haut_tot']]

# Normalisation
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Modèle KMeans
kmeans = KMeans(n_clusters=2, random_state=42, n_init=10)
data['cluster'] = kmeans.fit_predict(X_scaled)

# Inversion des clusters pour avoir :
# 1 = petit arbre, 0 = grand arbre
data['cluster'] = 1 - data['cluster']


''' CONVERSION EN COORDONNÉES GPS'''
# Projection locale → GPS (WGS84)
transformer = Transformer.from_crs("EPSG:3949", "EPSG:4326", always_xy=True)
lon, lat = transformer.transform(data["X"].values, data["Y"].values)
data["lon"] = lon
data["lat"] = lat


''' VISUALISATION'''
fig = px.scatter_mapbox(
    data,
    lat="lat",
    lon="lon",
    color="cluster",
    opacity=0.6,
    zoom=12,
    title="Carte des arbres - Clustering par taille",
    hover_data={
        "haut_tot": True
    }
)

fig.update_layout(mapbox_style="open-street-map")
fig.show()

''' AFFICHAGE DES CLUSTERS '''
print(data[['haut_tot', 'cluster']].head())
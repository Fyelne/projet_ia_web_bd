from pathlib import Path
import pandas as pd
from sklearn.cluster import KMeans
from pyproj import Transformer
import plotly.express as px
from sklearn.metrics import silhouette_score, calinski_harabasz_score, davies_bouldin_score
import joblib

# Suppresion des erreurs n'empêchant pas l'exécution
import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning)


''' CHARGEMENT DES DONNÉES '''
csv_path = Path(__file__).resolve().parents[2] / "data" / "Data_Arbre_Clean.csv"
data = pd.read_csv(csv_path)


''' NETTOYAGE DES DONNÉES '''
data = data[['haut_tot', 'X', 'Y']]

# Suppression des valeurs manquantes et incohérentes
data = data.dropna()
data = data[(data['haut_tot'] > 0)]


''' CLUSTERING (IA NON SUPERVISÉE) '''
# Variables utilisées
X = data[['haut_tot']]

# Pas de normalisation (1 seule variable, hauteur)

# Modèle KMeans
while True: 
    try:
        k = int(input("\nChoisir le nombre de clusters (2 ou 3) : "))
        if k in [2, 3]:
            break
        else:
            print("Veuillez entrer 2 ou 3.")
    except ValueError:
        print("Veuillez entrer un nombre valide.")

kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
data['cluster'] = kmeans.fit_predict(X)


''' TRI DES CLUSTERS ET MAPPING '''
# Trier les clusters selon la hauteur moyenne
cluster_means = data.groupby('cluster')['haut_tot'].mean()
sorted_clusters = cluster_means.sort_values().index.tolist()

# Mapping automatique (du plus petit au plus grand)
mapping = {old: new for new, old in enumerate(sorted_clusters)}

# Sauvegarde du mapping pour la prédiction
joblib.dump(mapping, "mapping_clusters.pkl")
data['cluster'] = data['cluster'].map(mapping)

# Attribution des noms
if k == 2:
    labels = {0: "Petit", 1: "Grand"}
elif k == 3:
    labels = {0: "Petit", 1: "Moyen", 2: "Grand"}
data['type_arbre'] = data['cluster'].map(labels)


''' AFFICHAGE DES CLUSTERS '''
print("\nDonnées des clusters :")
print(data[['haut_tot', 'cluster', 'type_arbre']].head())


''' ÉVALUATION DU CLUSTERING '''
# Silhouette Coefficient
silhouette = silhouette_score(X, data['cluster'])

# Calinski-Harabasz Index (plus grand = meilleur)
calinski = calinski_harabasz_score(X, data['cluster'])

# Davies-Bouldin Index (plus petit = meilleur)
davies = davies_bouldin_score(X, data['cluster'])

print("\nÉvaluation du clustering :")
print("Silhouette Coefficient :", silhouette)
print("Calinski-Harabasz Index :", calinski)
print("Davies-Bouldin Index :", davies)

# Sauvegarde du modèle
joblib.dump(kmeans, "modele_kmeans.pkl")
print("\nModèle sauvegardé")


''' CONVERSION EN COORDONNÉES GPS'''
# Projection locale -> GPS (WGS84)
transformer = Transformer.from_crs("EPSG:3949", "EPSG:4326", always_xy=True)
lon, lat = transformer.transform(data["X"].values, data["Y"].values)
data["lon"] = lon
data["lat"] = lat


''' VISUALISATION'''
fig = px.scatter_map(
    data,
    lat="lat",
    lon="lon",
    color="type_arbre",   # affichage Petit / Moyen / Grand
    text="type_arbre",    # affichage écrit sur la carte
    opacity=0.6,
    zoom=12,
    title="Carte des arbres - Clustering par taille",
    hover_data={
        "haut_tot": True,
        "cluster": True,
        "type_arbre": True
    }
)

fig.update_layout(map_style="open-street-map")
fig.show()




''' ANALYSE DES CLUSTERS '''
stats = data.groupby('cluster')['haut_tot'].agg(['count', 'min', 'max', 'mean'])

# Renommage des colonnes
stats.columns = ['Nombre_arbres', 'Minimum', 'Maximum', 'Moyenne']

# Ajout du nom de cluster (Petit / Moyen / Grand)
stats['Type_arbre'] = stats.index.map(labels)

print("\nStatistiques par cluster :")
print(stats)
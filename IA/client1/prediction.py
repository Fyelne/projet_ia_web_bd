import joblib
import numpy as np
import pandas as pd

# Suppresion des erreurs n'empêchant pas l'exécution
import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning)

# Charger modèle + scaler
kmeans = joblib.load("modele_kmeans.pkl")
scaler = joblib.load("scaler.pkl")

# Charger le mapping des clusters
mapping = joblib.load("mapping_clusters.pkl")

# Charger le nombre de clusters utilisé
k = kmeans.n_clusters

# Entrée utilisateur
haut_tot = float(input("Hauteur de l'arbre : "))

# Création d'un DataFrame avec le même nom de colonne qu'à l'entraînement
X_new = pd.DataFrame([[haut_tot]], columns=["haut_tot"])

# Normalisation
X_new_scaled = scaler.transform(X_new)

# Prédiction
cluster = kmeans.predict(X_new_scaled)

# Appliquer le mapping pour avoir le bon ordre (petit → grand)
cluster = [mapping[c] for c in cluster]

# Attribution des noms selon k
if k == 2:
    labels = {0: "Petit", 1: "Grand"}
elif k == 3:
    labels = {0: "Petit", 1: "Moyen", 2: "Grand"}

type_arbre = labels.get(cluster[0], "Inconnu")

print("Cluster :", cluster[0])
print("Type d'arbre :", type_arbre)
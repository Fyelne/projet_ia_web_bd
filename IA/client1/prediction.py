import joblib
import numpy as np

# Charger modèle + scaler
kmeans = joblib.load("modele_kmeans.pkl")
scaler = joblib.load("scaler.pkl")

# Entrée utilisateur
haut_tot = float(input("Hauteur de l'arbre : "))

# Création d'un DataFrame avec le même nom de colonne qu'à l'entraînement
X_new = pd.DataFrame([[haut_tot]], columns=["haut_tot"])

# Normalisation
X_new_scaled = scaler.transform(X_new)

# Prédiction
cluster = kmeans.predict(X_new_scaled)

print("Cluster de l'arbre :", cluster[0])
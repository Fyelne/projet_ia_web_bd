import joblib
import numpy as np
import pandas as pd

# Suppresion des erreurs n'empêchant pas l'exécution
import warnings

"""
Script du groupe de taille (Besoin Client 1)

Exemple :
    python script.py --haut_tot 12.0 --nb_clusters 3
"""

import argparse
import pandas as pd
import joblib
import os
import sys
import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning)


def load_file(path):
    if not os.path.exists(path):
        print(f"Fichier introuvable : {path}")
        sys.exit(1)
    return joblib.load(path)


def main():
    parser = argparse.ArgumentParser(
        description="Prédit l'âge estimé d'un arbre"
    )
    parser.add_argument('--haut_tot',     type=float, required=True,  help='Hauteur totale (m)')
    parser.add_argument('--nb_clusters',  type=str,   required=False,  choices=["2", "3"], default="3",
                        help='Nombre de clusters (2 -> [Petit, Grand], 3 -> [Petit, Moyen, Grand])')
    args = parser.parse_args()

    # Construction du DataFrame
    X_new = pd.DataFrame([{
        'haut_tot'    : args.haut_tot,
    }])

    # Charger modèle
    kmeans = joblib.load(f"modele_kmeans_{args.nb_clusters}.pkl")

    # Charger le mapping des clusters
    mapping = joblib.load(f"mapping_clusters_{args.nb_clusters}.pkl")

    # Charger le nombre de clusters utilisé
    k = kmeans.n_clusters

    # Prédiction
    cluster = kmeans.predict(X_new)

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



if __name__ == '__main__':
    main()
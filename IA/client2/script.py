"""
Script de prédiction de l'âge d'un arbre (Besoin Client 2)

Exemple :
    python script.py --haut_tot 12.0  --haut_tronc 2.5 --tronc_diam 150 --fk_stadedev adulte \
    --nomlatin TILCOR
"""

import argparse
import pandas as pd
import joblib
import os
import sys


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
    parser.add_argument('--haut_tronc',   type=float, required=True,  help='Hauteur du tronc (m)')
    parser.add_argument('--tronc_diam',   type=float, required=True,  help='Diamètre du tronc (cm)')
    parser.add_argument('--fk_stadedev',  type=str,   required=True,
                        choices=['jeune', 'adulte', 'vieux', 'senescent'], 
                        help='Stade de developpement de l\'arbre')
    parser.add_argument('--nomlatin', type=str, required=False, default='TILCOR', 
                        help='Nom latin de l\'arbre')
    args = parser.parse_args()

    # Chargement du modèle

    # Construction du DataFrame
    arbre = pd.DataFrame([{
        'haut_tot'    : args.haut_tot,
        'haut_tronc'  : args.haut_tronc,
        'tronc_diam'  : args.tronc_diam,
        'fk_stadedev' : args.fk_stadedev,
        'nomlatin'    : args.nomlatin,
    }])

    # diam haut ratio
    arbre['diam_haut_ratio'] = arbre['tronc_diam'] / arbre['haut_tot']

    # Application des transformations (dans le même ordre que le notebook)
    model = joblib.load('model_age_classification.pkl')
    prediction = model.predict(arbre)[0]

    print(f"Hauteur totale : {args.haut_tot} m")
    print(f"Hauteur du tronc : {args.haut_tronc} m")
    print(f"Diamètre du tronc : {args.tronc_diam} cm")
    print(f"Stade développement : {args.fk_stadedev}")
    print(f"Nom latin : {args.nomlatin}")
    print()
    print(f"Age estimé prédit : {prediction}")


if __name__ == '__main__':
    main()
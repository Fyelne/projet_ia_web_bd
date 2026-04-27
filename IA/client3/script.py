"""
Script de prédiction du risque de déracinement lors d'une tempête (Besoin Client 3)

Exemple :
    python script.py --haut_tot 2.3 --haut_tronc 1.1 --tronc_diam 4.6 --age_estim 3.4 \
      --fk_port "semi libre" --fk_pied gazon --nomfrancais POPALB \
      --clc_quartier HARLY --clc_secteur "Rue Laplace"
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
    parser.add_argument('--haut_tot', type=float, required=True,  help='Hauteur totale (m)')
    parser.add_argument('--haut_tronc', type=float, required=True,  help='Hauteur du tronc (m)')
    parser.add_argument('--tronc_diam', type=float, required=True,  help='Diamètre du tronc (cm)')
    parser.add_argument('--age_estim', type=float, required=True,  help='Age estimé (ans)')
    parser.add_argument('--fk_port', type=str,   required=True, help="Port de l'arbre")
    parser.add_argument('--fk_pied', type=str,   required=True, help="Pied de l'arbre")
    parser.add_argument('--nomfrancais', type=str, required=True, help="Nom français de l'arbre")
    parser.add_argument('--clc_quartier', type=str, required=True, help="Quartier de l'arbre")
    parser.add_argument('--clc_secteur', type=str, required=True, help="Secteur de l'arbre")
    parser.add_argument('--x', type=float, required=False, default=14.358525,
                        help="Coordonnées X de l'arbre")
    parser.add_argument('--y', type=float, required=False, default=15.93114,
                        help="Coordonnées Y de l'arbre")
    parser.add_argument('--seuil', type=float, required=False, default=0.2, help="Seuil de risque")
    args = parser.parse_args()

    # Construction du DataFrame
    arbre = pd.DataFrame([{
        'tronc_diam'  : args.tronc_diam,
        'haut_tot'    : args.haut_tot,
        'haut_tronc'  : args.haut_tronc,
        'age_estim'   : args.age_estim,
        'fk_port'     : args.fk_port,
        'fk_pied'     : args.fk_pied,
        'nomfrancais' : args.nomfrancais,
        'clc_quartier': args.clc_quartier,
        'clc_secteur' : args.clc_secteur,
        'X'           : args.x,
        'Y'           : args.y
    }])

    # Application des transformations (dans le même ordre que le notebook)
    model = joblib.load('modele_tempete.pkl')
    proba = model.predict_proba(arbre)[0, 1]

    if proba >= args.seuil:
      print(f'Risque de déracinement par tempête (p={proba:.2f})')
    else:
      print(f'Arbre sans risque pour tempête (p={proba:.2f})')

if __name__ == '__main__':
    main()
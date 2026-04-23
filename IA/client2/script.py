"""
Script de prédiction de l'âge d'un arbre (Besoin Client 2)

Exemple :
  python script.py --haut_tot 12.0  --haut_tronc 2.5 --tronc_diam 150 --fk_stadedev adulte \
    --fk_situation Alignement --feuillage Feuillu --fk_port "réduit relâché" --clc_nbr_diag 2
"""

import argparse
import pandas as pd
import joblib
import os
import sys

col_num = ['haut_tot', 'haut_tronc', 'tronc_diam']
col_qual = ['fk_stadedev', 'fk_situation', 'feuillage', 'fk_port', 'clc_nbr_diag']


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
                        choices=['jeune', 'adulte', 'vieux', 'senescent'])
    parser.add_argument('--fk_situation', type=str,   required=False, default='Alignement',
                        choices=['Alignement', 'Groupe', 'Isolé'])
    parser.add_argument('--feuillage',    type=str,   required=False, default='Feuillu',
                        choices=['Feuillu', 'Conifère'])
    parser.add_argument('--fk_port',      type=str,   required=False, default='semi libre',
                        help='Ex: "semi libre", "libre", "réduit"')
    parser.add_argument('--clc_nbr_diag', type=int,   required=False, default=0,
                        help='Nombre de diagnostics effectués sur l\'arbre')
    args = parser.parse_args()

    # Chargement du modèle

    # Construction du DataFrame
    arbre = pd.DataFrame([{
        'haut_tot'    : args.haut_tot,
        'haut_tronc'  : args.haut_tronc,
        'tronc_diam'  : args.tronc_diam,
        'fk_stadedev' : args.fk_stadedev,
        'fk_situation': args.fk_situation,
        'feuillage'   : args.feuillage,
        'fk_port'     : args.fk_port.lower().strip() if args.fk_port else None,
        'clc_nbr_diag': args.clc_nbr_diag
    }])

    # Application des transformations (dans le même ordre que le notebook)
    model = joblib.load('model_age_prediction.pkl')
    prediction = model.predict(arbre)[0]

    print(f"Hauteur totale : {args.haut_tot} m")
    print(f"Hauteur du tronc : {args.haut_tronc} m")
    print(f"Diamètre du tronc : {args.tronc_diam} cm")
    print(f"Stade développement : {args.fk_stadedev}")
    print(f"Situation : {args.fk_situation}")
    print(f"Feuillage : {args.feuillage}")
    print(f"Port : {args.fk_port}")
    print(f"Nombre de diagnostics : {args.clc_nbr_diag}")
    print()
    print(f"Age estimé prédit : {prediction:.1f} ans")


if __name__ == '__main__':
    main()
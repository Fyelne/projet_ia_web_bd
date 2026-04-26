# Projet IA

## Installation des packages

Se mettre à la racine du projet

```bash
pip install -r requirements.txt
```

## Documentation des scripts

Documentation du script (paramètres, valeurs)

```bash
cd IA/clientX
python script.py -h
```

### Client 1

Se déplacer dans le dossier client1

```bash
cd client1
```

#### Lancer la prédiction

Exemples:

```bash
# 2 Clusters
# Arbre petit
python script.py --haut_tot 10.0 --nb_clusters 2

# Arbre grand
python script.py --haut_tot 14.0 --nb_clusters 2


# 3 Clusters 
# Arbre petit
python script.py --haut_tot 10.0 --nb_clusters 3

# Arbre moyen
python script.py --haut_tot 14.0 --nb_clusters 3

# Arbre grand
python script.py --haut_tot 20.0 --nb_clusters 3
```

### Client 2

Se déplacer dans le dossier client2

```bash
cd client2
```

Exemples:

```bash
# Age estimé (Jeune 0-15)
python script.py --haut_tot 4.0  --haut_tronc 2.0 --tronc_diam 20 --fk_stadedev jeune --nomlatin PYRCAL

# Age estimé (Jeune Adulte 15-30)
python script.py --haut_tot 3.0  --haut_tronc 3.0 --tronc_diam 48 --fk_stadedev jeune --nomlatin BETPEN

# Age estimé (Adulte 30-50)
python script.py --haut_tot 12.0  --haut_tronc 2.5 --tronc_diam 150 --fk_stadedev adulte --nomlatin TILCOR

# Age estimé (Vieux 50+)
python script.py --haut_tot 27.0  --haut_tronc 12.0 --tronc_diam 310 --fk_stadedev adulte --nomlatin POPALB

# Seulement avec les valeurs requises
python script.py --haut_tot 12.0  --haut_tronc 2.5 --tronc_diam 150 --fk_stadedev adulte
```

### Client 3

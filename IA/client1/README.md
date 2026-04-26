# README – Projet IA (Clustering des arbres)

## 1. Lancer le programme principal

Fichier : taille_cluster.py

Commande dans le terminal :
python taille_cluster.py

Ce que fait le programme :
- Charge les données
- Nettoie les données
- Demande le nombre de clusters (2 ou 3)

Entrer :
2 → petit / grand
3 → petit / moyen / grand

Résultats :
- Tableau avec hauteur, cluster et type d’arbre
- Scores :
  - Silhouette → proche de 1 = bon
  - Calinski → grand = bon
  - Davies → petit = bon
- Carte avec les arbres (couleurs selon taille)
- Statistiques des clusters

Fichiers créés :
- modele_kmeans.pkl
- mapping_clusters.pkl


## 2. Lancer la prédiction

Fichier : prediction.py

Commande :
python prediction.py

Entrer une hauteur :
Exemple : 10

Résultat :
Cluster : numéro
Type d’arbre : Petit / Moyen / Grand


## Important

Toujours lancer d’abord :
python taille_cluster.py

Sinon la prédiction ne fonctionne pas.


## Résumé

- taille_cluster.py → analyse + carte + modèle
- prediction.py → prédiction d’un arbre

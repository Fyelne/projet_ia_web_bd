#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// Couleur principale
#let isen-red = rgb("#c43c2f")
#let gris = rgb("#7d7d7d")


#let title = "Projet - Big Data / IA / Web"
#let  subtitle = "Étude du patrimoine arboré"
#let  formation = "FISA4"
#let  author = "Ange Colsenet"
#let  email = "ange.colsenet@isen-ouest.yncrea.fr"

#set heading(numbering: "1.")
#show heading: set text(fill: isen-red)
#show heading: set block(below: 20pt)


// En-tete du début de document
#let En_tete_page() = {
  // Bloc principal
  grid(
    columns: (0.6fr, 0.6fr),
    // Logo 
    [
     #image("isen.jpg", width:50%)
    ],

    // Partie droite
    [
      #align(right)[
        #stack(
          [
            #text(size: 24pt, fill: gris)[#title]\
            #text(size: 18pt, style: "italic", fill: gris)[#subtitle]\
            #text(size: 10pt,fill: gris)[#author]\
            #text(size: 10pt,fill: gris)[Andy Noel]\
            #text(size: 10pt,fill: gris)[Cholan Scheers]\
           // #text(size: 10pt,fill: gris)[#email]
          ]
        )
      ]
    ]
  )

  // Ligne rouge basse
  rect(width: 100%, height: 1.5pt, fill: isen-red)
  }
// =====================
// Header
// =====================
#let isen-header = [
  // Ligne rouge haute
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    [
      #text(size: 12pt, fill: gris)[
        #title
      ]
    ],
    [
      #text(size: 12pt, fill: gris)[#formation]
    ]
  )

  #v(-7pt)

  #rect(width: 100%, height: 1.5pt, fill: isen-red)
]

// =====================
// Footer
// =====================
#let isen-footer = [
  #rect(width: 100%, height: 1.5pt, fill: isen-red)

  #grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),

    [
      #text(size: 9pt, fill: gray)[ISEN Ouest]
    ],

   [
      #context[
        #text(size: 9pt, fill: gray)[
          Page #counter(page).display() / #counter(page).final().first()
        ]
      ]
    ],

    [
      #text(size: 9pt, fill: gray)[#author]
    ]
  )
]

// =====================
// Configuration page
// =====================

#page(margin: 0pt)[
  #image("page_de_garde.png", width: 100%, height: 100%, fit: "stretch")

    // Texte par-dessus
  #place(top ,dx:0.5cm, dy: 15.5cm)[
    #text(size: 34pt,font: "Calibri", fill:white)[Projet - Big Data / IA / Web]
  ]

  #place(top ,dx:0.5cm, dy: 18.8cm)[
  #text(size: 18pt,font: "Calibri", fill:white)[Cholan Scheers\ Noel Andy\ Colsenet Ange CIPA4]
  ]
]



#set page(
  margin: (top:1.5cm,x: 2cm, y: 1.7cm),
  header: isen-header,
  footer: isen-footer,
  paper: "a4",
  fill : white
)

#set text(14pt)



#En_tete_page()

#v(1cm)

#outline(title: "Sommaire")

#set par(justify: true)


#pagebreak()

// =====================
// Contenu exemple
// =====================
#v(3cm)


#heading(numbering: none)[Introduction]

Ce rapport présente le projet de Big Data/IA/Web visant à 

Le projet porte sur le développement d’une application d’étude du patrimoine arboré de la ville de Saint-Quentin (Aisne).

Le travail est structuré en trois parties principales : Big Data, Intelligence Artificielle et Développement Web, chacune représentant un volume de travail équivalent. Bien que ces parties soient traitées de manière indépendante, elles contribuent toutes à une application globale cohérente.

#pagebreak()

#heading(numbering: none)[Partie Big Data : ]

#heading(numbering: none)[Rappel objectifs de la partie Big Data : ]
 - Extraction des données : à partir d’un fichier, d’un site web...
- Visualisation d’un grand volume de données
- Nettoyage des données : suppression des données incomplètes, suppression des données erronées
- Application de modèles statistiques pour l’analyse des données recueillies : régression linéaire et/ou
- régression linéaire multiple et/ou régression logistique, corrélation entre les caractéristiques

= Fonctionalité 1 : Description et exploration des données

Le jeu de données récupérer concerne le patrimoine arboré de la ville de Saint-Quentin (Aisne). 
\ Il est structuré de telle manière en colonne : 

#box(height: 45%)[
#columns(2)[
#text(size: 10pt)[
1. X, Y : Coordonnées géographiques des arbres en projection spécifique  
2. OBJECTID : Identifiant unique de l'enregistrement dans la base de données.  
3. created_date : Date et heure de création de l'enregistrement.  
4. created_user : Nom de l'utilisateur qui a créé l'enregistrement.  
5. src_geo : Source géographique des données (par exemple, Orthophoto).  
6. clc_quartier : Nom du quartier où se situe l'arbre.  
7. clc_secteur : Secteur spécifique du quartier.  
8. id_arbre : Identifiant spécifique de l'arbre.  
9. haut_tot : Hauteur totale de l'arbre (souvent en mètres).  
10. haut_tronc : Hauteur du tronc de l'arbre (souvent en mètres).  
11. tronc_diam : Diamètre du tronc de l'arbre (souvent en centimètres).  
12. fk_arb_etat : État de l'arbre (exemples : SUPPRIMÉ, ABATTU, etc.).  
13. fk_stadedev : Stade de développement de l'arbre.  
14. fk_port : Type de port de l'arbre.  
15. fk_pied : Type de pied de l'arbre.  
16. fk_situation : Situation de l'arbre (par exemple, Alignement).  
17. fk_revetement : Type de revêtement autour de l'arbre.  
18. commentaire_environnement : Commentaires sur l'environnement de l'arbre.  
19. dte_plantation : Date de plantation de l'arbre.  
20. age_estim : Âge estimé de l'arbre (souvent en années).  
21. fk_prec_estim : Précision de l'estimation de l'âge.  
22. clc_nbr_diag : Nombre de diagnostics effectués sur l'arbre.  
23. dte_abattage : Date d'abattage de l'arbre.  
24. fk_nomtech : Nom technique de l'arbre.  
25. last_edited_user : Nom de l'utilisateur ayant modifié l'enregistrement.  
26. last_edited_date : Date et heure de la dernière modification.  
27. villeca : Code de la ville.  
28. nomfrancais : Nom français de l'arbre.  
29. nomlatin : Nom latin de l'arbre.  
30. GlobalID : Identifiant global unique pour l'arbre.  
31. CreationDate : Date de création (format secondaire).  
32. Creator : Créateur de l'enregistrement.  
33. EditDate : Date de modification.  
34. Editor : Dernier éditeur.  
35. feuillage : Type de feuillage (caduque, persistante).  
36. remarquable : Arbre remarquable (Oui/Non)
]
]
]

#pagebreak()

Avant tout traitement sur le fichier nous avons choisis de conservé uniquement les colonnes intéressante et utile pour une représentation graphique. \ Ainsi nous travaillons avec ces colonnes : 

#box(height: 37%)[
  #columns(2)[

  #text(size: 10pt)[
  1. X, Y : Coordonnées géographiques des arbres  

  6. clc_quartier : Nom du quartier  
  7. clc_secteur : Secteur spécifique  
  8. id_arbre : Identifiant  
  9. haut_tot : Hauteur totale  
  10. haut_tronc : Hauteur du tronc  
  11. tronc_diam : Diamètre du tronc  
  12. fk_arb_etat : État de l'arbre  
  13. fk_stadedev : Stade de développement  
  ]

  #text(size: 10pt)[
  14. fk_port : Type de port  
  15. fk_pied : Type de pied  
  16. fk_situation : Situation  
  17. fk_revetement : Revêtement   
  19. dte_plantation : Date plantation  
  20. age_estim : Âge estimé  
  22. clc_nbr_diag : Diagnostics  
  23. dte_abattage : Abattage   
  27. villeca : Code ville  
  28. nomfrancais : Nom français  
  29. nomlatin : Nom latin  
  35. feuillage : Feuillage  
  36. remarquable : Remarquable  
  ]

  ]
]



Par la suite, nous avons filtré les doublons en nous basant sur les positions X et Y, ainsi que les données aberrantes (ex : un arbre « jeune » de 2000 ans), afin de pouvoir traiter les données.

#v(2cm)

Nous avons ensuite définie un diagramme de gantt afin de ce répartir les taches.

#figure(
  image("Gantt.png", width: 123%),
  caption: [
    Répartition des arbres selon leur quartier
  ]
)<fig:Gantt>

#pagebreak()

= Fonctionalité 2 : Visualisation des données via graphiques
#v(-0.3cm)
#figure(
  image("graph/graph_simple/arbre_vs_quartier.png", width: 90%),
  caption: [
    Répartition des arbres par quartier
  ]
)

En analysant l’histogramme, on observe une distribution hétérogène, la majorité des arbres sont concentrées dans les quartiers du Faubourg et de Rémicourt, tandis que les quartiers d’Harly et de Rouvroy présentent une densité arborée significativement plus faible.

#figure(
  image("graph/graph_simple/arbre_par_annee.png", width: 100%),
  caption: [
    Proportion arbre planter/abbattue par année
  ]
)
Le graphique montre que les plantations dépassent globalement les abattages jusqu’en 2016 (pic marqué), avant que la tendance s’inverse a partir de 2017 avec une forte baisse des abattages et plantation jusque 2020

#figure(
  image("graph/graph_simple/nb_arbre_fct_dev.png", width: 100%),
  caption: [
    Nombre d'arbre par age
  ]
)

Cette histogramme montre une forte proportion d’arbres adultes, tandis que les arbres jeunes sont moins nombreux et les arbres âgés restent très rares.

\

#figure(
  image("graph/graph_simple/espèce_par_quartier.png", width: 100%),
  caption: [
    Espèces principales par quartier avec moyenne d'age
  ]
)

Via ces graphique, nous pouvons voir que la majorité des arbres "jeune" de la villes (< 30ans) sont concentré dans le quartier Vermandois tandis que les arbres plus "vieux" (>50ans) sont majoritairement présente dans le quartier Remicourt ainsi que le centre-ville

#figure(
  image("graph/graph_simple/age_hauteur.png", width: 100%),
  caption: [
    Courbe lissé de la hauteur en fonction de l'age
  ]
)

Via ce graphique, on peut voir que la hauteur de l’arbre dépend de son âge. Néanmoins, les données ne sont pas très représentatives, étant donné que le fichier contient beaucoup plus d’arbres jeunes que d’arbres âgés.

#pagebreak()

= Fonctionnalité 3 : Visualisation des données sur une carte

*Répartition des arbres en fonction de leur développement :* \
Nous pouvons constater que la population des arbres est plutôt jeune ou adulte. Cela permet de se rendre compte de la politique récente de plantation d'arbre de la ville.

#figure(
  image("graph/carte/arbre_fct_dev.png", width: 75%),
  caption: [
    Répartition des arbres en fonction de leur développement
  ]
)

*Répartition des arbres en fonction des rues où ils sont plantés: *\
Les arbres sont répartis sur l'ensemble du territoire de la ville. Cependant, la zone dans le Sud / Sud-Ouest indique un manque d'arbre assez conséquent comparé au reste de la ville. Cela pourrait indiquer un manquement de plantation récent ou alors un manque d'étude du secteur

#figure(
  image("graph/carte/arbre_fct_rue.png", width: 80%),
  caption: [
    Répartition des arbres en fonction des rues où ils sont plantés
  ]
)


*Répartition des arbres par quartier : * \
On peut voir comment sont répartis les arbres par quartier, en voyant que plus le point est gros, plus le quartier possède d'arbres. En mettant en commun avec les autres cartes, on peut voir que dans la zone industrielle du sud, il n'y a pas de point de quartier car les arbres n'ont pas été affecté. Le nombre d'arbre sans quartier apparaît en haut à droite de la carte.

#figure(
  image("graph/carte/arbre_par_quartier.png", width: 75%),
  caption: [
    Répartition des arbres par quartier
  ]
)



*Répartition des arbres en fonction de leur déclaration de quartier :* \
Affichage des arbres selon leur affectation de quartier et leur état d’abattage. Deux zones présentent des arbres sans quartier renseigné : le sud (zone industrielle) et le nord (Gricourt), possiblement dû à des ajouts récents ou à un recensement moins rigoureux.

#figure(
  image("graph/carte/arbre_decl_quartier.png", width: 73%),
  caption: [
    Répartition des arbres en fonction de leur déclaration de quartier
  ]
)

*Répartition des arbres exceptionnels :* \
Grâce à cet affichage, on peut voir que les arbres exceptionnels sont principalement dans le parc des Champs Élysées.

#figure(
  image("graph/carte/arbre_exceptionel.png", width: 80%),
  caption: [
    Répartition des arbres exceptionnels 
  ]
)

*Répartition des arbres selon leur quartier* \
Une carte permettant de visualiser les différents quartiers grâce à la plantation des arbres et de leur déclaration.

#figure(
  image("graph/carte/arbre_par_quartier_color.png", width: 80%),
  caption: [
    Répartition des arbres selon leur quartier
  ]
)<fig:arbres_quartier>
En représentant les arbres de Saint-Quentin par quartier, on voit qu'il sont répartis de façon hétérogène sur le territoire et arrangé généralement de facon a être aligné.

#pagebreak()


= Fonctionnalité 4 : Etude des corrélations \ entre variables

*Variable pour l'estimation de l'age d'un arbre :*

Pour essayé d'estimer l'age d'un arbre nous allon utilisé ça taille ainsi que sont diamètre

#figure(
  image("graph/partie_4/fig_age_diametre.png", width: 75%),
  caption: [
    Corrélation entre l'age et le diamètre d'un tronc d'arbre
  ]
)

#figure(
  image("graph/partie_4/fig_age_hauteur.png", width: 75%),
  caption: [
        Corrélation entre l'age et la hauteur d'un arbre
  ]
)

\ 

On observe une forte *corrélation positive (r=0.776) entre le diamètre du tronc et l'age estimé*, c'est le prédicteur le plus fiable de l'age. La progression semble assez linéaire, bien que la dispersion augmente beaucoup sur les arbres très agé (> 100ans)
Pour *la corrélation de la hauteur la corrélation est plus modérée (r=0.555)*, on remarque un plafond de nombreux arbres atteignent une hauteur maximale à partir de 25m. La dispersion reste très importante ce qui le rend moins intéressant en tant que prédicteur seul.

== Analyse Bivariée 
Une étude bivarié a été réalisé pour permettre de visualiser l’influence de certaines caractéristiques des arbres sur leur âge estimé.


#figure(
  image("graph/output/correlation/fig_boxplot_age_stadedev.png", width: 75%),
  caption: [
        Age de l'arbre selon sont stade de devellopement
  ]
)

#figure(
  image("graph/output/correlation/fig_boxplot_age_situation.png", width: 75%),
  caption: [
        Age estimé selon la situation de l'arbre
  ]
)

#figure(
  image("graph/output/correlation/fig_violon_age_feuillage.png", width: 75%),
  caption: [
        Age estimé selon le type de feuillage
  ]
)

#pagebreak()

== Étude des relations entre variables qualitatives

Afin d’analyser les dépendances entre variables qualitatives, des tableaux croisés ont été réalisés.

#align(center)[*Stade de développement ~ Feuillage :*]

#let color_surlign = rgb("#ff7d7d")
#let color_surlign2 = rgb("#ffce3d")

#align(center)[
#table(
  columns: 3,
  [ ], [Conifère], [Feuillu],
  [jeune], [399], [2757],
  [adulte], [979], [#table.cell(fill:color_surlign)[5055]],
  [vieux], [1], [67],
  [senescent], [0], [53]
)
]
\

#align(center)[*Situation ~ Feuillage :*]

#align(center)[
#table(
  columns: 3,
  [ ], [Conifère], [Feuillu],
  [Alignement], [285], [#table.cell(fill:color_surlign)[5189]],
  [Groupe], [1124], [2661],
  [Isolé], [173], [815]
)
]
\

#align(center)[*Situation ~ Remarquable :*]

#align(center)[
#table(
  columns: 3,
  [ ], [FALSE], [TRUE],
  [Alignement], [5582], [#table.cell(fill:color_surlign2)[35]],
  [Groupe], [3737], [#table.cell(fill:color_surlign2)[63]],
  [Isolé], [983], [#table.cell(fill:color_surlign2)[12]]
)
]


*Analyse :*

Les tableaux croisés montrent plusieurs tendances :

- Les arbres feuillus sont largement majoritaires quel que soit le stade de développement  
- Les arbres adultes dominent fortement la population  
- Les arbres en alignement sont les plus nombreux  
- Les arbres remarquables sont très rares, quelle que soit la situation  

Ces résultats permettent de mieux comprendre la structure du jeu de données et confirment un fort déséquilibre entre certaines modalités.

== tests d’indépendance du chi2 sur les tableaux entre les \ différentes variables  :


#figure(
  image("graph/output/correlation/fig_chi2_situation_feuillage.png", width: 75%),
  caption: [
        Mosaicplot : Situation - Feuillage
  ]
)

On remarque que la population des arbres feuillus est bien plus grandes que celle des conifères quel que soit la situation. Cela se remarque particulièrement dans les alignements alors que la situation de groupe est plus homogène. Cela illustre bien la paysage urbain qui est plus souvent composé d'arbres à feuilles dans les rues et plus diversifiés dans les parcs où les arbres sont plus regroupés


#figure(
  image("graph/partie_4/fig_correlations_numeriques.png", width: 75%),
  caption: [
        Matrice de corrélation
  ]
)

A partir de cette matrice de corrélation on peut remarquer que l'age se déduit principalement par le diamètre de son tronc et aussi à partir de sa hateur totale et de son tronc. On retrouve aussi d'autre valeur cohérente comme le fait que le diamètre d'un trou semble correler avec sa hauteur.


= Fonctionnalité 5 : Etude des corrélations entre variables

*La ville a une politique urbaine qui consiste à planter des nouveaux arbres. \
\
➢ Dans quelle zone faut-il les planter pour harmoniser le développement global
de la ville ? *

D’après la figure @fig:arbres_quartier, on observe qu’un quartier entier de la ville ne présente aucune donnée relative aux arbres. Afin d’harmoniser le développement urbain, il serait donc pertinent de privilégier des plantations dans le sud / sud-est de la ville, notamment du côté de Gauchy, au-dessus de la zone industrielle Le Royaux, où aucun arbre n’a été recensé.

#pagebreak()

#v(0.3cm)


== Régression linéaire — Prédiction de l'âge des arbres

On souhaite prédire l'âge estimé d'un arbre à partir de ses
caractéristiques physiques et biologiques via une régression linéaire multiple.

=== 1. Variable cible

$
"age_estim" = beta_0 + beta_1 "tronc_diam" + beta_2 "haut_tot" \
+ beta_3 "fk_stadedev" + beta_4 "fk_situation" + \ beta_5 "feuillage"
+ epsilon
$

où $epsilon$ désigne le terme d'erreur (résidus).

=== 2. Données utilisées

- `tronc_diam` — diamètre du tronc
- `haut_tot` — hauteur totale
- `fk_stadedev` — stade de développement _(catégorielle)_
- `fk_situation` — situation de l'arbre _(catégorielle)_
- `feuillage` — type de feuillage _(catégorielle)_

Valeurs manquantes supprimées — *9 296 observations* retenues.

=== 3. Coefficients estimés

#table(
  columns: (auto, auto),
  align: (left, right),
  table.header([*Variable*], [*Coefficient*]),
  [Intercept],      [-1.234],
  [`tronc_diam`],   [+0.177],
  [`haut_tot`],     [+0.158],
)

*Interprétation des coefficients :*

- *Diamètre du tronc* (`tronc_diam`, $beta_1 = 0.177$) : variable
  quantitative la plus corrélée à l'âge — chaque centimètre de
  diamètre supplémentaire ajoute environ 0.18 an en moyenne.

- *Hauteur totale* (`haut_tot`, $beta_2 = 0.158$) : effet positif
  mais plus faible que le diamètre.

#pagebreak()

*Performance du modèle :*

$
R^2 = 0.665 quad quad "RMSE" = 11.85 "ans"
$

Le modèle explique *66.5 %* de la variabilité de l'âge des arbres. \
L'erreur quadratique moyenne est de *11.85 ans*

En représentant graphiquement notre modèle on a :


#figure(
  image("graph/partie_5/fig_reg_pred.png", width: 80%),
  caption: [
        Age estimé de la prédiction par rapport au réel
  ]
)

On vois que la régréssion linéaire permet d'estimer l'âge des arbres de façon relative. Le modèle est correct pour les arbres jeunes à moyens (0–75 ans) mais perd en précision pour les arbres anciens


== Régression logistique — Détection des arbres à abattre

On cherche à prédire la probabilité qu'un arbre soit à abattre.

*Variable cible :*

La variable cible binaire est définie par :

$
"a_abattre" = cases(
  1 & "si" quad "fk_arb_etat" in {"ABATTU"";" "Essouché""; " "Non essouché"},
  0 & "sinon"
)
$

- $1$ : arbre à abattre
- $0$ : arbre en place

#pagebreak()





La règle de décision retenue est :

$
hat(y) = cases(
  1 & "si" quad hat(p) > 0.10,
  0 & "sinon"
)
$

Le seuil est abaissé à $0.10$ (au lieu de $0.5$) car il y a trop peu de données à propos des arbres abattus



*Matrice de confusion :*

#figure(
  image("graph/partie_5/fig_matrice_confusion.png", width: 75%),
  caption: [
        Matrice de confusion
  ]
)

Avec cette matrice de confusion on remarque que le modèle de logistique a du mal à prédire les arbres à abattre ( "ABATTU", "Essouché", "Non essouché") représentés par le 1. Il semble cependant bien se débrouiller sur les arbres à ne pas abattre, encore une fois cela est dû à l'hétérogénéité des données : il y a trop peu d'exemples d'arbres à abattre pour le modèle. C'est pourquoi nous avons baissé le minimum de confiance requis à 0.1, cela fait que le modèle est beaucoup plus sensible aux variations des paramètres.


On trouve au final 
*
$
"Accuracy" =  "0.9679"
$
*
#v(2cm)
Soit une précision de * #sym.tilde.op 96,8% * pour le modèle

#pagebreak()

*Distribution des probabilités prédites :*


#figure(
  image("graph/partie_5/fig_log_prob_en_place.png"),
  caption: [Distribution des probabilités prédites selon le statut réel de l'arbre.
            Le seuil de décision est fixé à $hat(p) = 0.10$.]
)

Avec notre modèle, on trouve qu'il y a : *44* Arbres en place signalés à risque d'abattage soit *0.49%* des arbres en place actuellement en place



#pagebreak()

#heading(numbering: none)[Annexes]

#outline(target: figure, title: none)

#page(margin: 0pt)[
  #image("pied de garde.png", width: 100%, height: 100%, fit: "stretch")
]




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

#heading(numbering: none)[Partie IA: ]

= Besoin client 3 : Système d'alerte pour les tempêtes


== Objectif

L’objectif de cette partie était de développer un modèle d’intelligence artificielle basé sur un apprentissage supervisé par classification, afin de prédire le risque de \ déracinement des arbres lors d’événements tempétueux.


Pour cela, nous avons utilisé le jeu de données préalablement nettoyé, afin d’entraîner notre modèle sur des données pertinentes pour la phase d’apprentissage. L’enjeu principal de cet apprentissage était d’identifier les variables les plus exploitables permettant d’obtenir une classification fiable.

Cependant, le nombre de données liées spécifiquement au déracinement dû aux tempêtes était très limité, voire inexistant. Nous avons donc adapté notre approche en cherchant à prédire le risque qu’un arbre soit abattu ou essouché, c’est-à-dire la probabilité qu’il ne soit plus en place en fonction de ses caractéristiques.
=== Variable cible

La colonne `fk_arb_etat` décrit l’état de chaque arbre et constitue la variable cible que nous cherchons à prédire.

Étant donné que l’objectif est de déterminer si un arbre présente un risque de ne plus être en place, nous avons formulé le problème sous forme d’une classification binaire, définie comme suit :

#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt,
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else { white },
  [*Classe*], [*États inclus*], [*Effectif*],
  [0 — EN PLACE], [EN PLACE], [ #sym.tilde.op 9 200],
  [1 — RISQUE],   [ABATTU, Essouché, SUPPRIMÉ, REMPLACÉ, Non essouché], [ #sym.tilde.op 1 000],
)

#v(0.4em)
de par les effectif des données, on vois que le déséquilibre est d'environ *10:1*.
\ Pour la suite de l'apprentissage on mettra donc un poid de 10:1 pour la classe *Risque*

#pagebreak()

=== Features retenues

Les features ont été choisies pour leur pertinence physique vis-à-vis de la résistance
au vent et de la fragilité structurelle de l'arbre.

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt,
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else { white },
  [*Feature*], [*Type*], [*Justification*],
  [`tronc_diam`],   [Num.], [Résistance mécanique au vent],
  [`haut_tot`],     [Num.], [Prise au vent],
  [`haut_tronc`],   [Num.], [Position du centre de gravité],
  [`age_estim`],    [Num.], [Fragilité potentielle liée à l'âge],
  [`X`, `Y`],       [Num.], [Localisation géographique],
  [`fk_port`],      [Cat.], [Forme générale — prise au vent],
  [`fk_pied`],      [Cat.], [Fragilité racinaire],
  [`nomfrancais`],  [Cat.], [Espèce — résistance intrinsèque],
  [`clc_quartier`], [Cat.], [Contexte urbain d'exposition],
  [`clc_secteur`],  [Cat.], [Secteur géographique],
)


les aspect géographique on également été ajouté après avoir constaté qu'il permettait d'amélioré significativement l'apprentissage, on a donc également: 

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt,
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else { white },
  [*Feature*], [*Type*], [*Justification*],
  [`X`, `Y`],       [Num.], [Localisation géographique],
  [`clc_quartier`], [Cat.], [Contexte urbain d'exposition],
  [`clc_secteur`],  [Cat.], [Secteur géographique],
)

// ── 3. Prétraitement ───────────────────────────────────────────────────────
== Prétraitement des données

Le prétraitement suit les recommandations de la documentation scikit-learn
(`sklearn.preprocessing`) et est entièrement encapsulé dans un *Pipeline* pour
éviter toute fuite de données entre l'entraînement et le test.

=== Transformation des variables numériques

Une *transformation logarithmique* (`log1p`) est appliquée avant le pipeline sur
les variables numériques afin de réduire l'asymétrie des distributions
(diamètre, hauteur, âge présentent typiquement une distribution à longue queue droite).

Ensuite, un *StandardScaler* normalise chaque variable (moyenne = 0, écart-type = 1),
ce qui est nécessaire pour que des variables d'unités différentes (cm, m, années)
contribuent de façon égale au modèle.

=== Gestion des valeurs manquantes

Un *SimpleImputer* est appliqué :
- on prend la *médiane* pour les variables numériques manquante
- pour les catégorie manquante on set a (`"missing"`) pour les variables catégorielles

=== Encodage des variables catégorielles

Un *OneHotEncoder* transforme chaque modalité en colonne binaire.
Le paramètre `handle_unknown="ignore"` permet de gérer proprement les modalités
inconnues lors de la prédiction sur de nouvelles données.

=== Split train / test

Le jeu est divisé en *80% entraînement / 20% test* avec `stratify=y` pour
garantir les mêmes proportions de classes dans chaque partition du fait qu'on est des données déséquilibré.

// ── 4. Modèle ──────────────────────────────────────────────────────────────
== Modélisation

=== Choix de l'algorithme

Un Random Forest Classifier (ensemble de 500 arbres de décision) a été retenu après avoir testé plusieurs modèles, notamment XGBoost, CatBoost et Random Forest. Ce choix s’explique par sa capacité à mieux minimiser le nombre de faux négatifs tout en maximisant la détection des arbres à risque.

Cependant, les trois algorithmes présentent des performances globales similaires en termes d’accuracy :

- Accuracy XGBoost : 92 %
- Accuracy CatBoost : 93,91 %
- Accuracy Random Forest : 92,27 %
#grid(
  align: horizon,
  columns: (1fr,1fr,1fr),
  rows: (auto, 0pt),
  gutter: 15pt,

    figure(
      image("../graph/catboost_matrice.png", width: 110%),
      caption: [
        Via CatBoost
      ],
    ),

     figure(
      image("../graph/XGB_matrice.png", width: 110%),
      caption: [
        Via XGB
      ],
    ),

     figure(
      image("../graph/forestclassifier_matrice.png", width: 100%),
      caption: [
        Via CatBoost
      ],
    ),
)


=== Seuil de décision

Par défaut, sklearn prédit la classe 1 dès que la probabilité dépasse 0.5.
Après exploration des seuils, *0.2* a été retenu : pour maximiser le rappel qu'on fais sur la classe RISQUE afin d'être cohérent avec le fais qu'on cherche a prédire qu'elle arbre est a risque lors d'une tempête. dans ce cas la, on préfère prédire plus de Faux risque que de manqué des arbres a risque qui pourrais être dangereux.

// ── 5. Résultats ───────────────────────────────────────────────────────────
== Résultats et évaluation

=== Métriques

#align(center)[
#table(
  columns: (auto, auto, auto, auto),
  stroke: 0.5pt,
  fill: (_, row) => if row == 0 { rgb("#f0f0f0") } else { white },

  [*Classe*], [*Precision*], [*Recall*], [*F1*],

  [EN PLACE (0)], [0.97], [0.96], [0.96],
  [RISQUE (1)],   [0.63], [0.68], [0.65],
  [Accuracy],     [],     [],     [0.93],
  [Macro avg],    [0.80], [0.82], [0.81],
)
]

 #figure(
      image("../graph/info_graph.png", width: 100%),
      caption: [
        Performance relative du modèle final
      ],
    ),
#v(0.3em)



=== Lecture des résultats


La *précision de 63%* pour la prédiction de la classe RISQUE signifie que sur 10 alertes déclenchées,
environ 6 correspondent à de vrais arbres à risque. \ \
La *matrice de confusion*
confirme que 137 arbres à risque sont correctement détectés sur 202, on a 81 fausses alarmes (81) pour 137 arbre a risque bien prédit ce qui reste acceptable

La *courbe Precision-Recall* (AP = 0.74) montre que le modèle maintient une
bonne précision jusqu'à un rappel de ~0.6, ce qui est satisfaisant au regard
du déséquilibre initial des données.


// ── 6. Scripts ─────────────────────────────────────────────────────────────
== Scripts de prédiction

le scripts *`predict_ui.py`* exploite le modèle sauvegardé (`modele_tempete.pkl`) sans
relancer d'entraînement afin de prédire si un arbre est a risque en fonction de ces caractéristique.

Une interface graphique a été réalisé en utilisant QT afin de "simuler" un usage pratique 

En utilisant une boucle pour testé toutes les données du CSV utilisé pour l'entrainement on trouve que la moyenne des arbre a abbatre est #sym.tilde.op 9% ce qui reste cohérent avec un nombre d'arbre potentiellement sensible à une tempête.





#pagebreak()

#heading(numbering: none)[Annexes]

#outline(target: figure, title: none)

#page(margin: 0pt)[
  #image("pied de garde.png", width: 100%, height: 100%, fit: "stretch")
]




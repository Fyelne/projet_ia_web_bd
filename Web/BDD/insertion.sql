USE grp2tr5;

-- 1. Espèces
INSERT INTO espece (nom_commun, nom_latin) VALUES ('ACEPSE', 'ACEPSE');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('PRUSER', 'PRUSER');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('PINNIGnig', 'PINNIGnig');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('AESHIP', 'AESHIP');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('ALNGLUimp', 'ALNGLUimp');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('QUEROB', 'QUEROB');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('CORCOL', 'CORCOL');
INSERT INTO espece (nom_commun, nom_latin) VALUES ('TILCOR', 'TILCOR');

-- 2. États
INSERT INTO etat_arbre (libelle_etat) VALUES ('EN PLACE');

-- 3. Stades
INSERT INTO stade_developpement (libelle_stade) VALUES ('adulte');
INSERT INTO stade_developpement (libelle_stade) VALUES ('jeune');

-- 4. Ports
INSERT INTO type_port (libelle_port) VALUES ('réduit relâché');
INSERT INTO type_port (libelle_port) VALUES ('semi libre');
INSERT INTO type_port (libelle_port) VALUES ('réduit');
INSERT INTO type_port (libelle_port) VALUES ('tête de chat');

-- 5. Pieds
INSERT INTO type_pied (libelle_pied) VALUES ('gazon');
INSERT INTO type_pied (libelle_pied) VALUES ('fosse arbre');

-- 6. Arbres
INSERT INTO arbre (id_espece, hauteur_totale, hauteur_tronc, diametre_tronc, est_remarquable, latitude, longitude, id_etat, id_stade, id_port, id_pied) 
VALUES 
((SELECT id_espece FROM espece WHERE nom_commun='ACEPSE' LIMIT 1), 6.0, 2.0, 135.0, 0, 8296113.0636, 1721625.6893, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='réduit relâché' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='PRUSER' LIMIT 1), 5.0, 1.0, 145.0, 0, 8294310.2985, 1720913.2162, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='PINNIGnig' LIMIT 1), 22.0, 6.0, 60.0, 0, 8294219.7296, 1722535.1345, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='AESHIP' LIMIT 1), 20.0, 2.0, 226.0, 0, 8295017.7539, 1722027.6402, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='ALNGLUimp' LIMIT 1), 7.0, 2.0, 48.0, 0, 8293746.6621, 1721201.1823, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='jeune' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='fosse arbre' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='QUEROB' LIMIT 1), 16.0, 4.0, 185.0, 0, 8296180.2039, 1721526.4398, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='réduit' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='TILCOR' LIMIT 1), 16.0, 2.0, 172.0, 0, 8294979.7915, 1721990.2223, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='CORCOL' LIMIT 1), 10.0, 2.0, 69.0, 0, 8293720.0984, 1721206.8407, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='semi libre' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='fosse arbre' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='AESHIP' LIMIT 1), 15.0, 2.0, 213.0, 0, 8294998.242, 1721966.5683, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='tête de chat' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1)),
((SELECT id_espece FROM espece WHERE nom_commun='QUEROB' LIMIT 1), 16.0, 4.0, 150.0, 0, 8296155.6795, 1721539.0435, (SELECT id_etat FROM etat_arbre WHERE libelle_etat='EN PLACE' LIMIT 1), (SELECT id_stade FROM stade_developpement WHERE libelle_stade='adulte' LIMIT 1), (SELECT id_port FROM type_port WHERE libelle_port='réduit' LIMIT 1), (SELECT id_pied FROM type_pied WHERE libelle_pied='gazon' LIMIT 1));
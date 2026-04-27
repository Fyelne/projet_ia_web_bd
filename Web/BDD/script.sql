-- ----------------------------------------------------------
-- Script MYSQL pour mcd
-- ----------------------------------------------------------


-- ----------------------------
-- Table: stade_developpement
-- ----------------------------
CREATE TABLE stade_developpement (
  id_stade INT NOT NULL AUTO_INCREMENT,
  libelle_stade VARCHAR(50) NOT NULL,
  CONSTRAINT stade_developpement_PK PRIMARY KEY (id_stade)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: type_port
-- ----------------------------
CREATE TABLE type_port (
  id_port INT NOT NULL AUTO_INCREMENT,
  libelle_port VARCHAR(50) NOT NULL,
  CONSTRAINT type_port_PK PRIMARY KEY (id_port)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: espece
-- ----------------------------
CREATE TABLE espece (
  id_espece INT NOT NULL AUTO_INCREMENT,
  nom_commun VARCHAR(100),
  nom_latin VARCHAR(100),
  CONSTRAINT espece_PK PRIMARY KEY (id_espece)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: etat_arbre
-- ----------------------------
CREATE TABLE etat_arbre (
  id_etat INT NOT NULL AUTO_INCREMENT,
  libelle_etat VARCHAR(50) NOT NULL,
  CONSTRAINT etat_arbre_PK PRIMARY KEY (id_etat)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: type_pied
-- ----------------------------
CREATE TABLE type_pied (
  id_pied INT NOT NULL AUTO_INCREMENT,
  libelle_pied VARCHAR(50) NOT NULL,
  CONSTRAINT type_pied_PK PRIMARY KEY (id_pied)
)ENGINE=InnoDB;


-- ----------------------------
-- Table: arbre
-- ----------------------------
CREATE TABLE arbre (
  id_arbre INT NOT NULL AUTO_INCREMENT,
  hauteur_totale DECIMAL(5,2),
  hauteur_tronc DECIMAL(5,2),
  diametre_tronc DECIMAL(5,2),
  est_remarquable TINYINT(1) DEFAULT FALSE,
  latitude DOUBLE NOT NULL,
  longitude DOUBLE NOT NULL,
  date_derniere_mesure DATE,
  id_espece INT NOT NULL,
  id_etat INT NOT NULL,
  id_stade INT NOT NULL,
  id_port INT NOT NULL,
  id_pied INT NOT NULL,
  CONSTRAINT arbre_PK PRIMARY KEY (id_arbre),
  CONSTRAINT arbre_id_espece_FK FOREIGN KEY (id_espece) REFERENCES espece (id_espece),
  CONSTRAINT arbre_id_etat_FK FOREIGN KEY (id_etat) REFERENCES etat_arbre (id_etat),
  CONSTRAINT arbre_id_stade_FK FOREIGN KEY (id_stade) REFERENCES stade_developpement (id_stade),
  CONSTRAINT arbre_id_port_FK FOREIGN KEY (id_port) REFERENCES type_port (id_port),
  CONSTRAINT arbre_id_pied_FK FOREIGN KEY (id_pied) REFERENCES type_pied (id_pied)
)ENGINE=InnoDB;


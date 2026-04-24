import sys
import numpy as np
import pandas as pd
import joblib

from PyQt5.QtWidgets import *
from PyQt5.QtCore import Qt


# colonne pr prédiction du modèle
FEATURES_NUM = ["tronc_diam", "haut_tot", "haut_tronc", "age_estim", "X", "Y"]
FEATURES_CAT = ["fk_port", "fk_pied", "nomfrancais", "clc_quartier", "clc_secteur"]
FEATURES = FEATURES_NUM + FEATURES_CAT
SEUIL = 0.2 # seuil retenu pour une classification acceptable


# donnée du csv pour avoir val par default (moyenne) si aucune donnée entré par l'utiilisateur
df = pd.read_csv("Data_Arbre_Clean.csv")
df[FEATURES_NUM] = np.log1p(df[FEATURES_NUM])

MOY = df[FEATURES_NUM].median()
DEF = {c: df[c].mode()[0] for c in FEATURES_CAT}
OPT = {c: df[c].dropna().unique() for c in FEATURES_CAT}

model = joblib.load("modele_tempete.pkl")


class App(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Alerte Tempête")

        layout = QVBoxLayout(self)

        self.inputs = {}

        # param numerique
        for col in ["tronc_diam", "haut_tot", "haut_tronc", "age_estim"]:
            f = QLineEdit()
            f.setPlaceholderText(f"{col} (défaut {MOY[col]:.1f})")
            self.inputs[col] = f
            layout.addWidget(f)

        # param par catégorie
        for col in FEATURES_CAT:
            layout.addWidget(QLabel(col))  # titre de la colonne
            c = QComboBox()
            c.addItem("")
            c.addItems([str(v) for v in OPT[col]])
            self.inputs[col] = c
            layout.addWidget(c)

        # bouton de prédiction
        btn = QPushButton("Prédire")
        btn.clicked.connect(self.predict)
        layout.addWidget(btn)

        #affichage du resultat
        self.result = QLabel("")
        self.result.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.result)

    def predict(self):
        d = {}

        #on traite par catégorie

        for col in FEATURES_NUM:
            if col in self.inputs and isinstance(self.inputs[col], QLineEdit):
                txt = self.inputs[col].text()
                d[col] = np.log1p(float(txt)) if txt else MOY[col]
            else:
                d[col] = MOY[col]


        for col in FEATURES_CAT:
            val = self.inputs[col].currentText()
            d[col] = val if val else DEF[col]

        # % prédit
        proba = model.predict_proba(pd.DataFrame([d])[FEATURES])[0, 1]

        if proba >= SEUIL:
            self.result.setText(f"Risque de déracinement par tempête \n (p={proba:.2f})")
            self.result.setStyleSheet("color:red;")
        else:
            self.result.setText(f"Arbre sans risque pour tempête \n (p={proba:.2f})")
            self.result.setStyleSheet("color:green;")


# --- RUN ---
app = QApplication(sys.argv)
w = App()
w.show()
sys.exit(app.exec_())
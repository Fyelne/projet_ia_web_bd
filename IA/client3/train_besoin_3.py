import pandas as pd
import numpy as np
import joblib
import matplotlib
matplotlib.use("TkAgg")
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.decomposition import PCA
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (classification_report, confusion_matrix, accuracy_score,
                             ConfusionMatrixDisplay, PrecisionRecallDisplay, RocCurveDisplay,
                             average_precision_score)
from imblearn.pipeline import Pipeline as ImbPipeline


# csv 
df = pd.read_csv("Data_Arbre_Clean.csv")

for col in ["tronc_diam", "haut_tot", "haut_tronc", "age_estim", "X", "Y"]:
    df[col] = np.log1p(df[col])

CIBLE        = "fk_arb_etat"
ETATS_RISQUE = ["ABATTU", "Essouché", "SUPPRIMÉ", "REMPLACÉ", "Non essouché"]
FEATURES_NUM = ["tronc_diam", "haut_tot", "haut_tronc", "age_estim", "X", "Y"]
FEATURES_CAT = ["fk_port", "fk_pied", "nomfrancais", "clc_quartier", "clc_secteur"]
FEATURES     = FEATURES_NUM + FEATURES_CAT

X = df[FEATURES]
y = df[CIBLE].apply(lambda x: 1 if x in ETATS_RISQUE else 0)

print("Distribution fk_arb_etat :\n", df[CIBLE].value_counts())
print("\nMissing values :\n", X.isna().sum())
print("\nDistribution cible :\n", y.value_counts(), "\n")

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)


# Préprocess
num_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="median")),
    ("scaler",  StandardScaler())
])

cat_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="constant", fill_value="missing")),
    ("encoder", OneHotEncoder(handle_unknown="ignore", sparse_output=False))
])

preprocessor = ColumnTransformer([
    ("num", num_pipeline, FEATURES_NUM),
    ("cat", cat_pipeline, FEATURES_CAT)
])


pipeline = ImbPipeline([
    ("prep", preprocessor),
    ("clf",  RandomForestClassifier(random_state=42))
])

param_grid = {
    "clf__n_estimators":      [500],
    "clf__max_depth":         [None, 20],
    "clf__min_samples_split": [2, 5],
    "clf__min_samples_leaf":  [1, 2],
    "clf__max_features":      ["sqrt"],
    "clf__class_weight":      [{0: 1, 1: 10}]
}

grid = GridSearchCV(pipeline, param_grid, cv=5, scoring="f1", n_jobs=-1, verbose=1)
grid.fit(X_train, y_train)

best_model = grid.best_estimator_




# METRIQUE / VISU

print(f"\nMeilleurs paramètres : {grid.best_params_}")
print(f"Meilleur F1 (CV)     : {grid.best_score_:.4f}\n")

y_proba = best_model.predict_proba(X_test)[:, 1]
y_pred  = (y_proba >= 0.2).astype(int)

print(f"Accuracy : {accuracy_score(y_test, y_pred):.2%}\n")
print(classification_report(y_test, y_pred))
print(f"Average Precision : {average_precision_score(y_test, y_proba):.3f}")

cm = confusion_matrix(y_test, y_pred)
print("\nMatrice de confusion :\n", cm)

# PCA 2D pour visualisation
X_test_proc = best_model.named_steps["prep"].transform(X_test)
X_pca       = PCA(n_components=2).fit_transform(X_test_proc)

fig, axes = plt.subplots(2, 3, figsize=(18, 10))

# 1. PCA
configs = [
    ((y_test == 0) & (y_pred == 0), "TN", 0.3),
    ((y_test == 0) & (y_pred == 1), "FP", 0.7),
    ((y_test == 1) & (y_pred == 0), "FN", 0.7),
    ((y_test == 1) & (y_pred == 1), "TP", 0.7),
]

for mask, label, alpha in configs:
    axes[0, 0].scatter(X_pca[mask, 0], X_pca[mask, 1],
                       label=label, alpha=alpha)

axes[0, 0].set_title("Analyse des erreurs (PCA)")
axes[0, 0].set_xlabel("PCA 1")
axes[0, 0].set_ylabel("PCA 2")
axes[0, 0].legend()


# M. de confusion
ConfusionMatrixDisplay(cm, display_labels=["EN PLACE", "RISQUE"]).plot(
    ax=axes[0, 1], colorbar=False
)
axes[0, 1].set_title("Matrice de confusion")


# Recall graph
PrecisionRecallDisplay.from_estimator(
    best_model, X_test, y_test, ax=axes[0, 2]
)
axes[0, 2].set_title("Precision-Recall")


# graph ROC
RocCurveDisplay.from_estimator(
    best_model, X_test, y_test, ax=axes[1, 0]
)
axes[1, 0].set_title("ROC Curve")


#
axes[1, 1].axis("off")
axes[1, 2].axis("off")


# svgrd img
plt.tight_layout()
plt.savefig("info_graph.png", dpi=120)
plt.show()

# svgrd modedl
joblib.dump(best_model, "modele_tempete.pkl")
print("✅ Modèle sauvegardé : modele_tempete.pkl")
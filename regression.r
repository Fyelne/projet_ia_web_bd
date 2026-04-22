# fonctionnalité 5

library(dplyr)
library(ggplot2)

source("clean_data.r")

# Régression linéaire

# Sous-ensemble sans valeurs manquantes
df_reg <- df[, c("age_estim", "tronc_diam", "haut_tot", "fk_stadedev", "fk_situation", "feuillage")]
df_reg <- df_reg[complete.cases(df_reg), ]

# Modèle
mod <- lm(age_estim ~ tronc_diam + haut_tot + fk_stadedev,
          data = df_reg)
print(summary(mod))

# Le modèle explique environ 67% de la variance de l'age estimé de l'arbre
cat(sprintf("RMSE = %.2f ans\n", sqrt(mean(mod$residuals^2))))

# Prédictions
df_reg$pred <- predict(mod, newdata = df_reg)

png("output/regression/fig_reg_pred.png", width = 750, height = 520, res = 100)
p <- ggplot(df_reg, aes(x = age_estim, y = pred)) +
  geom_point(alpha = 0.2, color = "blue", size = 1.3) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype="dashed") +
  geom_smooth(method = "lm", color = "green", se = TRUE, linewidth = 1.2) +
  labs(title    = "Age estimé prédiction vs réel",
       x = "Réel", y = "Prédit") +
  theme_minimal(base_size = 13)
print(p)
dev.off()

# Age en fonction du diamètre du tronc
png("output/regression/fig_reg_age_vs_diametre.png", width = 800, height = 600, res = 100)
p <- ggplot(df_reg, aes(x = tronc_diam, y = age_estim)) +
  geom_point(alpha = 0.2, color = "blue", size = 1.2) +
  geom_smooth(method = "lm", color = "red", se = TRUE, linewidth = 1.2) +
  labs(title = "Age estimé ~ Diamètre du tronc",
       x = "Diamètre du tronc", y = "Age estimé") +
  theme_minimal(base_size = 13)
print(p)
dev.off()


# Regression logistique
# Variable cible : 1 -> à abattre, 0 -> en place
df$a_abattre <- ifelse(df$fk_arb_etat %in% c("ABATTU", "Essouché", "Non essouché"), 1, 0)

print(table(df$a_abattre, useNA = "always"))
cat(sprintf("Taux d'arbres à abattre : %.2f%%\n\n",
            100 * mean(df$a_abattre == 1, na.rm = TRUE)))

df_log <- df[, c("a_abattre", "age_estim", "tronc_diam", "haut_tot",
                 "fk_stadedev", "fk_situation", "feuillage")]
df_log <- df_log[complete.cases(df_log), ]

# Modèle logistique
mod_log <- glm(a_abattre ~ age_estim + tronc_diam + haut_tot +
                 fk_stadedev + fk_situation + feuillage,
               data   = df_log,
               family = binomial(link = "logit"))
print(summary(mod_log))

# Evaluation (prédiction > 0.10 car il y a trop peu de données à propos des arbres abattus)
pred_prob  <- predict(mod_log, type = "response")
pred_class <- ifelse(pred_prob > 0.10, 1, 0)


# Matrice de confusion
confusion_matrix <- table(Reel = df_log$a_abattre, Predit = pred_class)
print(confusion_matrix)
cat(sprintf("Accuracy : %.4f\n", mean(pred_class == df_log$a_abattre)))

df_confusion <- as.data.frame(confusion_matrix)

# on utilise log freq pour évite que la population 0 occupe toute la matrix
png("output/regression/fig_matrice_confusion.png", width = 800, height = 600, res = 100)
p <- ggplot(data = df_confusion, aes(x = Reel, y = Predit)) +
  geom_tile(aes(fill = log(Freq + 1)), color = "white", show.legend = FALSE) +
  scale_fill_gradient(low = "white", high = "blue") +
  geom_text(aes(label = Freq), color = "black") +
  labs(title = "Matrice de Confusion", x = "Valeur Réelle", y = "Valeur Prédite") +
  theme_minimal()
print(p)
dev.off()

# Proba prédites
df_log$prob_abattre <- pred_prob
df_log$statut <- ifelse(df_log$a_abattre == 1, "A abattre", "En place")

png("output/regression/fig_log_prob_distribution.png", width = 800, height = 600, res = 100)
p <- ggplot(df_log, aes(x = prob_abattre, fill = statut)) +
  geom_histogram(bins = 40, alpha = 0.7, position = "identity") +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "black") +
  scale_fill_manual(values = c("En place" = "blue", "A abattre" = "red"), name = "Realite") +
  labs(title = "Distribution des prédictions",
       x = "P(arbre a abattre)", y = "Nombre d'arbres") +
  theme_minimal(base_size = 13)
print(p)
dev.off()


cat(sprintf("Regression (age_estim) : R2 = %.4f  |  RMSE = %.2f ans\n",
            summary(mod)$r.squared, sqrt(mean(mod$residuals^2))))
cat(sprintf("Logistique (a abattre) : Accuracy = %.4f\n", mean(pred_class == df_log$a_abattre)))
# Principaux predicteurs de l'age : diametre du tronc > hauteur > stade de developpement
# Principaux facteurs de risque d'abattage : stade adulte > age avance
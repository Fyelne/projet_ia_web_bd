# Fonctionnalité 4
library(ggplot2)
library(corrplot)
library(dplyr)
library(vcd)
library(ggmosaic)

source("clean_data.r")

# Filtres des variables numériques
vars_num <- df[, c("age_estim", "haut_tot", "haut_tronc", "tronc_diam", "clc_nbr_diag")]
vars_num <- vars_num[complete.cases(vars_num), ]

cor_matrix <- cor(vars_num, use = "pairwise.complete.obs", method = "pearson")

# Test de significativité de chaque corrélation
n <- nrow(vars_num)
for (i in 1:(ncol(vars_num) - 1)) {
  for (j in (i + 1):ncol(vars_num)) {
    r   <- cor_matrix[i, j]
    t   <- r * sqrt(n - 2) / sqrt(1 - r^2)
    pv  <- 2 * pt(-abs(t), df = n - 2)
    cat(sprintf("  %s ~ %s : r=%.3f, t=%.2f, p=%.4f %s\n",
                colnames(vars_num)[i], colnames(vars_num)[j],
                r, t, pv,
                ifelse(pv < 0.05, "(*)", "")))
  }
}

# Matrice de corrélation
png("output/correlation/fig_correlations_numeriques.png", width = 800, height = 700, res = 100)
corrplot(cor_matrix,
         method   = "color",
         type     = "upper",
         addCoef.col = "black",
         tl.col   = "black",
         title    = "Matrice de corrélation – Variables numériques",
         mar = c(1, 1, 2, 1))
dev.off()

# Graphique age estimé en fonction du diamètre du tronc
png("output/correlation/fig_age_diametre.png", width = 800, height = 600, res = 100)
p <- ggplot(vars_num, aes(x = tronc_diam, y = age_estim)) +
  geom_point(alpha = 0.25, color = "green", size = 1.2) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title    = "Corrélation : Age estimé ~ Diamètre du tronc",
       subtitle = sprintf("r = %.3f", cor_matrix["age_estim", "tronc_diam"]),
       x = "Diamètre du tronc (cm)", y = "Age estimé (ans)") +
  theme_minimal(base_size = 13)
print(p)
dev.off()

# Graphique age estimé en fonction de la hauteur totale
png("output/correlation/fig_age_hauteur.png", width = 800, height = 600, res = 100)
p <- ggplot(vars_num, aes(x = haut_tot, y = age_estim)) +
  geom_point(alpha = 0.25, color = "green", size = 1.2) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title    = "Corrélation : Age estimé ~ Hauteur totale",
       subtitle = sprintf("r = %.3f", cor_matrix["age_estim", "haut_tot"]),
       x = "Hauteur totale (m)", y = "Age estimé (ans)") +
  theme_minimal(base_size = 13)
print(p)
dev.off()

# Analyse bivariées

analyze_age_estimations <- function(col1, col2, name1, name2, df, png_name) {
  df_filtered <- df[!is.na(df[[col1]]) & !is.na(df[[col2]]), ]
  
  print(tapply(df_filtered[[col2]], df_filtered[[col1]], summary))
  
  anova_result <- aov(df_filtered[[col2]] ~ df_filtered[[col1]], data = df_filtered)
  print(summary(anova_result))
  
  # boxplot
  png(png_name, width = 800, height = 600, res = 100)
  p <- ggplot(df_filtered, aes_string(x = col1, y = col2, fill = col1)) +
    geom_boxplot(outlier.alpha = 0.3) +
    scale_fill_brewer(palette = "RdYlGn") +
    labs(title = name1, x = name2, y = "Age estimé (ans)") +
    theme_minimal(base_size = 13) + 
    theme(legend.position = "none")
  print(p)
  dev.off()
}

# Stade Dev ~ Age estimé
analyze_age_estimations("fk_stadedev", "age_estim", 
                        "Age estimé selon le stade de développement", 
                        "Stade de développement", 
                        df, 
                        "output/correlation/fig_boxplot_age_stadedev.png")

# Situation ~ Age estimé
analyze_age_estimations("fk_situation", "age_estim", 
                        "Age estimé selon la situation de l'arbre", 
                        "Situation", 
                        df, 
                        "output/correlation/fig_boxplot_age_situation.png")

# Feuillage ~ Age estimé
analyze_age_estimations("feuillage", "age_estim", 
                        "Age estimé selon le type de feuillage", 
                        "Type de feuillage", 
                        df, 
                        "output/correlation/fig_violon_age_feuillage.png")

#Test Chi
chi2_calc <- function(var1, var2, label1, label2, df, filename_prefix) {
  sub <- df[!is.na(df[[var1]]) & !is.na(df[[var2]]), ]
  tbl <- table(sub[[var1]], sub[[var2]])
  cat(sprintf("\n[%s ~ %s]\n", label1, label2))
  cat("Tableau croisé :\n"); print(tbl)
  chi2 <- chisq.test(tbl, simulate.p.value = TRUE)
  cat("Test du Chi2 :\n"); print(chi2)
  
  # Mosaicplot
  png_name <- paste0(filename_prefix, ".png")
  png(png_name, width = 850, height = 600, res = 100)
  mosaicplot(tbl,
             main  = paste("Mosaicplot :", label1, "~", label2),
             xlab  = label1, ylab = label2
             color = c("blue", "red", "green", "orange", "purple", "gray")
  dev.off()
  
  list(table = tbl, test = chi2)
}

# Stade de développement ~ Situation
chi2_calc("fk_stadedev", "fk_situation", "Stade de développement", "Situation",
         df, "output/correlation/fig_chi2_stadedev_situation")

# Stade de développement ~ Feuillage
chi2_calc("fk_stadedev", "feuillage", "Stade de développement", "Feuillage",
         df, "output/correlation/fig_chi2_stadedev_feuillage")

# Situation ~ Feuillage
chi2_calc("fk_situation", "feuillage", "Situation", "Feuillage",
         df, "output/correlation/fig_chi2_situation_feuillage")

# Situation ~ Remarquable
chi2_calc("fk_situation", "remarquable", "Situation", "Remarquable",
         df, "output/correlation/fig_chi2_situation_remarquable")

# Etat ~ Feuillage
chi2_calc("fk_arb_etat", "feuillage", "Etat", "Feuillage",
         df, "output/correlation/fig_chi2_etat_feuillage")

# Comment estimer l'age :
cat(sprintf("  age_estim ~ tronc_diam : r = %.3f  (forte / positive)\n", cor_matrix["age_estim", "tronc_diam"]))
cat(sprintf("  age_estim ~ haut_tot   : r = %.3f\n", cor_matrix["age_estim", "haut_tot"]))
cat(sprintf("  age_estim ~ haut_tronc : r = %.3f\n", cor_matrix["age_estim", "haut_tronc"]))
cat(sprintf("  tronc_diam ~ haut_tot  : r = %.3f\n", cor_matrix["tronc_diam", "haut_tot"]))
# La hauteur du tronc et son diamètre sont les meilleurs prédicteurs numériques de l'age estimé
# Les variables qualitatives (stade de développement, situation) sont liées au type de feuillage (Chi2 significatif)
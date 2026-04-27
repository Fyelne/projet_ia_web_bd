library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales)

#setwd("C:/Users/angec/OneDrive/ISEN/CIPA 4/PROJET_BIG_DATA_IA_WEB/R_script")


# -- CHARGEMENT DES DONNÉES --------------------------------
df <- read.csv(
  "data/Data_Arbre_Clean.csv",
  sep = ",",
  header = TRUE,
  encoding = "UTF-8"
)

# -- AGRÉGATION PAR QUARTIER -------------------------------
arbres_quartier <- df %>%
  filter(!is.na(clc_quartier)) %>%
  count(clc_quartier, name = "n_arbres")

# -- VISUALISATION ------------------------------------------

#------------------------------------------------------------
# NBR ARBRE PAR QUARTIER
#------------------------------------------------------------

arbres_quartier %>%
  ggplot(aes(
    x = reorder(clc_quartier, n_arbres),
    y = n_arbres,
    fill = n_arbres
  )) +
  
  geom_col() +
  
  geom_text(
    aes(label = n_arbres),
    vjust = -0.4,
    size = 3
  ) +
  
  scale_fill_gradient(
    low = "#f0e6aa",
    high = "#cc2f00",
    name = "Nombre d'arbres"
  ) +
  
  theme_minimal() +
  
  theme(
    axis.text.x = element_text(angle = 60, hjust = 1),
    legend.position = "none"
  ) +
  
  labs(
    title = "Répartition des arbres par quartier",
    x = "Quartier",
    y = "Nombre d'arbres"
  ) +
  
  expand_limits(y = max(arbres_quartier$n_arbres) * 1.1)

#------------------------------------------------------------
## ARBRE PAR ANNEE
#------------------------------------------------------------

plantations <- df %>%
  drop_na(dte_plantation) %>%
  mutate(annee = lubridate::year(dte_plantation)) %>%
  count(annee, name = "plantations")

abattages <- df %>%
  drop_na(dte_abattage) %>%
  mutate(annee = lubridate::year(dte_abattage)) %>%
  count(annee, name = "abattages")

data_plot <- full_join(plantations, abattages, by = "annee") %>%
  replace_na(list(plantations = 0, abattages = 0)) %>%
  arrange(annee)

data_plot %>%
  ggplot(aes(x = annee)) +
  
  geom_line(aes(y = plantations, color = "Plantations"), linewidth = 1.2) +
  geom_point(aes(y = plantations, color = "Plantations"), size = 2.5) +
  
  geom_line(aes(y = abattages, color = "Abattages"), linewidth = 1.2) +
  geom_point(aes(y = abattages, color = "Abattages"), size = 2.5) +
  
  scale_color_manual(
    values = c("Plantations" = "#2c7fb8",
               "Abattages" = "#d95f0e"),
    name = "Type"
  ) +
  
  theme_minimal(base_size = 12) +
  
  labs(
    title = "Évolution des plantations et abattages d'arbres",
    subtitle = "Comparaison annuelle",
    x = "Année",
    y = "Nombre d'arbres"
  ) +
  
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )


#------------------------------------------------------------
# REPARTITION Arbre en fonction de leur dev
#------------------------------------------------------------

df %>%
  filter(!is.na(fk_stadedev)) %>%
  count(fk_stadedev) %>%
  
  ggplot(aes(
    x = reorder(fk_stadedev, n),
    y = n,
    fill = n
  )) +
  
  geom_text(
    aes(label = n),
    vjust = -0.4,
    size = 3)+
  
  geom_col() +
  
  
  scale_fill_gradient(low = "#f0f9e8", high = "#238b45", name = "Nombre") +
  
  theme_minimal() +
  
  labs(
    title = "Répartition des arbres selon leur stade de développement",
    x = "Stade de développement",
    y = "Nombre d'arbres"
  )

#------------------------------------------------------------
# Espèce principal par quartier avec age moyen 
#------------------------------------------------------------

df %>%
  mutate(clc_quartier = stringr::str_remove(clc_quartier, "^Quartier\\s+")) %>%
  
  filter(!is.na(clc_quartier),
         !is.na(nomfrancais),
         !is.na(age_estim)) %>%
  
  group_by(clc_quartier, nomfrancais) %>%
  summarise(
    age_moyen = mean(age_estim, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  
  filter(n >= 10) %>%
  
  group_by(clc_quartier) %>%
  slice_max(order_by = n, n = 5) %>%
  
  ggplot(aes(
    x = reorder(nomfrancais, n),
    y = n,
    fill = age_moyen
  )) +
  
  geom_text(
    aes(label = n),
    hjust = -0.1,
    size = 2)+
  
  geom_col() +
  coord_flip() +
  facet_wrap(~clc_quartier, scales = "free_y") +
  
  scale_fill_gradient(low = "#fcd8a9", high = "#238b45") +
  
  theme_minimal() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)))+
  
  labs(
    title = "Espèces principales et âge moyen par quartier",
    x = "Espèce",
    y = "Nombre d'arbre",
    fill = "Âge"
  )


#------------------------------------------------------------
# relation age / hauteur
#------------------------------------------------------------

df %>%
  filter(
    haut_tot > 0,
    !is.na(age_estim),
    !is.na(haut_tot),
    fk_arb_etat != "SUPPRIMÉ",
    fk_arb_etat != "ABATTU"
  ) %>%
  
  ggplot(aes(age_estim, haut_tot)) +
  
  #geom_point(alpha = 0.4, color = "#2c7fb8") +
  
  geom_smooth(color = "#d95f0e", linewidth = 1) +
  
  theme_minimal() +
  
  labs(
    title = "Relation âge / hauteur des arbres (arbres vivants)",
    x = "Âge estimé (ans)",
    y = "Hauteur (m)"
  )


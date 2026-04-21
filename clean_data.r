library(readr)
library(dplyr)

df <- read_csv('data/Data_Arbre_Input.csv', locale = locale(encoding = "UTF-8"))

head(df, 5)

columns_to_drop <- c(
  'OBJECTID', 'created_date', 'created_user',
  'last_edited_user', 'last_edited_date',
  'fk_prec_estim', 'CreationDate', 'Creator', 'EditDate', 'Editor',
  'GlobalID', 'fk_nomtech', 'commentaire_environnement',
  'src_geo'
) # colonnes à drop (bdd, trop hétérogènes)

# Affichage des arbres ayant les mêmes coordonées (probablement dupliqués)
print(sum(duplicated(df[c('X', 'Y')])))

df_clean <- df %>%
  select(-all_of(columns_to_drop)) %>% # drop des colonnes non intéressantes
  mutate(across(c(nomfrancais, nomlatin), ~na_if(., 'RAS'))) %>% # RAS = vide
  mutate(fk_revetement = na_if(fk_revetement, ' ')) %>% # espace = vide
  mutate(fk_stadedev = na_if(fk_stadedev, ' ')) %>%
  mutate(fk_port = na_if(fk_port, ' ')) %>%
  mutate(fk_pied = na_if(fk_pied, ' ')) %>%
  mutate(dte_plantation = na_if(dte_plantation, '1970/01/01 00:00:02+00')) %>% # 1970/01/01 est une valeur par défaut donc on la set nulle
  filter(!is.na(X) & !is.na(Y)) %>% # on supprime les valeurs sans géo pour les cartographies
  filter(!(age_estim > 100 & fk_stadedev == "jeune")) %>% # (valeur abérante car décrit comme "jeune" mais centenaire)
  distinct(X, Y, .keep_all = TRUE) # suppression des arbres ayant les mêmes coordonées

# Affichage du nouveau tableau clean
head(df_clean)

# Nombre de valeurs nulles par colonnes
missing_counts <- df_clean %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "column", values_to = "missing_count") %>%
  arrange(desc(missing_count))

print(missing_counts)

# convertir les string en factor
df_clean <- df_clean %>%
  mutate(
    fk_arb_etat = factor(fk_arb_etat, levels = c(
      "ABATTU", "EN PLACE", "Essouché", "Non essouché", "REMPLACE", "SUPPRIME"
    )),
    
    fk_stadedev = factor(fk_stadedev, levels = c(
      "adulte", "jeune", "senescent", "vieux"
    )),
    
    #fk_port = factor(fk_port, levels = c(
    #  "architecturé", "cépée", "Couronne", "couronné", "étêté", "libre",
    #  "réduit", "réduit relâché", "rideau", "semi libre",
    #  "têtard", "têtard relâché", "têtard de chat", "têtard de chat relaché"
    #)),
    
    fk_pied = factor(fk_pied, levels = c(
      "Bac de plantation", "Bande de terre", "fosse arbre", "gazon",
      "Revetement non permeable", "terre", "toile tissée", "végétation"
    )),
    
    fk_situation = factor(fk_situation, levels = c(
      "Alignement", "Groupe", "Isolé"
    )),
    
    feuillage = factor(feuillage, levels = c(
      "Conifère", "Feuillu"
    ))
  )

# convertir les string en date (toutes les valeurs sont en utc)
df_clean <- df_clean %>%
  mutate(
    dte_plantation = as.POSIXct(dte_plantation, format = "%Y/%m/%d %H:%M:%S", tz = "UTC"),
    dte_abattage   = as.POSIXct(dte_abattage, format = "%Y/%m/%d %H:%M:%S", tz = "UTC")
  )

# convertir les string en boolean
df_clean <- df_clean %>%
  mutate(
    remarquable = case_when(
      remarquable == "Oui" ~ TRUE,
      remarquable == "Non" ~ FALSE,
      TRUE ~ NA
    ),
    
    fk_revetement = case_when(
      fk_revetement == "Oui" ~ TRUE,
      fk_revetement == "Non" ~ FALSE,
      TRUE ~ NA
    )
  )

write_csv(df_clean, "data/Data_Arbre_Clean.csv")

summary(df_clean)



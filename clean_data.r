library(readr)
library(dplyr)

df <- read_csv('data/Data_Arbre_Input.csv', locale = locale(encoding = "UTF-8"))

clean_columns <- function(raw_data) {
  
  columns_to_drop <- c(
    'OBJECTID', 'created_date', 'created_user',
    'last_edited_user', 'last_edited_date',
    'fk_prec_estim', 'CreationDate', 'Creator', 'EditDate', 'Editor',
    'GlobalID', 'fk_nomtech', 'commentaire_environnement',
    'src_geo'
  ) # colonnes à drop (bdd, trop hétérogènes)
  
  # Affichage des arbres ayant les mêmes coordonées (probablement dupliqués)
  print(sum(duplicated(df[c('X', 'Y')])))
  
  df_clean <- raw_data %>%
    select(-all_of(columns_to_drop)) %>% # drop des colonnes non intéressantes
    mutate(across(c(nomfrancais, nomlatin), ~na_if(., 'RAS'))) %>% # RAS = vide
    mutate(fk_revetement = na_if(fk_revetement, ' ')) %>% # espace = vide
    mutate(fk_stadedev = na_if(fk_stadedev, ' ')) %>%
    mutate(fk_port = na_if(fk_port, ' ')) %>%
    mutate(fk_pied = na_if(fk_pied, ' ')) %>%
    mutate(
      fk_port = trimws(fk_port),
      fk_port = ifelse(fk_port == "Libre", "libre", fk_port)
    ) %>% # retirer les espaces et les majs
    mutate(dte_plantation = na_if(dte_plantation, '1970/01/01 00:00:02+00')) %>% # 1970/01/01 est une valeur par défaut donc on la set nulle
    filter(!is.na(X) & !is.na(Y)) %>% # on supprime les valeurs sans géo pour les cartographies
    filter(!(age_estim > 100 & fk_stadedev == "jeune")) %>% # (valeur abérante car décrit comme "jeune" mais centenaire)
    distinct(X, Y, .keep_all = TRUE) # suppression des arbres ayant les mêmes coordonées
  
  return (df_clean)
}

setup_data <- function(raw_data) {
  data <- raw_data
  
  # convertir les string en factor
  data$fk_stadedev   <- factor(data$fk_stadedev,   levels = c("jeune", "adulte", "vieux", "senescent"))
  data$fk_situation  <- factor(data$fk_situation)
  data$fk_port       <- factor(data$fk_port)
  data$fk_pied       <- factor(data$fk_pied)
  data$fk_revetement <- factor(data$fk_revetement)
  data$feuillage     <- factor(data$feuillage)
  data$remarquable   <- factor(data$remarquable)
  data$fk_arb_etat   <- factor(data$fk_arb_etat)
  data$clc_quartier  <- factor(data$clc_quartier)
  
  # convertir les string en date (toutes les valeurs sont en utc)
  data <- data %>%
    mutate(
      dte_plantation = as.POSIXct(dte_plantation, format = "%Y/%m/%d %H:%M:%S", tz = "UTC"),
      dte_abattage   = as.POSIXct(dte_abattage, format = "%Y/%m/%d %H:%M:%S", tz = "UTC")
    )
  
  # convertir les string en boolean
  data <- data %>%
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
  
  return(data)
}

df_clean <- clean_columns(df)

df_clean <- setup_data(df_clean)

write_csv(df_clean, "data/Data_Arbre_Clean.csv")

summary(df_clean)



library(readr)
library(dplyr)

data <- read_csv('data/Data_Arbre_Input.csv', locale = locale(encoding = "UTF-8"))

clean_columns <- function(raw_data) {
  
  columns_to_drop <- c(
    'OBJECTID', 'created_date', 'created_user',
    'last_edited_user', 'last_edited_date',
    'fk_prec_estim', 'CreationDate', 'Creator', 'EditDate', 'Editor',
    'GlobalID', 'fk_nomtech', 'commentaire_environnement',
    'src_geo'
  ) # colonnes à drop (bdd, trop hétérogènes)
  
  # Affichage des arbres ayant les mêmes coordonées (probablement dupliqués)
  print(sum(duplicated(raw_data[c('X', 'Y')])))
  
  df <- raw_data %>%
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
  
  return (df)
}

setup_data <- function(raw_data) {
  df <- raw_data
  
  # convertir les string en factor
  df$fk_stadedev   <- factor(df$fk_stadedev,   levels = c("jeune", "adulte", "vieux", "senescent"))
  df$fk_situation  <- factor(df$fk_situation)
  df$fk_port       <- factor(df$fk_port)
  df$fk_pied       <- factor(df$fk_pied)
  df$fk_revetement <- factor(df$fk_revetement)
  df$feuillage     <- factor(df$feuillage)
  df$remarquable   <- factor(df$remarquable)
  df$fk_arb_etat   <- factor(df$fk_arb_etat)
  df$clc_quartier  <- factor(df$clc_quartier)
  
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

df <- clean_columns(data)

df <- setup_data(df)

write_csv(df, "data/Data_Arbre_Clean.csv")

summary(df)



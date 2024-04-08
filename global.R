library(readxl)
library(dplyr)
library(lubridate)

read_dir <- 'C:/Users/ed_22/Documents/SIO/Procesados'

# lectura de tablas
db <- read_excel(paste0(read_dir, '/dic2023.xlsx'))
instituciones <- read_excel(paste0(read_dir, '/instituciones.xlsx'))
cuentas <- read_excel(paste0(read_dir, '/cuentas.xlsx'))
trimestres <- read_excel(paste0(read_dir, '/trimestres.xlsx'))
operaciones <- read_excel(paste0(read_dir, '/operaciones.xlsx'))

# convertir a formato year-month-day
class(trimestres$nombre)
trimestres$nombre <- ymd(trimestres$nombre)
class(trimestres$nombre)

create_df <- function(db, id_db, ref_tab, new_name) {
  # Create a new dataframe by merging an existing dataframe (`db`) with a reference table (`ref_tab`)
  # based on a common identifier (`id_db`). Rename a specific column to a new name (`new_name`) and 
  # remove the identifier column.
  #
  # Parameters:
  #   db (data.frame): The dataframe to be merged.
  #   id_db (character): The name of the column in `db` that serves as the identifier for merging.
  #   ref_tab (data.frame): The reference table to be merged with `db`.
  #   new_name (character): The new name for the column to be renamed.
  #
  # Returns:
  #   data.frame: A new dataframe obtained by merging `db` and `ref_tab`, renaming a specific column,
  #               and removing the identifier column.
  #
  
  # merge the dataframe with the reference table
  df <- merge(db, ref_tab, by.x = id_db, by.y = 'id')
  
  # rename the specified column
  names(df)[names(df) == "nombre"] <- new_name
  
  # remove the identifier column
  df <- df[, -which(names(df) == id_db)]
  
  return(df)
}

# creación del dataframe
df <- create_df(db, 'id_trim', trimestres, 'trimestre') %>% 
  create_df('id_nom', instituciones, 'institucion') %>% 
  create_df('id_cuenta', cuentas, 'cuenta') %>% 
  create_df('id_op', operaciones, 'operacion')
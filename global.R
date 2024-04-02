library(readxl)
library(dplyr)
library(lubridate)

setwd('C:/Users/ed_22/Documents/SIO/Procesados')

db <- read_excel('dic2023.xlsx')
instituciones <- read_excel('instituciones.xlsx')
cuentas <- read_excel('cuentas.xlsx')
trimestres <- read_excel('trimestres.xlsx')
operaciones <- read_excel('operaciones.xlsx')

get_id <- function(concept, ref_table){
  # Filter rows based on a condition using one-dimensional logical vectors
  id_concept <- ref_table %>%
    filter(nombre %in% concept) %>%
    pull(id)
  return(id_concept)
}

get_name <- function(id_filter, ref_table) {
  table_names <- ref_table[ref_table$id %in% id_filter, "nombre"]
  return(table_names)
}


class(trimestres$nombre)
trimestres$nombre <- ymd(trimestres$nombre)
class(trimestres$nombre)

# testing
get_id('Plan Seguro', instituciones)
instituciones
get_id(c('Total', 'Fianzas'), operaciones)
operaciones
get_id(c('Colectivo', 'Total', 'Penales'), operaciones)
operaciones
get_id(ymd('2023-12-31'), trimestres)
trimestres

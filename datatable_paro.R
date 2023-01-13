library(tidyverse)
library(sf)
library(tmap)

fs::dir_create("pruebas") #- primero creamos la carpeta "pruebas"
my_url <- "https://www.ine.es/jaxi/files/tpx/es/csv_bdsc/48895.csv?nocab=1"
curl::curl_download(my_url, "./pruebas/actividad_empleo.csv")

actividad_empleo <- rio::import("./pruebas/actividad_empleo.csv")

# Limpiamos y btenemos los datos que queremos
empleo_paro <- actividad_empleo %>% 
  filter(`Tasas de actividad, empleo y paro` == "Tasa de empleo" | `Tasas de actividad, empleo y paro` == "Tasa de paro") %>%
  slice(-c(1:2)) %>%
  slice(c(1:222)) %>%
  select(-c("Sexo")) %>%
  rename("Tasas de empleo y paro" = "Tasas de actividad, empleo y paro") 

empleo_paro <- janitor::clean_names(empleo_paro)

# Lo ponemos bonito
colnames(empleo_paro)[1] <- "Titulación"
colnames(empleo_paro)[2] <- "Tipo de Tasa"
colnames(empleo_paro)[3] <- "Total"

# Hacemos el datatable de los datos
DT::datatable(empleo_paro, filter = 'top', 
              options = list(pageLength = 7, autoWidth = TRUE ))

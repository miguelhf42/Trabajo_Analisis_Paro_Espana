library(tidyverse)

fs::dir_create("pruebas") #- primero creamos la carpeta "pruebas"
my_url <- "https://www.ine.es/jaxi/files/tpx/es/csv_bdsc/48895.csv?nocab=1"
curl::curl_download(my_url, "./pruebas/actividad_empleo.csv")

actividad_empleo <- rio::import("./pruebas/actividad_empleo.csv")


actividad <- actividad_empleo %>% 
  filter(`Tasas de actividad, empleo y paro` == "Tasa de actividad") %>% 
  filter(Sexo == "Hombres") %>%
  filter(Titulación == "01 - EDUCACIÓN" | Titulación == "02 - ARTES Y HUMANIDADES" | Titulación == "03 - CIENCIAS SOCIALES, PERIODISMO Y DOCUMENTACIÓN" | Titulación == "04 - NEGOCIOS, ADMINISTRACIÓN Y DERECHO" | Titulación == "05 - CIENCIAS" | Titulación == "06 - INFORMÁTICA" | Titulación == "07 - INGENIERÍA, INDUSTRIA Y CONSTRUCCIÓN" | Titulación == "08 - AGRICULTURA, GANADERÍA, SILVICULTURA, PESCA Y VETERINARIA" | Titulación == "09 - SALUD Y SERVICIOS SOCIALES" | Titulación == "10 - SERVICIOS")

#limpiamos los datos 
dd <- janitor::clean_names(actividad)
actividad_limpio <- dd %>% mutate(total = stringr::str_replace(total, "," , "." ))
actividad_limpio <- actividad_limpio %>% mutate(total = as.numeric(total))

df <- actividad_limpio %>% arrange(total)


grafica_actividad <- ggplot(df, aes(x = titulacion, y = total)) + 
  geom_bar(stat = "identity" , fill = "blue") +  
  theme_light() + 
  coord_flip() +
  scale_x_discrete(limits = df$titulacion) +
  labs(title = "Tasa de actividad por titulación (Hombres)", caption = "Fuente: INE",x = "Titulación",y = "Tasa de actividad")

# Resaltamos la titulación de Negocios
negocios <- df %>% filter(titulacion %in% c("04 - NEGOCIOS, ADMINISTRACIÓN Y DERECHO"))

grafica_negocios <- grafica_actividad + 
  geom_bar(data = negocios, aes(x = titulacion, y = total), stat = "identity", fill = "green") + labs(title = "Tasa de actividad por titulación (Hombres)", caption = "Fuente: INE",x = "Titulación",y = "Tasa de actividad")

grafica_negocios


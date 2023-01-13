library(tidyverse)
library(ggplot2)
library(ggthemes)

fs::dir_create("pruebas") #- primero creamos la carpeta "pruebas"
my_url <- "https://www.ine.es/jaxiT3/files/t/es/csv_bdsc/12718.csv?nocab=1"
curl::curl_download(my_url, "./pruebas/graduados_anos.csv")

graduados_anos <- rio::import("./pruebas/graduados_anos.csv")

graduados_anos <- graduados_anos %>% filter(Sexo == "Hombres") %>% 
  slice(-c(41:44)) %>%
  slice(-c(47:50)) %>% 
  slice(-c(62))

#limpiamos los datos 
dd <- janitor::clean_names(graduados_anos)
graduados_limpio <- dd %>% mutate(total = stringr::str_replace(total, "," , "." ))
graduados_limpio <- graduados_limpio %>% mutate(total = as.numeric(total))

ggplot(data = graduados_limpio) + 
  geom_point(aes(x = periodo, y = total, color = niveles_educativos)) + 
  geom_line(aes(x = periodo, y = total, color = niveles_educativos, 
                group = niveles_educativos)) +  
  labs(title = "Graduados en distitintos niveles educativos", caption ="Fuente: INE", x = "Años", y = "Tasa de graduados", color = "Niveles Educativos") +  
  theme(legend.position = "right")

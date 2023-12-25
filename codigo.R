library(tidyverse)
library(readr)
dir.create(file.path("exportado"), showWarnings = FALSE)

# Carga de datos desde ISCIII
datos_covid <- read_csv(file = "https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv")

# Depuración
datos_madrid <-
  datos_covid |>
  # Filtrado por Madrid y fecha
  filter(provincia_iso == "M" & fecha <= "2020-12-31" & sexo != "NC") |> 
  # Selección de columnas
  select(provincia_iso:fecha, num_casos) |> 
  # Resumen de casos diarios por fecha y sexo
  summarise(num_casos = sum(num_casos), .by = c(fecha, sexo))

# Exportamos datos
write_csv(datos_madrid, file = "./exportado/datos_madrid.csv")

# Gráfica
ggplot(datos_madrid) +
  geom_line(aes(x = fecha, y = num_casos, color = sexo),
            alpha = 0.6, linewidth = 0.7) +
  scale_color_manual(values = c("#85519D", "#278862")) +
  facet_wrap(~sexo) +
  theme_minimal() +
  theme(legend.position = "bottom")

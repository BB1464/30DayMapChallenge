library(ggtext)
library(showtext)
library(tidyverse)
library(rnaturalearth)
library(giscoR)

font_add_google('Fira Sans','Fira Sans')

showtext.auto(enable = TRUE)




# Get the airport from Ukraine --------------------------------------------


airport <- gisco_get_airports(year = '2013',country = 'Ukr')


# Get the Ukraine Boundary ---------------------------------


Ukr <- ne_states(country = 'Ukraine',returnclass = 'sf')





# Plot ------------------------------------------------------


ggplot(data = Ukr)+geom_sf(aes(fill=woe_name),show.legend = FALSE)+geom_sf_text(aes(label=name))+guides('none')+theme_void()+geom_sf(data = airport,col=colorspace::darken(col = 'red',amount = 0.5),size=3)+
  labs(title =  glue::glue("There are {nrow(airport)} Airport in  Ukraine"),caption = 'Designer: Oluwafemi Oyedele | 30DaysMapChallenge')+theme(plot.title = element_markdown(family = 'Fira Sans',face = 'bold',size = 40,colour = 'white',hjust = 0.5),plot.background = element_rect(fill = 'black'),plot.caption = element_text(family = 'Fira Sans',face = 'bold',colour = 'white',size = 16,hjust = 0.9))+
  scale_fill_viridis_d()


# Save the Plot ---------------------------------------------

path <- here::here("Day1", "day1")
path <- paste0(path, "_2022")
ggsave(glue::glue("{path}.pdf"), width = 10.5, height = 10.5, device = cairo_pdf)

pdftools::pdf_convert(
  pdf = glue::glue("{path}.pdf"),
  filenames = glue::glue("{path}.png"),
  dpi = 640
)




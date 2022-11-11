
# Load the necessary packages

library(tidyverse)
library(sf)
library(rnaturalearth)
library(showtext)
library(ggtext)

# Font

font_add_google("Fira Sans","Fira Sans")

f1 = "Fira Sans"

showtext_auto(enable = TRUE)
showtext_opts(dpi=320)




Africa <- ne_countries(continent = 'Africa',returnclass = 'sf')


# Tidy data frame with colours

Africa_clean <- Africa |> mutate(Flag=if_else(condition = name %in%c('Algeria','Egypt','Libya','Morocco','Sudan','Tunisia','Burundi','Cameroon','Eritrea','Ethiopia','Kenya','Madagascar','Malawi','Mozambique','S. Sudan','Uganda','Zambia','Angola','Central African Rep.','Chad','Benin','Burkina Faso','Dem. Rep. Congo','Guinea','Swaziland','Gambia','Ghana','Guinea','Liberia','Mali','Namibia','Senegal','South Africa','Togo','Central African Rep.','Togo','South Africa'),true = 'red',false = 'gray60'))


# Plot

ggplot(data = Africa_clean)+
  geom_sf(aes(fill=Flag),show.legend = FALSE)+
  scale_fill_identity()+
  coord_sf()+
  theme_void()+
  geom_sf_text(aes(label=sov_a3),check_overlap = TRUE)+
  labs(title = "<span style = 'font-size:45pt; font-family:f1;'>
African Countries that has red on their <span style = 'color:red;'>Flag !!!</span>
",caption = 'Data: rnaturalearthdata |Designer: Oluwafemi Oyedele')+
  theme(plot.background = element_rect(fill = '#543288',colour = NA),panel.background = element_rect(fill = '#543288',colour = NA),plot.caption = element_text(family = f1,face = 'bold',colour = 'white',size = 28,hjust = 0.8),plot.title = element_markdown(family = f1,face = 'bold',colour = 'white',size = 80,hjust = 0.5))


## Save the plot

ggsave('Day11.png',path = here::here('2022/Day11-Red/'),width = 14,height = 14,dpi = 320)

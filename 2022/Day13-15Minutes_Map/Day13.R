
# Import the Required Packages --------------------------------------------

library(tidyverse)
library(rnaturalearth)
library(sf)
library(showtext)
library(ggtext)

# Font

font_add_google(name = 'Roboto',family = 'Roboto')
showtext_auto(enable = TRUE)
showtext_opts(dpi=300)

## Africa Region
Africa <- ne_countries(continent = 'Africa',returnclass = 'sf')



# Plotting -----------------------------------------------------


Africa <- Africa |> mutate(Region=if_else(condition = admin %in%c('Ivory Coast','Nigeria','Ghana','Cameroon'),true = '#653803',false = 'gray80')) 



ggplot()+
  geom_sf(data = Africa,aes(fill=Region))+
  scale_fill_identity()+
  coord_sf()+
  theme_void()+
  labs(title = "<span style = 'font-size:25pt; font-family:Roboto;'>
<span style = 'color:#653803;'> Ivory Coast, Ghana, Nigeria and Cameroon</span> are the Largest Producers of Cocoa in Africa !!!",caption = '# 30DayMapChallenge| Oluwafemi Oyedele')+
  theme(plot.title = element_markdown(family = 'Roboto',face = 'bold',colour = 'white',hjust = 0.5),plot.caption = element_text(family = 'Roboto',face = 'bold',colour = 'white',size = 20,hjust = 0.8),plot.background = element_rect(fill = 'black',colour = NA),panel.background = element_rect(fill = 'black',colour = NA))



## Save the plot

ggsave('Day13.png',path = here::here('2022/Day13-15Minutes_Map/'),width = 16,height = 16,dpi = 270)

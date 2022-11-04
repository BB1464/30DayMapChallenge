

# Import the Required Packages --------------------------------------------

library(rnaturalearth)
library(tidyverse)
library(sf)

# Get the shape file

NG <- ne_states(country = 'Nigeria',returnclass = 'sf')


## Convert the data to an sf object

NG_sf <- NG |> 
  st_as_sf(coords=c('longitude','latitude'))

## Plot the map

NG_sf |> 
  mutate(name=if_else(condition = name=='Federal Capital Territory',true = 'FCT',false = name)) |> 
  ggplot()+
  geom_sf(col='white',fill='green')+
  geom_sf_text(aes(label=name,font='serif'))+
  labs(title = 'Map Showing the States in Nigeria!!!',caption = 'Designer: Oluwafemi Oyedele | BB1464')+
  theme_void()+
  theme(plot.background = element_rect(fill = 'black',colour = 'black'),plot.caption = element_text(family = 'serif',face = 'bold',colour = 'white',size = 14,hjust = 0.9),plot.title = element_text(family = 'serif',face = 'bold',colour = 'white',size = 45,hjust = 0.5))


# Save the Plot -----------------------------------------------------------


ggsave('Day4.png',path = here::here('2022/Day4-Colour_Friday_Green/'),width = 11,height = 10,dpi = 270)  

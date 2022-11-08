

# Load the Required Packages -----------------------------------

library(osmdata)
library(tidyverse)
library(sf)
library(showtext)


# Font

font_add_google("Fira Sans","Fira Sans")

f1 = "Fira Sans"

showtext_auto(enable = TRUE)
showtext_opts(dpi=320)



#choose location to plot

town <- 'London'

getbb(town)

location <- town %>% opq()

# Make use of  coordinates

coords <- matrix(c(-0.1,-0.07,51.5,51.52), byrow = TRUE, nrow = 2, ncol = 2, dimnames = list(c('x','y'),c('min','max')))


location <- coords %>% opq()

#create different types of streets

# Add Main Street

main_st <- data.frame(type = c("motorway","trunk","primary","motorway_junction","trunk_link","primary_link","motorway_link"))

st <- data.frame(type = available_tags('highway'))

st <- subset(st, !type %in% main_st$type)

path <- data.frame(type = c("footway","path","steps","cycleway"))

st <- subset(st, !type %in% path$type)

st <- as.character(st$type)

main_st <- as.character(main_st$type)

path <- as.character(path$type)

#save different features

## Save the Main Street

main_streets <- location %>%
  add_osm_feature(key = "highway", 
                  value = main_st) %>%
osmdata_sf()

## Save the Street

streets <- location %>%
  add_osm_feature(key = "highway", 
                  value = st) %>%
  osmdata_sf()


## Save the waters

water <- location %>%
  add_osm_feature(key = "natural", 
                  value = c("water")) %>%
  osmdata_sf()


## Save the rail

rail <- location %>%
  add_osm_feature(key = "railway", 
                  value = c("rail")) %>%
  osmdata_sf()

## Save the parks

parks <- location %>%
  add_osm_feature(key = "leisure", 
                  value = c("park","nature_reserve","recreation_ground","golf_course","pitch","garden")) %>%
  osmdata_sf()

## Save the Building
buildings <- location %>%
  add_osm_feature(key = "amenity", 
                  value = "pub") %>%
  osmdata_sf()

#plot

ggplot() + 
  geom_sf(data = main_streets$osm_lines, color = '#ff9999', size = 2) + 
  geom_sf(data = streets$osm_lines, size = 1.5, color = '#eedede') +
  geom_sf(data = water$osm_polygons, fill = '#c6e1e3') +
  geom_sf(data = water$osm_multipolygons, fill = '#c6e1e3') +
  geom_sf(data = rail$osm_lines, color = '#596060', size = 1) +
  geom_sf(data = parks$osm_polygons, fill = '#94ba8e') +
  geom_sf(data = buildings$osm_polygons, color = '#40493f', fill = '#40493f', size = 1) +
  coord_sf(xlim = c(coords[1], coords[1,2]), 
           ylim = c(coords[2], coords[2,2]),
           expand = FALSE) + theme_void()+
  labs(caption = "Data: {osmdata} Lagos, Nigeria | Map: Oluwafemi Oyedele (@OluwafemOyedele)",title = 'Basic Amenities in London !!!')+
  theme(plot.caption = element_text(family = f1,face = 'bold',colour = 'black',size = 15,hjust = 0.8),plot.title = element_text(family = f1,face = 'bold',colour = 'black',size = 45,hjust = 0.5))
 
# Save the Plot

ggsave('Day8.png',path = here::here('2022/Day8-OSM/'),width = 12,height = 12,dpi = 230,bg = 'white')

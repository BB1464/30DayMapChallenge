
# Load the Required Packages -----------------------------------

library(ggplot2)
library(sf)
library(rnaturalearth)

# assign a projection, for example ... 
crs <- 3035

# get data for the world map and assign the projection
world <- ne_countries(scale = "medium", returnclass = "sf")
world <- st_transform(world, crs = crs)

# create data frame with three points, convert it to a spatial object 
# and assign the same projection
points <- data.frame(longitude = c(-105.2519, 10.7500, 2.9833),
                     latitude = c(40.0274, 59.9500, 39.6167))

points <-  st_as_sf(points, coords = c("longitude", "latitude"), crs = crs)

# plot the data with ggplot2:
ggplot() + 
  geom_sf(data = world,col='green') +
  geom_sf(data = points, color = "black",size=4)+
  theme_void()+
  labs(title = 'Baddest Map of the World !!!',caption = '#30DayMapChallenge |BB1464')+
theme(plot.background = element_rect(fill = '#453290',colour=NA),plot.caption = element_text(family = 'serif',face = 'bold',colour = 'red',size = 23,hjust = 0.8),plot.title = element_text(family = 'serif',face = 'bold',colour = 'red',size = 50,hjust = 0.5),panel.background = element_rect(fill = '#453290',colour = NA))


## Save the Plot

ggsave('Day10.png',path = here::here('2022/Day10-Bad-Map/'),width = 10,height = 10,dpi = 270)

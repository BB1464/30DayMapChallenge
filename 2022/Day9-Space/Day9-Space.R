
# Load the Required Packages ----------------------------------

library(sf)
library(giscoR) # for the countries dataset only
library(tidyverse)
library(showtext)
library(ggtext)

#### MISC ####

font <- "Albert Sans"

font_add_google(family=font, font,db_cache = FALSE)


showtext_auto(enable = TRUE)

bg <- "#DFE3E8"

txt_col <- "black"

col1 <- "#1A3399"

col2 <- "#7E1900"



# projection string used for the polygons & ocean background
crs_string <- "+proj=ortho +lon_0=30 +lat_0=30"

# background for the globe - center buffered by earth radius
ocean <- st_point(x = c(0,0)) %>%
  st_buffer(dist = 6371000) %>%
  st_sfc(crs = crs_string)

# country polygons, cut to size
world <- gisco_countries %>% 
  st_intersection(ocean %>% st_transform(4326)) %>% # select visible area only
  st_transform(crs = crs_string) # reproject to ortho

# one of the visible ones red (don't really matter which one :)
world$fill_color <- ifelse(world$ISO3_CODE == "NGA", "interesting", "dull")




# now the action!
ggplot(data = world) +
  geom_sf(data = ocean, fill = "#261E2C", color = NA) + # background first
  geom_sf(aes(fill = fill_color), lwd = .1) + # now land over the oceans
  scale_fill_manual(values = c("interesting" = "#3C7AF1",
                               "dull" = "3C7AF190"),
                    guide = "none") +
  theme_void()+
  labs(caption = "Data:  giscoR | Graphic: Oluwafemi Oyedele",title = "<span style = 'font-size:90pt; font-family:font;'>
Area View of <span style = 'color:#3C7AF1;'>Nigeria</span>
from the rest of the<span style = 'color:lightgreen;'>World</span>")+
  theme(plot.caption = element_text(family = font,face = 'bold',colour = 'white',size = 60,hjust = 0.8),plot.background = element_rect(fill = col2,colour = NA),panel.background = element_rect(fill = col2,colour = NA),plot.title = element_markdown(family = font,face = 'bold',hjust = 0.5))


# Save the Plot

ggsave('Day9.png',path = here::here('2022/Day9-Space/'),width = 12,height = 12,dpi = 230)

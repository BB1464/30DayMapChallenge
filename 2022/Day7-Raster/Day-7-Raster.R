

# Load the Required Library ---------------------------------

library(tidyverse)
library(afrilearndata)
library(raster)
library(sp)
library(scico)
library(showtext)
library(ggtext)



afripop_df <- afripop2020 %>% 
  as.data.frame(xy = TRUE) %>% 
  rename(pop = 3) %>% 
  filter(!is.na(pop))

# Font

font_add_google("Fira Sans","Fira Sans")

f1 = "Fira Sans"

showtext_auto(enable = TRUE)
showtext_opts(dpi=320)



# Plot

ggplot(afripop_df) +
  geom_tile(aes(x, y, fill = pop)) +
  scale_fill_scico(direction = -1, trans = "pseudo_log", palette = "bamako", breaks = c(0, 100, 1000, 10000, 20000))+
  labs(
    title = "<span style = 'font-size:32pt; font-family:f1;'>
Areas of <span style = 'color:#556B2F;'>high</span>
and <span style = 'color:#CDAA7D;'>low</span> population density in Africa !!!"
  )+
  guides(fill = guide_colorbar(title = "Population density\n(people/km²)", label.position = "left", title.hjust = 0.5)) +
  labs(caption = "Data: afrilearndata | Graphic: Oluwafemi Oyedele") +
  coord_fixed() +
  theme_void(base_family = f1, base_size = 14) +
  theme(
    legend.position = 'none',
    legend.key.width = unit(0.6, "line"),
    legend.key.height = unit(2, "line"),
    legend.title = element_text(margin = margin(0, 0, 10, -20), color = "grey85", lineheight = 1.1),
    legend.text = element_text(color = "grey85"),
    plot.background = element_rect(fill = "black", color = 'black'),
    plot.caption = element_text(hjust = 0.8, color = "white",size = 25,face = 'bold'),
    plot.margin = margin(10, 10, 10, 10),panel.background = element_rect(fill = 'black',colour = NA),plot.title = element_markdown(family = f1,face = 'bold',size = 32,colour = 'white')
  )



# Save the Plot

ggsave('Day7.png',path = here::here('2022/Day7-Raster/'),width = 18,height = 18,dpi = 230)



# Load the Required Library ---------------------------------

library(tidyverse)
library(afrilearndata)
library(raster)
library(sp)
library(scico)
library(showtext)




afripop_df <- afripop2020 %>% 
  as.data.frame(xy = TRUE) %>% 
  rename(pop = 3) %>% 
  filter(!is.na(pop))

# Font

font_add_google("Fira Sans","Fira Sans")

f1 = "Fira Sans"

showtext_auto(enable = TRUE)
showtext_opts(dpi=320)


ggplot(afripop_df) +
  geom_tile(aes(x, y, fill = pop)) +
  annotate("text", -6, -5, label = "Africa", family = f1, size = 20, fontface = "bold", color = "grey97") +
  scale_fill_scico(direction = -1, trans = "pseudo_log", palette = "lajolla", breaks = c(0, 100, 1000, 10000, 20000)) +
  guides(fill = guide_colorbar(title = "Population density\n(people/km²)", label.position = "left", title.hjust = 0.5)) +
  labs(caption = "Data: afrilearndata · Graphic: Oluwafemi Oyedele") +
  coord_fixed() +
  theme_void(base_family = f1, base_size = 14) +
  theme(
    legend.position = c(0.22, 0.23),
    legend.key.width = unit(0.6, "line"),
    legend.key.height = unit(2, "line"),
    legend.title = element_text(margin = margin(0, 0, 10, -20), color = "grey85", lineheight = 1.1),
    legend.text = element_text(color = "grey85"),
    plot.background = element_rect(fill = "#58507E", color = "#58507E"),
    plot.caption = element_text(hjust = 1, color = "white",size = 20,face = 'bold'),
    plot.margin = margin(10, 10, 10, 10),panel.background = element_rect(fill = '#58507E',colour = NA)
  )



# Save the Plot

ggsave('Day7.png',path = here::here('2022/Day7-Raster/'),width = 12,height = 12,dpi = 230)


# Load the Required Packages -----------------------------------

library(tidyverse)
library(ggtext)
library(showtext)
library(grid)
library(geosphere)

## Font
font_add_google('Fira Sans','Fira Sans')

text_font <- 'Fira Sans'


showtext_auto(enable = TRUE)



# Import the dataset -----------------------------------------

data <- read.table("https://github.com/holtzy/data_to_viz/raw/master/Example_dataset/19_MapConnection.csv", header=T, sep=",")



# Download NASA night lights image

download.file("https://www.nasa.gov/specials/blackmarble/2016/globalmaps/BlackMarble_2016_01deg.jpg",destfile = "2022/Day6-Network/BlackMarble_2016_01deg.jpg", mode = "wb")
              
              
              


# Load picture and render

earth <- jpeg::readJPEG("2022/Day6-Network/BlackMarble_2016_01deg.jpg", native = TRUE)

earth <- rasterGrob(earth, interpolate = TRUE)

# Count how many times we have each unique connexion + order by importance
summary=data %>% 
  dplyr::count(homelat,homelon,homecontinent, travellat,travellon,travelcontinent) %>%
  arrange(n)

# A function that makes a dataframe per connection (we will use these connections to plot each lines)

data_for_connection=function( dep_lon, dep_lat, arr_lon, arr_lat, group){
  inter <- gcIntermediate(c(dep_lon, dep_lat), c(arr_lon, arr_lat), n=50, addStartEnd=TRUE, breakAtDateLine=F)             
  inter=data.frame(inter)
  inter$group=NA
  diff_of_lon=abs(dep_lon) + abs(arr_lon)
  if(diff_of_lon > 180){
    inter$group[ which(inter$lon>=0)]=paste(group, "A",sep="")
    inter$group[ which(inter$lon<0)]=paste(group, "B",sep="")
  }else{
    inter$group=group
  }
  return(inter)
}


data_ready_plot=data.frame()

for(i in c(1:nrow(summary))){
  tmp=data_for_connection(summary$homelon[i], summary$homelat[i], summary$travellon[i], summary$travellat[i] , i)
  tmp$homecontinent=summary$homecontinent[i]
  tmp$n=summary$n[i]
  data_ready_plot=rbind(data_ready_plot, tmp)
}


data_ready_plot$homecontinent=factor(data_ready_plot$homecontinent, levels=c("Asia","Europe","Australia","Africa","North America","South America","Antarctica"))



# Plot

# Plot
p <- ggplot() +
  annotation_custom(earth, xmin = -180, xmax = 180, ymin = -90, ymax = 90) +
  geom_line(data=data_ready_plot, aes(x=lon, y=lat, group=group, colour=homecontinent, alpha=n), size=0.6) +
  scale_color_brewer(palette="Set3") +
  theme_void() +
  theme(
    legend.position="none",
    panel.background = element_rect(fill = "black", colour = "black"), 
    panel.spacing=unit(c(0,0,0,0), "null"),
    plot.margin=grid::unit(c(0,0,0,0), "cm"),
  ) +
  ggplot2::annotate("text", x = -150, y = -45, hjust = 0, size = 11, label = paste("Where surfers travel."), color = "white") +
  ggplot2::annotate("text", x = -150, y = -51, hjust = 0, size = 8, label = paste("#30DayMapChallenge | NASA.gov | 10,000 #surf tweets recovered"), color = "white", alpha = 0.5) +
  xlim(-180,180) +
  ylim(-60,80) +
  scale_x_continuous(expand = c(0.006, 0.006)) +
  coord_equal()

# Save at PNG
ggsave("2022/Day6-Network/Day6.png", width = 36, height = 15.22, units = "in", dpi = 90)

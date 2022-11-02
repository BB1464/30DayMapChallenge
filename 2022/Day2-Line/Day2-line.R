
# Set up the system font
windowsFonts(georg = windowsFont('Georgia')) 


# Load the Required Packages ----------------------------------------------


pacman::p_load(tidyverse,sf,giscoR,ggfx,ggtext)




# Download the Railway Shapefile for Africa -------------------------------
#europeList

Africa_List <- function(urlfile, iso3DF) {
  
  urlfile <-'https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv'
  
  iso3DF <- read.csv(urlfile) %>%
    filter(region=="Africa") %>%
    select(`alpha.3`) %>%
    dplyr::rename(iso3 =`alpha.3`)
  
  return(iso3DF)

}

iso3DF <- Africa_List()


# Create the Directory for the Shape File ---------------------------------


# create a directory for railway SHPs

dir <- file.path(tempdir(), 'rail')


dir.create(dir)

## Dont download again


downloadSHP <- function(urls) {

  # make URL for every country

  urls <- paste0("https://biogeo.ucdavis.edu/data/diva/rrd/",
                  iso3DF$iso3, "_rrd.zip")

# iterate and download
   lapply(urls, function(url) download.file(url, file.path(dir, basename(url))))
 }


# # Download the Shape File -------------------------------------------------


 downloadSHP()



# # Unzip and Load the Data -------------------------------------------------



unzipSHP <- function(urls,path) {
  filenames <- list.files(dir, full.names=T)
  lapply(filenames, unzip)
}

# 
# # Unzip the Shape File ----------------------------------------------------
# 
 
 unzipSHP()
 

### Load the data

loadSHP <- function(SHPs, rails) {
  #create a list of railway shapefiles for import
  SHPs <- list.files(pattern="_rails.*\\.shp$")
  
  #Use lapply to import all shapefiles in the list
  rails <- lapply(SHPs, function(rail_shp) {
    rail <- st_read(rail_shp) %>%  #next, read all shp files as "sf" object and assign WSG84 projection
      st_transform(crs = 4326)
    return(rail)
  }) %>% 
    bind_rows() #finally, merge rail lines into single data.frame
  
  return(rails)
}


# Load the Rails File -----------------------------------------------------


rails <- loadSHP()



# Get Africa Shapefile ----------------------------------------------------


africaMap <- function(africa) {
  
  africa <- giscoR::gisco_get_countries(
    year = "2016",
    epsg = "4326",
    resolution = "10",
    region = "Africa"
  )
  
  return(africa)
}


# Get the Africa Map  -----------------------------------------------------


africa <- africaMap()


# Map the Africa Rail Way Line --------------------------------------------


ggplot()+with_outer_glow(geom_sf(data = rails,color='lightgoldenrod1',size=0.3,fill=NA),colour='lightgoldenrod1',sigma=15)+geom_sf(data = africa,color='grey80',size=0.05,fill=NA)+theme_minimal()+theme(
  axis.line = element_blank(),
  axis.text.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks = element_blank(),
  axis.title.x = element_text(size=9, color="grey80", hjust=0.25, vjust=3, family = "mono"),
  axis.title.y = element_blank(),
  legend.position = "none",
  panel.grid.major = element_line(color = "black", size = 0.2),
  panel.grid.minor = element_blank(),
  plot.title = element_markdown(face="bold", size=24, color="grey80", hjust=.5, family = "mono"),
  plot.margin = unit(c(t=1, r=-2, b=-1, l=-2),"lines"),
  plot.background = element_rect(fill = "black", color = NA), 
  panel.background = element_rect(fill = "black", color = NA), 
  legend.background = element_rect(fill = "black", color = NA),
  panel.border = element_blank()) +
  labs(x = "Designer: Oluwafemi Oyedele\n Data: DIVA-GIS, https://www.diva-gis.org/", 
       y = NULL, 
       title = "Africa <span style = 'color: lightgoldenrod1;'>railways</span>", 
       subtitle = "", 
       caption = "")



## Save The Plot

ggsave(filename="day2.png", width= 8.5, height= 7, dpi = 600, device='png',path = here::here('2022/Day2-Line/'))

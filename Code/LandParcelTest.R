#Plot land parcels map. And all WFD sites in the bounding box
# Authors: Gordon Donald, Ani Setchi

# Libs
# install.packages("sf")
library(sf)
# install.packages("dplyr")
library(dplyr)
# install.packages("rgdal")
library(rgdal)
# install.packages("ggplot2")
library(ggplot2)

#Get land parcels.
inputfilepath = "Data/HMLR_Exeter_Extract_int_LPIS.json"
#inputfilepath = "landparcels/HMLR_Poly_Sample_JOIN_int_LPIS.json"
sf_lp <- st_read(inputfilepath, quiet = TRUE)

#Want an 'auxillary data set' which has the land parcel title number and some random number we will use as pretend enivronmental data.
lp_luck = data.frame("TITLE_NO"=sf_lp$TITLE_NO, "luck"=runif(sf_lp$OBJECTID,0,100))

outputfilepath = paste(tools::file_path_sans_ext(inputfilepath),".csv")
write.csv(lp_luck, file = outputfilepath,fileEncoding = "UTF-8")

#Okay, now we can pretend we have an external data source.
suppressWarnings({
  sf_env_data <- left_join(sf_lp, lp_luck, by = "TITLE_NO")
})
head(sf_env_data)

plot(
  ggplot() +                                                                          # initialise a ggplot object
    geom_sf(data = sf_env_data,                                                      # add a simple features (sf) object
            aes(fill = cut_number(luck, 5)),                                       # group percent into equal intervals and use for fill
            alpha = 0.8,                                                              # add transparency to the fill
            colour = 'black',                                                         # make polygon boundaries white
            size = 0.3) +                                                             # adjust width of polygon boundaries
    scale_fill_brewer(palette = "PuBu",                                               # choose a http://colorbrewer2.org/ palette
                      name = "Random number [0,100]") +                               # add legend title
    labs(x = NULL, y = NULL,                                                          # drop axis titles
         title = "Land parcels coloured by pretend (random) environmental variable")+      # add title
    #subtitle = "Source: Table QS502EW, Census 2011",                             # add subtitle
    #caption = "Contains OS data © Crown copyright and database right (2018)") +  # add caption
    theme(panel.background = element_blank())                                        # remove background gridlines
  #  line = element_blank(),                                                     # remove axis lines
  #axis.text = element_blank(),                                                # remove tick labels
  #axis.title = element_blank(),                                               # remove axis labels
  #coord_sf(datum = NA)               
)



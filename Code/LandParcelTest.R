#Plot land parcels map with a data layer
# Authors: Ani Setchi, Gordon Donald

# libraries ---------------------------------------------------------------
# install.packages("sf")
library(sf)
# install.packages("dplyr")
library(dplyr)
# install.packages("rgdal")
library(rgdal)
# install.packages("ggplot2")
library(ggplot2


# Get land parcels
inputfilepath = "Data/HMLR_Poly_Sample_JOIN_int_LPIS.json"
boundaries <- st_read(inputfilepath, quiet = TRUE)
plot(boundaries$geometry)


# Match in data, here using the perimeters and area already in the data. But you could match from elsewhere too
lp_data <-  data.frame("TITLE_NO"=boundaries$TITLE_NO, "Area"= boundaries$Shape_Area)
boundaries_data <- left_join(boundaries, lp_data, by = "TITLE_NO")


plot(
  ggplot() +                                                                          # initialise a ggplot object
    geom_sf(data = boundaries_data,                                                   # add a simple features (sf) object
            aes(fill = cut_number(Area, 5)),                                     # group percent into equal intervals and use for fill
            alpha = 0.8,                                                              # add transparency to the fill
            colour = 'black',                                                         # make polygon boundaries white
            size = 0.3) +                                                             # adjust width of polygon boundaries
    scale_fill_brewer(palette = "PuBu",                                               # choose a http://colorbrewer2.org/ palette
                      name = "Area") +                                                # add legend title
    labs(x = NULL, y = NULL,                                                          # drop axis titles
         title = "Land parcels coloured by area") +                                   # add title
    #subtitle = "Source: Table QS502EW, Census 2011",                                 # add subtitle
    #caption = "Contains OS data © Crown copyright and database right (2018)") +      # add caption
    theme(panel.background = element_blank())                                         # remove background gridlines
    #line = element_blank(),                                                          # remove axis lines
    #axis.text = element_blank(),                                                     # remove tick labels
    #axis.title = element_blank(),                                                    # remove axis labels
    #coord_sf(datum = NA)               
)



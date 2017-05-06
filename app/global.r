library(dplyr)

library(rgdal)
require(maptools)
library(readr)
options(scipen=999)

blockgroups<- readOGR("phl1328blkgs2010xy.geojson","OGRGeoJSON")

#names(blockgroupsdata)
#install.packages('rmarkdown')

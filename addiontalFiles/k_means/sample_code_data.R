library(dplyr)
options(scipen=999)
# for cluster analysis
library(NbClust)

#==============================sample code for census data joining=================================

#===================================Cleaning Census Data for total population 2015============================================
#Pennsylvania,Philadelphia County --> COUNTYA == 101
#Washington,King County --> STATEA == 53 AND COUNTYA == 33

phl2015pop <-as.data.frame(read.csv("E:/capstone/censusdata/nhgis0008_csv_blk_tpop/nhgis0008_csv/nhgis0018_ds176_20105_2010_blck_grp.csv"))
phl2015pop <- phl2015pop[which(phl2015pop$COUNTYA==101),]
names<-data.frame(names(phl2015pop))
phl2015popClean <- phl2015pop[,c(1,37)]
colnames(phl2015popClean)[2] <- "phl2010pop"

write.csv(phl2015popClean, file = "E:/capstone/censusdata/nhgis0008_csv_blk_tpop/nhgis0008_csv/phl2010popClean.csv")

sea2015pop <- as.data.frame(read.csv("E:/capstone/censusdata/nhgis0008_csv_blk_tpop/nhgis0008_csv/nhgis0018_ds176_20105_2010_blck_grp.csv"))
sea2015pop<-sea2015pop[which(sea2015pop$STATEA==53&sea2015pop$COUNTYA==33),]
sea2015popClean <-sea2015pop[,c(1,37)]
colnames(sea2015popClean)[2]<-"KC2010pop"

write.csv(sea2015popClean, file = "E:/capstone/censusdata/nhgis0008_csv_blk_tpop/nhgis0008_csv/sea2010popClean.csv")


#===========================sample code for K-means analysis===========================
#==================================Row Combining for Cluster Analysis========================
phl_1328 <- as.data.frame(read.csv(file = "E:/capstone/philla/phl1328finished_v2.csv"))
sea_481 <- as.data.frame(read.csv(file = "E:/capstone/seattle/seattle481_v2.csv"))


#select GISJOINID and 26 variables for Philly
phl_names <-as.data.frame(names(phl_1328))
phlSel <- phl_1328[,c(16:42)]
nrow(phlSel) #1328
phlSelNames <- as.data.frame(names(phlSel))

#select GISJOINID and 26 variables for Seattle
sea_names<-as.data.frame(names(sea_481))
seaSel <- sea_481[,c(19:45)]
nrow(seaSel) #481
seaSelNames <-as.data.frame(names(seaSel))

#checking unmatched column names
all.equal(phlSelNames,seaSelNames)

SeaPhl <- rbind.data.frame(seaSel, phlSel)
nrow(SeaPhl) # 1809 = 1328+481

#======================================Scree Plot==================================
df1 <- data.frame(scale(SeaPhl[3:28]))

# Generate Scree Plot
wss1 <- (nrow(df1)-1)*sum(apply(df1,2,var))

# Set up max # of clusters as 40
for (i in 2:40) wss1[i] <- sum(kmeans(df1, centers=i)$withinss)

plot(1:40, wss1, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares", 
     main="Scree Plot for 60 Clusters")

#==========Manually run 26 criteria to find the optimal partitioning ===================
# All methods - index - can be found here:https://cran.r-project.org/web/packages/NbClust/NbClust.pdf
# Reason for manually running the method: it is unknown which methods cannot produce ourcomes and the 
# it will take forever forever forever to wait for the results when using **index="all"**

# Manually running a single method, called "hubert, index = "hubert"
set.seed(1234)
nc <- NbClust(df1, min.nc=2, max.nc=40, method="kmeans", index="hubert")
nc$Best.nc

#==========Use a # of clusters suggested from above to partition the dataset============
set.seed(1234)
fit.km1 <- kmeans(df1, 11, nstart=40) # 2,3,4,11
# Check the size of each cluster
fit.km1$size
# Join clustering group data back to original dataset
SeaPhlv1$CL11 <- fit.km1$cluster # CL2, CL3,CL4,CL1

write.csv(SeaPhlv1,"SeaPhlv2_CL2.csv")

# Generate mean values for each variable in each cluster group
summaryData<-round(aggregate(SeaPhl[,c(3:28)], by=list(cluster=fit.km1$cluster), mean),1)
# Transpose the data frame for better readability 
t(summaryData)

# Find the targer cluster where the block group of Amazon Go is located
amazonGo <- SeaPhlv1[which(SeaPhlv1$GISJOINID=='G53003300072001'),]
amazonGo
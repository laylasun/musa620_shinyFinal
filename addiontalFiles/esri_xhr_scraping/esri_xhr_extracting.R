library(jsonlite)
library(dplyr)
library(lubridate)
library(readr)
#install.packages("readr")
#install.packages("purrr")
library(magrittr)
library(stringr)
library(purrr)

getwd()
setwd("E:/capstone/forR/webscraping")
options(scipen=999)

phl60bgs <-read_csv("60BlkGroup2.csv")
names(phl60bgs)

phl60bgs %>%
  print(n=12,width=Inf)

phl60bgs %<>%
  mutate(json_spend="NA",json_retail ="NA",json_groc="NA",X1001_A=as.numeric(0),	X15001_A=as.numeric(0),
         RTSALESTOT=as.numeric(0),	RETPOTTOT=as.numeric(0),	LSFRETTOT=as.numeric(0),	RETBUSTOT=as.numeric(0),
         RSALES4411=as.numeric(0),	RETPOT4411=as.numeric(0),	LSF4411=as.numeric(0),	RETBUS4411=as.numeric(0),	
         RSALES4451=as.numeric(0), RETPOT4451=as.numeric(0),	LSF4451=as.numeric(0),	RETBUS4451=as.numeric(0),	
         RSALES448=as.numeric(0),	RETPOT448=as.numeric(0),	LSF448=as.numeric(0),	RETBUS448=as.numeric(0),	
         RSALES722=as.numeric(0),	RETPOT722=as.numeric(0),	LSF722=as.numeric(0), RETBUS722=as.numeric(0),
         RSALES445=as.numeric(0),	RETPOT445=as.numeric(0),	LSF445=as.numeric(0),	RETBUS445=as.numeric(0),
         RSALES4452=as.numeric(0),	RETPOT4452=as.numeric(0),	LSF4452=as.numeric(0),	RETBUS4452=as.numeric(0),
         RSALES4453=as.numeric(0),	RETPOT4453=as.numeric(0),	LSF4453=as.numeric(0),	RETBUS4453=as.numeric(0)
         )
#RETBUS722	RSALES445	RETPOT445	LSF445	RETBUS445	RSALES4451	RETPOT4451	LSF4451	RETBUS4451	RSALES4452	RETPOT4452	LSF4452	RETBUS4452	RSALES4453	RETPOT4453	LSF4453	RETBUS4453

# Find the corresponding blockgroup ID -> GEOID10
x<-1
geoid<-dRetail[x,]$ID
geoid
fid<- phl60bgs[which(phl60bgs$GEOID10== geoid),]$FID
targetIndex <-fid+1
targetIndex

phl60bgs[targetIndex,17]<-r
phl60bgs[targetIndex,18]<-s
phl60bgs[targetIndex,19]<-g

# Extract spending data
# spending data [20]X1001_A: 2016 average annual budget expenditures
# [21]X15001_A:2016 average amount spent per household on retail goods 
phl60bgs[targetIndex,20]<-dSpendingAttr[x,]$X1001_A
phl60bgs[targetIndex,21]<-dSpendingAttr[x,]$X15001_A

# Extract retail data col 22-41, source data 4-23
for(i in 22:41){
  #j in 4:23
  j=i-18
 phl60bgs[targetIndex,i]<-dRetail[x,j]
}

# Extract grocery data
for(i in 42:53){
  #j in 8:19
  j=i-34
  phl60bgs[targetIndex,i]<-dGroc2[x,j]
}


write.csv(phl60bgs,"phl60bgs_esri.csv")

# Checking
phl60bgs[targetIndex,c(6,42:53)]%>%
  print(n=12,width=Inf)
dGroc2[x,]
phl60bgs[targetIndex,c(22:41)]%>%
  print(n=12,width=Inf)
dRetail[x,]
dSpendingAttr
table(phl60bgs$RTSALESTOT)

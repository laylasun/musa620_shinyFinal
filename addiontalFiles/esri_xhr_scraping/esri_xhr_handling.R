library(jsonlite)

# The web map of esri to scrape
# https://laylasun.maps.arcgis.com/home/webmap/viewer.html?webmap=6d22431ac6e14bcf84ee2d38094c508b

# Step 0: Zoom out the map and click on a block group
# trick: when zoom out the map, XHR will contain data for many surrounding block 
##       groups of the clicked block groups. Hence, you can scrape on 5-10 units 
##       at the same time
# Step 1: Inspect -> Network -> XHR -> Response to examine the data
# Step 2: Copy the URL of the right XHR and use jsonlite to parse the data
# Step 3: Find the attributes within features and extract data

# Spending 
# Import data from XHR Url
s<-"https://demographics6.arcgis.com/arcgis/rest/services/USA_Consumer_Expenditures_2016/MapServer//dynamicLayer/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2&geometry=%7B%22xmin%22%3A-8368989.575001328%2C%22ymin%22%3A4858110.7391151665%2C%22xmax%22%3A-8368913.137973041%2C%22ymax%22%3A4858187.176143453%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=ID%2CNAME%2CST_ABBREV%2CX1001_X%2CX1001_A%2CX1001_I%2CX15001_X%2CX15001_A%2CX15001_I%2CTOTHH_CY%2CSTATE_NAME%2COBJECTID&outSR=102100&layer=%7B%22source%22%3A%7B%22type%22%3A%22mapLayer%22%2C%22mapLayerId%22%3A49%7D%7D&token=OwZWWBx-3qqTadHgNdi7xA5iUAKIc0XoPy-G_poLfUF8tRW7W7ZgsrtThys_Z7I0mj3ve82pDYrj02D0p8li1J7jOQSef5Ub3G6_9Wgz4ZxWCfzAHxPgtvxIVs4rsFZ9sDOkvxHufZplRBkjaysDmaU9tMOGPxeXeJ0FKSkPsDutNx-BjWpc6uYsJemy109a-8Xk4At2BgMRasVlwQs3Tc6h--bDw-tDgdGevE0x2Wm5M_qxG0WLS2Ws-RIjHmpANyevTsi1U9Xbd4xUL-npuQ.."
# Read json data
ddb<-fromJSON(s)
# Find the attributes that contain all the data we need
db<-ddb$features$attributes
dSpendingAttr<-db

# Retail
r<-"https://demographics6.arcgis.com/arcgis/rest/services/USA_Retail_Marketplace_2016/MapServer//dynamicLayer/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2&geometry=%7B%22xmin%22%3A-8369025.404858338%2C%22ymin%22%3A4858122.682400837%2C%22xmax%22%3A-8368948.967830051%2C%22ymax%22%3A4858199.119429124%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=ID%2CNAME%2CST_ABBREV%2CRTSALESTOT%2CRETPOTTOT%2CLSFRETTOT%2CRETBUSTOT%2CRSALES4411%2CRETPOT4411%2CLSF4411%2CRETBUS4411%2CRSALES4451%2CRETPOT4451%2CLSF4451%2CRETBUS4451%2CRSALES448%2CRETPOT448%2CLSF448%2CRETBUS448%2CRSALES722%2CRETPOT722%2CLSF722%2CRETBUS722%2CSTATE_NAME%2COBJECTID&outSR=102100&layer=%7B%22source%22%3A%7B%22type%22%3A%22mapLayer%22%2C%22mapLayerId%22%3A49%7D%7D&token=OwZWWBx-3qqTadHgNdi7xA5iUAKIc0XoPy-G_poLfUF8tRW7W7ZgsrtThys_Z7I0mj3ve82pDYrj02D0p8li1J7jOQSef5Ub3G6_9Wgz4ZxWCfzAHxPgtvxIVs4rsFZ9sDOkvxHufZplRBkjaysDmaU9tMOGPxeXeJ0FKSkPsDutNx-BjWpc6uYsJemy109a-8Xk4At2BgMRasVlwQs3Tc6h--bDw-tDgdGevE0x2Wm5M_qxG0WLS2Ws-RIjHmpANyevTsi1U9Xbd4xUL-npuQ.."
ddr<-fromJSON(r)
dr<-ddr$features$attributes
dRetail<- dr
dRetail

# Grocery
g<-"https://demographics6.arcgis.com/arcgis/rest/services/USA_Retail_Marketplace_2016/MapServer//dynamicLayer/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2&geometry=%7B%22xmin%22%3A-8369113.785172295%2C%22ymin%22%3A4858134.625686506%2C%22xmax%22%3A-8369037.348144008%2C%22ymax%22%3A4858211.062714794%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=ID%2CNAME%2CST_ABBREV%2CRTSALESTOT%2CRETPOTTOT%2CLSFRETTOT%2CRETBUSTOT%2CRSALES445%2CRETPOT445%2CLSF445%2CRETBUS445%2CRSALES4451%2CRETPOT4451%2CLSF4451%2CRETBUS4451%2CRSALES4452%2CRETPOT4452%2CLSF4452%2CRETBUS4452%2CRSALES4453%2CRETPOT4453%2CLSF4453%2CRETBUS4453%2CSTATE_NAME%2COBJECTID&outSR=102100&layer=%7B%22source%22%3A%7B%22type%22%3A%22mapLayer%22%2C%22mapLayerId%22%3A49%7D%7D&token=OwZWWBx-3qqTadHgNdi7xA5iUAKIc0XoPy-G_poLfUF8tRW7W7ZgsrtThys_Z7I0mj3ve82pDYrj02D0p8li1J7jOQSef5Ub3G6_9Wgz4ZxWCfzAHxPgtvxIVs4rsFZ9sDOkvxHufZplRBkjaysDmaU9tMOGPxeXeJ0FKSkPsDutNx-BjWpc6uYsJemy109a-8Xk4At2BgMRasVlwQs3Tc6h--bDw-tDgdGevE0x2Wm5M_qxG0WLS2Ws-RIjHmpANyevTsi1U9Xbd4xUL-npuQ.."
dda<-fromJSON(g)
ddg<-dda$features$attributes
ddg

ddg1<- ddg%>%
  select(-RSALES4451, -RETPOT4451, -LSF4451, -RETBUS4451)
dGroc2<- ddg1

# Check whether the ids are identical
dSpendingAttr$ID
dRetail$ID
dGroc2$ID

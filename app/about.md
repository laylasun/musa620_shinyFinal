# MUSA 620 Final Project

## Interactive Map for K-Means Clustering Results
### Links
- [Published Link](https://laylasun.shinyapps.io/musa620_shinyFinal/)
- [Source Code](https://github.com/laylasun/musa620_shinyFinal)
- For Step-2 K-Means and Step-3 Score map: [here](https://laylasun.github.io/final_musa611/). Caution: loading can be very slow given size of the datasets used.
- [Source Code for the Step-2&3 Map](https://github.com/laylasun/final_musa611)

![quicklook](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img001.png)

### Introduction and context
This application is the final project for **MUSA 620** and is aimed to create an interactive map to visualize
the results of step-1 K-means cluster analysis at census block group level for the **Capstone Project**. Step-1 K-means is conducted using a database with **all the block groups from both Philadelphia and Seattle** to detect whether any of Philly's block groups would be assigned to the cluster, which the block group with Amazon Go is also assigned to.

Briefly, the primary goal of the capstone project is to identify some potential sites to host Amazon Go in
Philadelphia when Amazon decides to enter Philly's grocery retail market. Currently, there is only one
**prototype** Amazon Go open to Amazon employees in Beta in Seattle, WA.

Assuming that the current location of the testing Amazon Go is optimal, **cluster analysis (K-Means) at different scales and a feature overlay (with Poisson analysis)** are performed to identify the similar regions,
as well as the most possible sites. This map app shows the block groups of Philadelphia that are
assigned to the same group (**denoted as _Target_**) as the block group where Amazon Go is located in Seattle.

For detailed explanation of the project, please read this [write-up.](https://github.com/laylasun/musa620_shinyFinal/blob/master/addiontalFiles/musa800_writeup1.pdf)

### Functionalities of the map

1. Draggable control panel

2. A little guide of using the inputs:

  1. **# of clusters**: K-means is performed with a pre-determined partitioning number. This selection shows the four optimal numbers of clusters that are used in the analysis.

  2. **Select a viz option**: indicates how many groups given the chosen # of clusters will be displayed on the map. *All groups* will display the whole map with all groups. *Select groups manually* will let user to choose which groups to show on the map.

  ![show1](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img002.png)

  The image below displays how the map layer, legend as well as the chart change to the corresponding selected group ids when using **Select groups manually** with **_For visble only_ unselected**.

  ![show2](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img003.png)

  The image below shows all the plot options based on a selected set of variables (12 out of 26) from the original dataset used for the block-group level cluster analysis.

  ![show3](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img004.png)

  3. Bar plots in the **Population & Housing** section showcase the *mean values of a variable for all the block groups in each group.* These charts try to illustrate the difference among the comparing groups in terms of a single variable.   

  4. Stacked bar plots in the **Commuting to Work** section demonstrate:
    * __Means for Commuting__: for all the block-groups in each cluster/group (x-axis), the average percent of working population that use public transit; cars; or other means, such as motorcycle, bicycle or their feet...
    * __Commute Time to Work__: for all the block-groups in each cluster/group (x-axis), the average percent of working population with commuting time less than 15 mins, between 15 and 40 mins, and more than 40 mins.

  5. __For visible only__: when this box is checked, the plots in **Population & Housing** will change! Instead of showing the summarised the results of block groups per cluster, the plot will gather information from all the *visible* block groups (i.e., **_the block groups, whose the centroids are within the boundary of the map on the screen_**) and display the relationship of the selected pair of features.

  ![show4](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img005.png)

  The image below demonstrates how the scatter plot changes when the map is zoomed in - less data points will be displayed in the graph.

  ![show5](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img006.png)

  The image below illustrates all the available options for scatter plots to explore.

  ![show6](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img007.png)

  6. __Hover and click on the map__: for detailed information on each block group, using the mouse to hover and click any part on the colored layer will trigger a popup for the particular block group at the click point.

  ![show7](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img008.png)

  The image below emphasizes the **Group Id** on a popup of a block group in a **_Target_**(that is this particular block group of Philly is in the same cluster - Group #4 - as the block group containing Amazon Go in Seattle, when partitioning all the block groups of both Seattle and Philly into __11 clusters__ (*denoted as CL11*)).

  ![show8](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img009.png)

  The image below shows the popup of a block group that is not in the *Target* cluster.

  ![show9](https://raw.githubusercontent.com/laylasun/musa620_shinyFinal/master/imagesForReadme/img010.png)

### Skills used to create the map
1. Joining census data downloaded from [nhgis.org](https://www.nhgis.org/)
2. Perform K-means clustering in R with package `NbClust`. ([sample code](https://github.com/laylasun/musa620_shinyFinal/tree/master/addiontalFiles/k_means) for step 1 and 2)
3. Create the `.geojson` file using QGIS.
4. Play painfully with the SpatialPolygonsDataFrame of the lovely `.geojson` file using R packages `dplyr`, `readr` and `rgdal`
5. Heavily rely on `conditionalPanel()` to construct the ui and more heavily rely on the most basic logic expression `if()` to `reactive()` and `isolate()` the needed dataset given limited programming experience
6. Create graphs using the old-school `ggplots` with `reshape2` rather than the fancy and interactive Plotly given no $.
7. Find the [shiny example](http://shiny.rstudio.com/gallery/superzip-example.html) and its [source code](https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example) that can inspire you and make your life easier in a complicated way before graduation.

### Additional techniques used to complete the Capstone project
1. Web scraping ([files](https://github.com/laylasun/musa620_shinyFinal/tree/master/addiontalFiles/tallBuilding_scraping)) on _source codes_ using `javascript` to get coordinates of tall buildings in Seattle and Philly for step-2 cluster analysis and featurea overlay.
2. Web scraping ([files](https://github.com/laylasun/musa620_shinyFinal/tree/master/addiontalFiles/esri_xhr_scraping)) on map based on **Response** in XHR using R package `jsonlite` to get related data from esri's living atlas layer.


To run this app locally make sure you've installed the R packages.

```
# install.packages("shiny")
# install.packages("leaflet")
# install.packages("dplyr")
# install.packages("reshape2")
# install.packages("lattice")
# install.packages("tidyr")
# install.packages("scales")
# install.packages("ggplot2")
# install.packages("lubridate")
# install.packages('rgdal')
# install.packages('readr')
```

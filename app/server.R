# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# install.packages("shiny")
# install.packages("lattice")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("scales")
# install.packages("leaflet")
# install.packages("ggplot2")
# install.packages("lubridate")
# install.packages("reshape2")

library(shiny)
library(leaflet)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(scales)
library(lattice)
library(tidyr)
library(dplyr)
library(reshape2)

function(input, output, session){
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      setView(lng = -75.078661, lat = 39.999684, zoom = 12)
  })
  
  # A reactive expression that returns the set of blockgroups that are
  # selected by the user's indicated clustering number and group #s
  # This step is to isolate the data for the map and legends
  # The resulting dataset remains a spatial data frame
  clusterSelection<-reactive({
    clusterNum<-input$cluster # CL2,3,4,11
    vizmethod<-input$vizmethod #all, manual
    input$groups2
    input$groups3
    input$groups4
    input$groups11
    
     if(vizmethod=="all"){
      isolate({bgs<-blockgroups})
    }else{
      if(clusterNum=="CL2"){
        isolate({bgs<-subset(blockgroups, CL2 %in% input$groups2)})
      }else if(clusterNum=="CL3"){
        isolate({bgs<-subset(blockgroups, CL3 %in% input$groups3)})
      }else if(clusterNum=="CL4"){
        isolate({bgs<-subset(blockgroups, CL4 %in% input$groups4)})
      }else{
        isolate({bgs<-subset(blockgroups, CL11 %in% input$groups11)})
      }
    }
  })
  

  # Map the blockgroups from the above-selected dataset based on
  # user's choice
  observe({
    clusterNum<-input$cluster # CL2,3,4,11
    
    clustering<-as.factor(clusterSelection()[[clusterNum]])

    pal<-colorFactor("Spectral",clustering)
    
    leafletProxy("map", data = clusterSelection()) %>%
      clearShapes() %>%
      addPolygons(layerId=~GISJOINID, stroke=FALSE, smoothFactor = 0.3,
                  fillOpacity=0.5, fillColor=pal(clustering),
                  highlight = highlightOptions(
                    fillColor = "yellow",
                    opacity = 1, weight = 2,
                    fillOpacity = 1,
                    #bringToFront = FALSE
                    bringToFront = TRUE, sendToBack = TRUE)) %>%
      addLegend("bottomleft", pal=pal, values=clustering, title=paste("Group Ids"),
                layerId="clusterColorLegend")
  })
  
  # ***This step is to filter the data that are within the boundary of the map
  ## to prepare the dataset for scatter plots
  
  bgsInBounds <- reactive({
    selectedClusters <-clusterSelection()@data
    if (is.null(input$map_bounds))
      return(selectedClusters[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    isolate({
      vis_bgs<-subset(selectedClusters,
                      centr_lat >= latRng[1] &  centr_lat  <= latRng[2] &
                        centr_lng >= lngRng[1] & centr_lng <= lngRng[2])
    })
  })

  # ***This step is to isolate the data for two sections of plots  
  ## A reactive expression that returns, groups and summarises the set of 
  ## blockgroups that are based on user's indicated clustering number and group #s
  ## The resulting dataset is NOT a spatial data frame but a regular df
  clusterDataSelection<-reactive({
    clusterNum<-input$cluster # CL2,3,4,11
    vizmethod<-input$vizmethod #all, manual
    input$groups2
    input$groups3
    input$groups4
    input$groups11
    
    if(clusterNum=="CL2"){
      if(vizmethod=="all"){
        bgsdt<-blockgroups@data%>%group_by(CL2)
      }else{
        bgsdt<-subset(blockgroups@data, CL2 %in% input$groups2)%>%group_by(CL2)
      }
    }else if(clusterNum=="CL3"){
      if(vizmethod=="all"){
        bgsdt<-blockgroups@data%>%group_by(CL3)
      }else{
        bgsdt<-subset(blockgroups@data, CL3 %in% input$groups3)%>%group_by(CL3)
      }
    }else if(clusterNum=="CL4"){
      if(vizmethod=="all"){
        bgsdt<-blockgroups@data%>%group_by(CL4)
      }else{
        bgsdt<-subset(blockgroups@data, CL4 %in% input$groups4)%>%group_by(CL4)
      }
    }else{
      if(vizmethod=="all"){
        bgsdt<-blockgroups@data%>%group_by(CL11)
      }else{
        bgsdt<-subset(blockgroups@data, CL11 %in% input$groups11)%>%group_by(CL11)
      }
    }
    
      bgsdt<-bgsdt%>%summarise(avgPopd=mean(POP15DEN,na.rm=TRUE),avgPopc=mean(PCTPOPCHA,na.rm=TRUE),
                               avgInc=mean(PCINC15,na.rm=TRUE),avgBach=mean(PCTBACH15,na.rm=TRUE),
                               avgRent=mean(MDCRENT15,na.rm=TRUE),avgVac=mean(PCTVA15,na.rm=TRUE),
                               avgCt15=mean(PCTCTLT15,na.rm=TRUE),avgCt1540=mean(PCTCT1540,na.rm=TRUE),avgCt40=mean(PCTCTMT40,na.rm=TRUE),
                               avgPt=mean(PCTPT,na.rm=TRUE),avgMbw=mean(PCTMBW,na.rm=TRUE),avgCar=mean(PCTCAR,na.rm=TRUE))
      colnames(bgsdt)[1]<-"Groups"
      
      isolate({
      bgsdt
    })
  })
  

  # Create the bar plot based on user's selection from the dropdown menu
  # at Population and Housing section
  output$pop_pl<- renderPlot({
    clusterNum<-input$cluster
    
    df<-clusterDataSelection()
    df1<-bgsInBounds()
    
    if(input$visible){
      colorsel<-function(df1){if(clusterNum=="CL2"){df1$CL2}else if(clusterNum=="CL3"){df1$CL3}else if(clusterNum=="CL4"){df1$CL4}else{df1$CL11}}
      
      if(input$population2=="pop1"){
        # Exclude the big outlier... for better viz
        df1<-df1[which(df1$POP15DEN<150000),]
        
        ggplot(data=df1, aes(x=POP15DEN, y=PCTPOPCHA/100))+geom_point(shape=19,size=3, alpha=0.45,aes(colour=as.factor(colorsel(df1))))+
          scale_y_continuous(labels = percent)+
          labs(x="Population/SQMI", y="Pop. % Change (2010-15)")+
          theme(legend.title=element_blank())+geom_smooth(method=lm,se=FALSE)   # Add linear regression line
                                                         
        
      }else if(input$population2=="pop2"){
        
        ggplot(data=df1, aes(x=PCTBACH15/100, y=PCINC15))+geom_point(shape=19,size=3, alpha=0.45,aes(colour=as.factor(colorsel(df1))))+
          scale_x_continuous(labels = percent)+
          labs(x="% of adults with BA", y="Per Capita Income")+
          theme(legend.title=element_blank())+geom_smooth(method=lm,se=FALSE)
        
      }else{
        ggplot(data=df1, aes(x=PCTVA15/100, y=MDCRENT15))+geom_point(shape=19,size=3, alpha=0.45,aes(colour=as.factor(colorsel(df1))))+
          scale_x_continuous(labels = percent)+
          labs(x="Vacancy Rate", y="Median Contract Rent")+
          theme(legend.title=element_blank())+geom_smooth(method=lm,se=FALSE)
      }
    }else{
      if (input$population=="avgPopd"){
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round(avgPopd,digits=2),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")
      }else if(input$population=="avgPopc"){
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round((avgPopc/100),digits=4),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")+ scale_y_continuous(labels = percent)
      }else if(input$population=="avgInc"){
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round(avgInc,digits=2),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")
      }else if(input$population=="avgBach"){
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round((avgBach/100),digits=4),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")+ scale_y_continuous(labels = percent)
      }else if(input$population=="avgRent"){
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round(avgRent,digits=2),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")
      }else { #if(input$population=="avgVac")
        ggplot(data=df)+geom_bar(aes(x = as.factor(Groups),y=round((avgVac/100),digits=4),fill=as.factor(Groups)),stat = "identity",position="dodge")+
          scale_fill_brewer(palette="Spectral")+labs(x="Group Id(s)", y="")+
          theme_minimal()+ theme(legend.position="none")+ scale_y_continuous(labels = percent)
      }
    }
  })
  
  # Create the stacked bar plot based on user's selection from the dropdown menu
  # at Commuting to Work section
  output$commute_pl<- renderPlot({
 
    if (input$commute=="means"){
      df<-clusterDataSelection()
      df1<-melt(df[,c("Groups","avgPt","avgMbw","avgCar")], id=c("Groups"))
      
      levels(df1$variable)[levels(df1$variable)=="avgPt"] <- "Public Transit"
      levels(df1$variable)[levels(df1$variable)=="avgMbw"] <- "Others"
      levels(df1$variable)[levels(df1$variable)=="avgCar"] <- "Car"
      names(df1)[names(df1)=="variable"]  <- "Percent_of_TransMeans"
      
      ggplot(data = df1, aes(y=(value/100),x=as.factor(Groups),fill=Percent_of_TransMeans)) + 
        geom_bar(stat = "identity")+
        scale_fill_brewer(palette="BuPu")+labs(x="Group Id(s)", y="")+theme_minimal()+ 
        theme(legend.position="bottom")+ scale_y_continuous(labels = percent)
    }else{
      df<-clusterDataSelection()
      df1<-melt(df[,c("Groups","avgCt15","avgCt1540","avgCt40")], id=c("Groups"))
      
      levels(df1$variable)[levels(df1$variable)=="avgCt15"] <- "<15mins"
      levels(df1$variable)[levels(df1$variable)=="avgCt1540"] <- "15-40mins"
      levels(df1$variable)[levels(df1$variable)=="avgCt40"] <- ">40mins"
      names(df1)[names(df1)=="variable"]  <- "Avg_Commute_Time"

      ggplot(data = df1, aes(y=(value/100),x=as.factor(Groups),fill=Avg_Commute_Time)) + 
        geom_bar(stat = "identity")+
        scale_fill_brewer(palette="BuPu")+labs(x="Group Id(s)", y="")+theme_minimal()+ 
        theme(legend.position="bottom")+ scale_y_continuous(labels = percent)
    }
  })
  
  # Create the content of the popup for the blockgroup at the clicked spot on the map
  showPopup <- function(GISJOINID, lat, lng) {
    clusterNum<-input$cluster
    maplayer<-clusterSelection()
    
    selectedId<- maplayer[maplayer$GISJOINID == GISJOINID,]@data
    content <- as.character(tagList(
      #tags$h5("Id:", as.character(selectedId$GISJOINID)),
      tags$h4("Group Id: ", 
                if(clusterNum=="CL2"){
                  if(selectedId$CL2=="1"){"1 (Target)"}else{as.integer(selectedId$CL2)}  
                }else if(clusterNum=="CL3"){
                  if(selectedId$CL3=="1"){"1 (Target)"}else{as.integer(selectedId$CL3)}  
                }else if(clusterNum=="CL4"){
                  if(selectedId$CL4=="4"){"4 (Target)"}else{as.integer(selectedId$CL4)}  
                }else{
                  if(selectedId$CL11=="4"){"4 (Target)"}else{as.integer(selectedId$CL11)}  
                }),
      tags$strong(HTML(sprintf("Clustering number: %s (%s)",
                               if(clusterNum=="CL2"){
                                 as.factor(2)
                               }else if(clusterNum=="CL3"){
                                 as.factor(3)
                               }else if(clusterNum=="CL4"){
                                 as.factor(4)
                               }else{
                                 as.factor(11)
                               },
                               if(clusterNum=="CL2"){
                                 as.character("CL2")
                               }else if(clusterNum=="CL3"){
                                 as.character("CL3")
                               }else if(clusterNum=="CL4"){
                                 as.character("CL4")
                               }else{
                                 as.character("CL11")
                               }
                               ))), tags$br(),
      sprintf("Population/SQMI: %s", as.integer(selectedId$POP15DEN)), tags$br(),
      sprintf("Population Percent Change: %s%%", as.integer(selectedId$PCTPOPCHA)), tags$br(),
      sprintf("Per Capita income: %s", dollar(selectedId$PCINC15 * 1000)), tags$br(),
      sprintf("Percent of adults with BA: %s%%", as.integer(selectedId$PCTBACH15)), tags$br(),
      sprintf("Median Contract Rent: %s", dollar(selectedId$MDCRENT15)), tags$br(),
      sprintf("Vacancy rate: %s%%", as.integer(selectedId$PCTVA15)), tags$br()
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = GISJOINID) #same layerId as the one defined before!!!!!
  }
  
  # When a blockgroup is clicked (anywhere on the colorred blockgroups), a popup with blockgroup info will be shown
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showPopup(event$id, event$lat, event$lng)
    })
  })
}
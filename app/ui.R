library(shiny)
library(leaflet)

navbarPage("Potential Block Groups for Amazon-Go", id="nav",
  tabPanel("Map",icon = icon("map"),
    div(class="outer",
        
        tags$head(
          # Include our custom CSS
          includeCSS("styles.css")
        ),
        
        leafletOutput("map", width="100%", height="100%"),
        
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = TRUE, top = "8%", left = "auto", right = "1%", bottom = "auto",
                      width = 370, height = "auto",
                      
                      h3("Philly's Block Groups Explorer"),
                      fluidRow(
                        column(4, selectInput("cluster","# of clusters",c("2"="CL2","3"="CL3","4"="CL4","11"="CL11"), selected ="CL3")),
                        column(8, selectInput("vizmethod","Select a visualiztion option",c("All groups"="all","Select groups manually"="manual"),selected ="all"))
                      ),
                      fluidRow(
                        column(12, conditionalPanel("input.cluster=='CL2'&& input.vizmethod=='manual'", 
                                                    checkboxGroupInput("groups2","Select the group id(s) to visualize:",c("1 (Target)"="1","2"="2"),inline=TRUE, selected = "1"))),
                        column(12, conditionalPanel("input.cluster=='CL3'&& input.vizmethod=='manual'", 
                                                    checkboxGroupInput("groups3","Select the group id(s) to visualize:",c("1 (Target)"="1","2"="2","3"="3"),inline=TRUE,selected = "1"))),
                        column(12, conditionalPanel("input.cluster=='CL4'&& input.vizmethod=='manual'", 
                                                    checkboxGroupInput("groups4","Select the group id(s) to visualize:",c("1"="1","2"="2","3"="3","4 (Target)"="4"),inline=TRUE,selected = "4"))),
                        column(12, conditionalPanel("input.cluster=='CL11'&& input.vizmethod=='manual'", 
                                                    checkboxGroupInput("groups11","Select the group id(s) to visualize:",c("1"="1","2"="2","3"="3","4 (Target)"="4","5"="5","6"="6","7"="7",
                                                                                                                           "8"="8","9"="9","10"="10","11"="11"),inline = TRUE, selected = "4")))
                      ),
                      fluidRow(
                        column(12,
                               fluidRow(column(7,h4("Population & Housing")),column(5,checkboxInput("visible","For visible only",value=FALSE))),
                               conditionalPanel("!input.visible",selectInput("population","Select a feature to plot:",c("Avg. population/mi²"="avgPopd",
                                                                                                                              "Avg. % change (2010-2015)"="avgPopc",
                                                                                                                              "Avg. Per Capita income"="avgInc",
                                                                                                                              "Avg. % of bachelor degree"="avgBach",
                                                                                                                              "Avg. median contract rent"="avgRent",
                                                                                                                              "Avg. vacancy rate"="avgVac"),
                                                                             selected="avgPopd")),
                               conditionalPanel("input.visible", selectInput("population2","Select a pair of features to plot:", c("Population: 5-Yr Change vs. Density"="pop1",
                                                                                                                                   "Per Capita Income vs. Education"="pop2",
                                                                                                                                   "Median Contract Rent vs. Vacancy Rate"="pop3"),
                                                                             selected="pop1")),
                               plotOutput("pop_pl", height = 230)),
                        column(12,h4("Commuting to Work"), selectInput("commute","Select a feature to plot:",c("Means for Commuting"="means","Commute Time to Work"="time"),selected="means"),
                               plotOutput("commute_pl", height = 220)
                      )

        )
    )
  )
),
tabPanel("About",icon = icon("github-alt"),
         div(class="about",
             tags$head(
               # Include our custom CSS
               includeCSS("styles.css")
             ),
         fluidRow(
           column(width = 10,
                    includeMarkdown("about.md"))
             )
          )
)
)
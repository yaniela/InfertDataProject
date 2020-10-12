# Load libraries ---------------------------------------------------------------
library(shiny)
library(shinythemes)

library(knitr)

#library(githubinstall)
#githubinstall("rCharts")
library(config)
library(rCharts)
library(leaflet)
library(plotly)
#library(DT)

# Plot libraries for outputs
#require(rCharts)
#require(leaflet)n

#require(DT)
#require(plotly)

# Adjustments
h3.align <- 'center'

# Shiny UI ---------------------------------------------------------------------
shinyUI(navbarPage(
    title = "Infertility Data analysis",
    
    # Pick a bootstrap theme from https://rstudio.github.io/shinythemes/
    theme = shinytheme("spacelab"),
    
    # Analytics tab panel --------------------------------------------------        
    tabPanel(
        title = "Analytics",
        sidebarPanel(width=3,
            conditionalPanel(condition="input.tabselected == 1||input.tabselected == 3",
                             h3("Reactive Inputs", align = h3.align),
                             h6("Select the features", align="center"),
                             uiOutput("Age"),
                             uiOutput("Education"),
                             uiOutput("Parity"),
                             uiOutput("Spontaneous"),
                             uiOutput("Induced"),
                             p(actionButton(inputId = "reset", 
                                        label = "Reset Fields", 
                                         icon = icon("refresh")
                             ), align = "center")
            ),
            conditionalPanel(condition="input.tabselected == 2",
                             h3("Predictors", align = h3.align),
                             h6("Select the predictor for the outcome case", align="center"),
                             radioButtons("predictor", "Predictors",
                                          choices = c("Age"="age",  "Number of pregnancy"="parity"),
                                          selected = "age"),
                             radioButtons("group", "Color Group",
                                          choices = c("Spontaneous abort"="spontaneous", "Induced abort"="induced"),
                                          selected = "spontaneous"),
                            
            )
        ) ,
      
       
        mainPanel(
          
          tags$style(type="text/css",
                     ".shiny-output-error { visibility: hidden; }",
                     ".shiny-output-error:before { visibility: hidden; }"
          ),
          
          
            tabsetPanel(type = "tabs", id = "tabselected",
                
                # Exploratory Analysis Tab -----------------------------------------
                tabPanel(
                    p(icon("area-chart"), "Exploratory Analysis"),
                    value = 1,
                    fluidRow(
                        column(6, h4("Age distribution", align="center"), 
                               p(plotlyOutput("AgeDistribution",  height = "200px"), align="center")),
                        
                         column(6, h4("Cases vs spontaneous abort", align="center"), 
                           p(plotlyOutput("paritySpontaneous",  height = "200px"), align="center")),
                        
                        column(7, h4("Cases vs induced abort", align="center"), 
                               p(plotlyOutput("parityInduced",  height = "200px"), align="center")),
                        
                        column(5, h4("Previous pregnancy vs Education", align="center"), 
                               p(plotlyOutput("parityEducation",  height = "200px"), align="center"))
                    
                        )
                        
                       
                    ),  # End Exploratory Analysis Tab
               
                 # Prediction Tab -----------------------------------------
                tabPanel(
                    p(icon("bar-chart-o"), "Prediction"), value = 2,
               
                    fluidRow(
                        column(6, p(plotlyOutput("predPlot", width = 400, height = "400px"), align="center")),
                        
                        column(5, br(), verbatimTextOutput("sum"))
                        ) 
                           
                        
                ), # End Prediction Tab
                
                # Data Tab ---------------------------------------------
                tabPanel(
                    p(icon("table"), "Dataset"),value = 3,
                    
                    fluidRow(
                        column(6, h3("Search, Filter & Download Data", align='left')),
                        column(6, downloadButton('downloadData', 'Download', class="pull-right"))
                        
                    ),
                    hr(),
                    fluidRow(
                        dataTableOutput(outputId="table")
                        
                    )) # End Data Tab
            
        )
        )
    ), # End Analytics Tab Panel
    
    # About Tab Panel ------------------------------------------------------           
    tabPanel("Instructions Doc",
             mainPanel(column(8, offset = 2), uiOutput("report"))
    ) # End About Tab Panel
    
) # End navbarPage
) # End shinyUI







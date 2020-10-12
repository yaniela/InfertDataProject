# Load libraries ---------------------------------------------------------------
library(shiny)

library(knitr)

# Data read & manipulation libraries
require(dplyr)
require(lubridate)
require(scales)

library(tidyverse)
library(hrbrthemes)

# Visualization libraries

require(DT)
require(leaflet)
require(plotly)

require(ggiraph)
require(ggiraphExtra)
require(plyr)
require(ggplot2)



data(infert)
df<-as.data.frame(infert)





# Setup inputs
ageMax <- max(df$age)
ageMin <- min(df$age)
education <- sort(unique(df$education))
parity<-sort(unique(df$parity))
spontaneous<-sort(unique(df$spontaneous))
induced<-sort(unique(df$induced))

# Server logic -----------------------------------------------------------------
shinyServer(function(input, output, session) {
  
  # Setup reactive inputs ------------------------------------------------
  
  output$Age <- renderUI({
    sliderInput(inputId = "age.in", 
                label   = "Age Filter", 
                min     = ageMin, 
                max     = ageMax, 
                step    = 1,
                value   = c(ageMin, ageMax),
                ticks   = T,
                sep     = "")
  })
  
  
  output$Education<- renderUI({
    checkboxGroupInput('education', label = "Years of education",
                       choices = education, selected = education)
  })
  
   output$Parity <- renderUI({
     checkboxGroupInput('parity', label = "Number of previous pregnancy",
                        choices = parity, selected = parity)
   })
   
  output$Spontaneous <- renderUI({
    checkboxGroupInput('spontaneous', label = "Number of spontaneous abort",
                       choices = spontaneous, selected = spontaneous)
   })
   
   output$Induced <- renderUI({
     checkboxGroupInput('induced', label = "Number of induced abort",
                       choices = induced, selected = induced)
   })
   
  
  
  
  observe({
    if(input$reset != 0) {
      updateCheckboxGroupInput(session, "education", choices = education, selected=education)
      updateCheckboxGroupInput(session, "parity", choices = parity, selected=parity)
      updateCheckboxGroupInput(session, "spontaneous", choices = spontaneous, selected=spontaneous)
      updateCheckboxGroupInput(session, "induced", choices = induced, selected=induced)
      updateSliderInput(session, "age.in", val = c(ageMin, ageMax))
    }
    
  })
  
  # Data Reactivity ------------------------------------------------------
  
  df.filtered <- reactive({
    # Error handling 
    if (is.null(input$age.in) | 
         is.null(input$education) |    
        is.null(input$parity)    |
        is.null(input$spontaneous) |
       is.null(input$induced)
    ) {
      return(NULL)
    } 
    
    df<-df %>%
      filter(age >=   input$age.in[1],
             age <=   input$age.in[2], 
             education %in% input$education, 
             spontaneous %in% input$spontaneous,
            induced %in% input$induced,
            parity %in% input$parity
           )
    
    
  })
  
  AgeDistributionHist <- reactive({
    df.filtered() 
     
  })
  
  # Plots on Analysis Tab -----------------------------------
 
  output$AgeDistribution<- renderPlotly({
    
    p <- ggplot( df.filtered(), aes(age)) +
      geom_histogram( binwidth=5, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
           theme(
        plot.title = element_text(size=15)
      )
        p
  
  })
  
  output$paritySpontaneous<- renderPlotly({
    
    
    p<- ggplot( df.filtered(), aes(x=as.factor(case), fill=as.factor(spontaneous)) )+  labs(fill = "Spontaneous",  x="Case Status")+
      geom_bar() + theme_minimal() + scale_x_discrete(labels=c("1" = "Case", "0" = "Control"))
   
    
    p
    
  })
  
  output$parityInduced<- renderPlotly({
    
    p<-ggplot(df.filtered(), aes(x=as.factor(case), fill=as.factor(induced))) + labs(fill = "Induced", x="Case Status")+
      geom_bar() +theme_minimal() + scale_x_discrete(labels=c("1" = "Case", "0" = "Control"))
    p
    
  })
  
  
  output$parityEducation<- renderPlotly({
    
    
    
    p<- ggplot(df.filtered(), aes(x=education, y=parity)) +
      geom_boxplot(color="red", fill="orange", alpha=0.2)
    p
    
  })
  
 
 
  
 
  
  # Plot on Prediction Tab ------------------------------------------------
  
 
  model<-reactive({
    
    case <- df$case
    predictor <- df[,input$predictor]
    fit <- lm(case ~   predictor)
    return(fit)
  })
  
  output$sum<-renderPrint({summary(model())})
  
  output$predPlot<- renderPlotly({
   
   
    dat <- data.frame(x=df[,input$predictor],y= df$case)
    p <- ggplot(dat, aes(x=x, y=y, color=as.factor(df[,input$group])) )+
      geom_point() +  theme_bw() + theme( legend.title = element_blank()) +
      stat_smooth(method = "lm") + labs(x =input$predictor , y="probability of infertility", colour =input$group )
 
     
    ggplotly(p)%>%
      layout(legend = list(orientation = "h", x = 0.4, y = -0.2, title=list(text=paste("<b>",input$group,"</b>"))))

  })

 
 
  
  
  # Data and button on Data Tab-------------------------------------------
  
  output$table <- DT::renderDataTable({df.filtered()},
                                      rownames = F,
                                      options = list(bFilter = FALSE, 
                                                     iDisplayLength = 10)
  )
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0('data-', Sys.Date(), '.csv')
    },
    content = function(file) {
      write.csv(df.filtered(), file, row.names=FALSE)
    }
  )
  
 
  output$report <- renderUI({
    includeMarkdown("documentation.Rmd")
  })
  
})

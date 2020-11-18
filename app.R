library(shiny)
library(shiny.semantic)
library(leaflet)
library(readr)
library(dplyr)
source('dropdown.R')

ui <- semanticPage(
    
    segment(
        class = 'basic',
        a(class='ui blue ribbon label', 'Maximum distance of 2 consecutive AIS signals'),
        leafletOutput('map')),
    
    segment(cards(
        class = 'two',
        dropdownUI('type','Vessel Type:'),
        dropdownUI('name','Vessel Name:'))))

server <- function(input, output, session) {
    
    data <- read_csv('data.csv')
    typeChoices <- reactive({data %>% distinct(ship_type) %>% pull()})
    nameChoices <- reactive({data %>% filter(ship_type==type()) %>% distinct(SHIPNAME) %>% pull()})
    type <- dropdownServer('type',typeChoices)
    name <- dropdownServer('name',nameChoices)
    vessel <- reactive({data %>% filter(ship_type==type()&SHIPNAME==name())})
    output$map <- renderLeaflet({
        m = leaflet() %>% 
            addTiles() %>% 
            addAwesomeMarkers(vessel()$LON,vessel()$LAT,label='start',
                              icon=awesomeIcons('ship','fa','green','black')) %>% 
            addAwesomeMarkers(vessel()$LON_NEXT,vessel()$LAT_NEXT,label='end',
                              icon=awesomeIcons('ship','fa','red','black')) %>% 
            addPolylines(lng=c(vessel()$LON,vessel()$LON_NEXT),
                         lat=c(vessel()$LAT,vessel()$LAT_NEXT)) %>% 
            addLabelOnlyMarkers(lng=(vessel()$LON + vessel()$LON_NEXT)/2,
                       lat=(vessel()$LAT+ vessel()$LAT_NEXT)/2,
                       label=paste0('distance = ',sprintf("%.2f",vessel()$distance),' meters'),
                       labelOptions=labelOptions(noHide=T))})}

shinyApp(ui = ui, server = server)
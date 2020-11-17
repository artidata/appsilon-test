library(shiny)
library(shiny.semantic)
library(leaflet)
library(readr)
library(dplyr)

ui <- semanticPage(
    
    segment(
        class = 'basic',
        a(class='ui blue ribbon label', 'Appsilon Test'),
        leafletOutput('map')),
    
    segment(cards(
        class = 'two',
        
        card(class = 'blue',
             div(class = 'content',
                 div(class = 'header', 'Vessel Type:'),
                 dropdown_input('type', NULL))),
        
        card(class = 'blue',
             div(class = 'content',
                 div(class = 'header', 'Vessel Name:'),
                 dropdown_input('name', NULL))))))

server <- function(input, output, session) {
    
    data <- read_csv('data.csv')
    
    update_dropdown_input(session,'type',data %>% distinct(ship_type) %>% pull())
    
    observeEvent(input$type,update_dropdown_input(session,'name',data %>% filter(ship_type==input$type) %>% distinct(SHIPNAME) %>% pull()))
    
    coord <- reactive({data %>% filter(ship_type==input$type&SHIPNAME==input$name)})
    
    output$map <- renderLeaflet({
        m = leaflet() %>% 
            addTiles() %>% 
            addAwesomeMarkers(coord()$LON,coord()$LAT,label='start',
                              icon=awesomeIcons('ship','fa','green','black')) %>% 
            addAwesomeMarkers(coord()$LON_NEXT,coord()$LAT_NEXT,label='end',
                              icon=awesomeIcons('ship','fa','red','black')) %>% 
            addPolylines(lng=c(coord()$LON,coord()$LON_NEXT),
                         lat=c(coord()$LAT,coord()$LAT_NEXT)) %>% 
            addLabelOnlyMarkers(lng=(coord()$LON + coord()$LON_NEXT)/2,
                       lat=(coord()$LAT+ coord()$LAT_NEXT)/2,
                       label=paste0('distance = ',sprintf("%.2f",coord()$distance),' meters'),
                       labelOptions=labelOptions(noHide=T))})}

shinyApp(ui = ui, server = server)
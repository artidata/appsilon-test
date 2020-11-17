library(shiny)
library(shiny.semantic)
library(leaflet)
library(readr)
library(dplyr)

ui = semanticPage(
    
    segment(
        class = 'basic',
        a(class='ui blue ribbon label', 'Leaflet demo'),
        leafletOutput('map')),
    
    segment(cards(
        class = 'two',
        
        card(class = 'red',
             div(class = 'content',
                 div(class = 'header', 'Main title card 1'),
                 div(class = 'meta', 'Sub title card 1'),
                 dropdown_input('type', NULL))),
        
        card(class = 'blue',
             div(class = 'content',
                 div(class = 'header', 'Main title card 2'),
                 div(class = 'meta', 'Sub title card 1'),
                 dropdown_input('name', NULL))))))

server = function(input, output, session) {
    data = read_csv('data.csv')
    update_dropdown_input(session,'type',data %>% distinct(ship_type) %>% pull())
    observeEvent(input$type,update_dropdown_input(session,'name',data %>% filter(ship_type==input$type) %>% distinct(SHIPNAME) %>% pull()))
    # coords = reactive({data %>% filter(ship_type==input$type&SHIPNAME==input$SHIPNAME)})
    # observeEvent(coords,print(coords()))
    output$map = renderLeaflet({
        m = leaflet() %>% addTiles()
        m = m %>% setView(21.00, 52.21, zoom = 12)
        m
    })
}

shinyApp(ui = ui, server = server)

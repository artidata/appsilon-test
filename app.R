library(shiny)
library(shiny.semantic)
library(leaflet)

ui <- semanticPage(
    segment(
        class = "basic",
        a(class="ui blue ribbon label", "Leaflet demo"),
        leafletOutput("map")
    ),
    segment(
        cards(
            class = "two",
            card(class = "red",
                 div(class = "content",
                     div(class = "header", "Main title card 1"),
                     div(class = "meta", "Sub title card 1"),
                     dropdown_input("type", LETTERS, value = "A")
                 )
            ),
            card(class = "blue",
                 div(class = "content",
                     div(class = "header", "Main title card 2"),
                     div(class = "meta", "Sub title card 1"),
                     dropdown_input("name", LETTERS, value = "A")
                 )
            )
        )
    )
    
)

server <- function(input, output, session) {
    output$map <- renderLeaflet({
        m <- leaflet() %>% addTiles()
        m <- m %>% setView(21.00, 52.21, zoom = 12)
        m
    })
}

shinyApp(ui = ui, server = server)

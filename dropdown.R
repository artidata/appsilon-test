dropdownUI <- function(id,label){
  card(class = 'blue',
       div(class = 'content',
           div(class = 'header', label),
           dropdown_input(NS(id,'drop'), NULL)))}

dropdownServer <- function(id,choices){
  moduleServer(id,function(input,output,session){
    observeEvent(choices(),update_dropdown_input(session,'drop',choices()))
    return(reactive({input$drop}))})}
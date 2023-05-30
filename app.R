library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("myMap")
)

server <- function(input, output, session) {
  output$myMap <- renderLeaflet({
    leaflet() %>% addTiles()
  })
  
  observeEvent(input$myMap_click, {
    leafletProxy("myMap") %>% setView(lat = input$myMap_click$lat, lng = input$myMap_click$lng, zoom = 8)
  })
}



options(shiny.port = 3838, shiny.host = '0.0.0.0')

shinyApp(ui, server)

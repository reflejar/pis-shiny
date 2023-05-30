library(shiny)
library(leaflet)
library(leaflet.extras2)
library(shinyjs)
library(sfarrow)
library(arrow)

honeycomb_count=st_read_parquet("./data/hexagonos.parquet")
df=read_parquet("./data/puntos.parquet")

palette <- colorBin('Reds', domain = honeycomb_count$n_colli, bins = 5)
# palette(0)
# palette(4)

hover=lapply(honeycomb_count$Tooltip, htmltools::HTML)

style <- "
  .hexbin-hexagon {
  	stroke: #000;
  	stroke-width: .5px;
  }
  
  .hexbin-container:hover .hexbin-hexagon {
  	transition: 200ms;
  	stroke: black;
  	stroke-width: 2px;
  	stroke-opacity: 1;
  }
  
  .hexbin-tooltip {
  	padding: 8px;
  	border-radius: 4px;
  	border: 1px solid black;
  	background-color: white;
  }
"

style_hidden <- "
  .hexbin-hexagon {
    display:none
  }
  
  .hexbin-container:hover .hexbin-hexagon {
    display:none

  }
  
  .hexbin-tooltip {
    display:none

  }
"
# Define UI
ui <- fluidPage(
  tags$head(tags$style(style)),
  uiOutput("style"),
  leafletOutput("map")
)

# Define server
server <- function(input, output, session) {
  prev_zoom <- reactiveVal(NULL)

  # Create a Leaflet map
  output$map <- renderLeaflet({
    leaflet(options = providerTileOptions(minzoom = 1, maxzoom = 10))%>%
      addMapPane("HexPane",zIndex = 420)%>%
      addPolygons(data=honeycomb_count,fillColor = ~palette(n_colli),
                  label = hover,popup = hover,
                  popupOptions = popupOptions(maxHeight ="300",minWidth = "200",
                                              closeOnClick = TRUE),
                  fillOpacity = 0.7,color="black",opacity=1,weight=1,group="Hex",
                  options = pathOptions(pane = "HexPane"),
                  # Highlight neighbourhoods upon mouseover
                  highlight = highlightOptions(
                    weight = 2,
                    fillOpacity = 0.85,
                    color = "black",
                    opacity = 1.0,
                    bringToFront = TRUE,
                    sendToBack = TRUE), )%>%
      addTiles()%>%
      addHexbin(lng = df$Long, lat = df$Lat,opacity=0.7,
                options = hexbinOptions(pointerEvents = "all",duration=0,colorRange =c("#FEE5D9", "#A50F15"),radiusRange = c(20, 20),tooltip = "Total "))
  })
  
  #Hacer zoom cuando el usuario clickea en el mapa
  observeEvent(input$map_click, {
    leafletProxy("map") %>% setView(lat = input$map_click$lat, lng = input$map_click$lng, zoom = 10)
  })
  
  # Hide the marker layer when zoom level is greater than 16
  observeEvent(input$map_zoom,{
    zoom <- input$map_zoom
    if(is.null(prev_zoom())){
      # prev_zoom()
    }else{
      print(zoom)
      print(prev_zoom())
      if (zoom >= 9 & prev_zoom()<=9) {
        print("Remove")
        # addClass(selector = "div.hexbin-tooltip", class = "hidden")
        
        output$style <- renderUI({
          tags$style(style_hidden)
        })
        
        # toggleClass(class = "hexbin-hexagon2", selector = "div.hexbin-hexagon")
        # removeUI(selector = "div.hexbin-tooltip")
        leafletProxy("map") %>%
          # hideHexbin()%>%
          showGroup("Hex") %>%
        #   # clearGroup("Hex2")%>%
          updateHexbin(colorRange = c("#fcfcfc00","#fcfcfc00"))
          # clearHexbin()
        # %>%
          # addHexbin(lng = df$Long, lat = df$Lat,opacity=0,
          #           options = hexbinOptions(duration=0,colorRange = c("red", "yellow", "blue"),radiusRange = c(10, 10)))
        
      } else if (zoom <= 9 & prev_zoom()>=9){
        print("Add")
        # removeClass(selector = "div.hexbin-tooltip", class = "hidden")
        output$style <- renderUI({
          tags$style(style)
        })        
        
        # removeClass(selector = "g.hexbin-container", class = "hidden")
        leafletProxy("map") %>%
          hideGroup("Hex")%>%
          updateHexbin(colorRange = c("#FEE5D9", "#A50F15"))
          # showHexbin()
          # addHexbin(lng = df$Long, lat = df$Lat,opacity = 0.7,
          #           options = hexbinOptions(duration=0,colorRange = c("#FEE5D9", "#A50F15"),radiusRange = c(15, 15),tooltip = "Total " ))
      }else if(zoom>9){
        # addClass(selector = "g.hexbin-container", class = "hidden")
        
      }
    }

    
    prev_zoom(zoom)
    
  })
}

# Run the app
shinyApp(ui, server)














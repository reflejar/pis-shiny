# app.R
library(shiny)
library(leaflet)
library(leaflet.extras2)
library(shinyjs)
library(sfarrow)
library(arrow)
library(sf)
library(shinyWidgets)
library(fontawesome) #devtools::install_github("rstudio/fontawesome")

Sys.setlocale("LC_ALL", "en_US.UTF-8")

honeycomb_count=st_read_parquet("./data/hexagonos.parquet")
df=read_parquet("./data/puntos.parquet")
amb=read_parquet("./data/ambientales.parquet")
amb$type=as.character(amb$type)

# oceanIcons <- iconList(
#   lluvia = makeIcon("https://www.svgrepo.com/show/467241/rain-alt.svg", iconWidth = 25, iconHeight = 25),
#   agua_corriente = makeIcon("./data/water.png", iconWidth = 25, iconHeight = 25),
#   vegetal=makeIcon("./data/leaf.png", iconWidth = 25, iconHeight = 25),
#   suelo=makeIcon("https://www.svgrepo.com/show/227146/soil.svg", iconWidth = 25, iconHeight = 25)
# )
oceanIcons <- awesomeIconList(
  agua_pozo = makeAwesomeIcon(text = fa("house-flood-water"),markerColor="lightblue"),
  agua_superficial = makeAwesomeIcon(text = fa("water"),markerColor="lightblue"),
  agua_lluvia = makeAwesomeIcon(text = fa("cloud-rain"),markerColor="lightblue"),
  agua_red = makeAwesomeIcon(text = fa("faucet"),markerColor="lightblue"),
  sedimento=makeAwesomeIcon(text = fa("mound"),markerColor="lightgreen"),
  vegetal=makeAwesomeIcon(text = fa("leaf"),markerColor="lightgreen"),
  suelo=makeAwesomeIcon(text = fa("mountain"),markerColor="lightgreen"),
  aire=makeAwesomeIcon(text = fa("wind"),markerColor="gray")

)

# Calculate the bounding box of the points
bbox <- st_bbox(honeycomb_count)

# Calculate the center of the bounding box
bbox_sf <- st_as_sfc(bbox)
center <- st_centroid(bbox_sf)

# Extract the latitude and longitude from the center coordinates
coords <- st_coordinates(center)
lat <- coords[2]
long <- coords[1]


palette <- colorBin('Reds', domain = honeycomb_count$n_colli, bins = 5)
# palette(0)
# palette(4)

hover=lapply(honeycomb_count$Tooltip, htmltools::HTML)
hover_popup=lapply(honeycomb_count$Popup, htmltools::HTML)

hover_markers=lapply(amb$Tooltip, htmltools::HTML)




style <- HTML("
  .material-switch > label:before {
      background: rgb(0, 0, 0);
      box-shadow: inset 0px 0px 10px rgba(0, 0, 0, 0.5);
      border-radius: 45px;
      content: '';
      height: 28px;
      margin-top: -13.5px;
      position:absolute;
      opacity: 0.3;
      transition: all 0.4s ease-in-out;
      width: 46px;
  }




  .label-danger{
  background-color: #F1405D;
  }
  .label-primary{
  background-color: #D8D87C;
  }

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
  
  .marker-cluster-small {
  background-color: rgba(	255,193,0, 0.6);
  }
  .marker-cluster-small div {
  background-color: rgba(255,154,0, 0.6);
  }
  
  .marker-cluster-medium {
  background-color: rgba(255,154,0, 0.6);
  }
  .marker-cluster-medium div {
  background-color: rgba(255,77,0, 0.6);
  }
  
  .marker-cluster-large {
  background-color: rgba(255,77,0, 0.6);
  }
  .marker-cluster-large div {
  background-color: rgba(255,0,0, 0.6);
  }`
    
  
")

style_hidden <-HTML( "

   .material-switch > label:before {
      background: rgb(0, 0, 0);
      box-shadow: inset 0px 0px 10px rgba(0, 0, 0, 0.5);
      border-radius: 45px;
      content: '';
      height: 28px;
      margin-top: -13.5px;
      position:absolute;
      opacity: 0.3;
      transition: all 0.4s ease-in-out;
      width: 46px;
  }
  



  .label-danger{
  background-color: #F1405D;
  }
  .label-primary{
  background-color: #D8D87C;
  }
  
  .hexbin-hexagon {
    display:none
  }
  
  .hexbin-container:hover .hexbin-hexagon {
    display:none

  }
  
  .hexbin-tooltip {
    display:none

  }
  
  .marker-cluster-small {
  background-color: rgba(	255,193,0, 0.6);
  }
  .marker-cluster-small div {
  background-color: rgba(255,154,0, 0.6);
  }
  
  .marker-cluster-medium {
  background-color: rgba(255,154,0, 0.6);
  }
  .marker-cluster-medium div {
  background-color: rgba(255,77,0, 0.6);
  }
  
  .marker-cluster-large {
  background-color: rgba(255,77,0, 0.6);
  }
  .marker-cluster-large div {
  background-color: rgba(255,0,0, 0.6);
  }`
  
")
# Define UI
ui <- fluidPage(
  tags$head(tags$style(style)),
  tags$link(
    rel = "stylesheet", 
    href="https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap"
  ),
  materialSwitch(inputId = "switch1", label = "Testeos Humanos", status = "danger",value=T,right = T),
  materialSwitch(inputId = "switch2", label = "Testeos Ambientales", status = "primary",value=F,right=T),
  uiOutput("style"),
  leafletOutput("map", width = "80%", height = "600px")
)

# Define server
server <- function(input, output, session) {
  
  output$style <- renderUI({
    tags$style(style_hidden)
  })
  
  initial_zoom=7
  prev_zoom <- reactiveVal(NULL)

  pal <- colorFactor(palette = c("blue", "red", "#0ea603"), domain = amb$type)
  # Create a Leaflet map
  output$map <- renderLeaflet({
    leaflet()%>%setView(lat = lat,lng=long,zoom = initial_zoom)%>%
      addMapPane("HexPane",zIndex = 400)%>%
      addPolygons(data=honeycomb_count,fillColor = ~palette(n_colli),
                  label = hover,popup = hover_popup,
                  popupOptions = popupOptions(maxHeight ="300",minWidth = "300",
                                              closeOnClick = TRUE),
                  fillOpacity = 0.5,color="black",opacity=1,weight=1,group="Hex",
                  options = pathOptions(pane = "HexPane"),
                  # Highlight neighbourhoods upon mouseover
                  highlight = highlightOptions(
                    weight = 2,
                    fillOpacity = 0.7,
                    color = "black",
                    opacity = 1.0,
                    bringToFront = TRUE,
                    sendToBack = TRUE), )%>%
      hideGroup("Hex")%>%
      # Set the detail group to only appear when zoomed in
      # groupOptions("Hex", zoomLevels = 9:18)%>%
      addTiles()%>%
      addHexbin(lng = df$Long, lat = df$Lat,opacity=0.7,
                options = hexbinOptions(pointerEvents = "all",duration=0,
                                        colorRange =c("#FEE5D9", "#A50F15"),
                                        radiusRange = c(20, 20),tooltip =  JS("function(d) {return '<b>Testeos Positivos: ' + d.length +'</b><br>' +'Zoom para más información';} ")))

  })
  
  #Hacer zoom cuando el usuario clickea en el mapa
  observeEvent(input$map_click, {
    leafletProxy("map") %>% setView(lat = input$map_click$lat, lng = input$map_click$lng, zoom = 10)
  })
  
  # Hide the marker layer when zoom level is greater than 16
  observeEvent(input$map_zoom,{
    zoom <- input$map_zoom
    # if(is.null(prev_zoom())){
    #   # prev_zoom()
    # }else{
      
      
      
      if (input$switch1) {
         print(zoom)
        # print(prev_zoom())
        if (zoom >= 9 ) {
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
          
        } else if (zoom < 9){
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
      
    # }

    
    prev_zoom(zoom)
    
  })
  
  observeEvent(input$switch2, {
    proxy <- leafletProxy("map")
    if (input$switch2) {
      proxy %>% clearGroup("Ambientales2")
      
      proxy %>% addAwesomeMarkers(data=amb,lat=~Lat,lng=~Long,label=hover_markers,icon = ~oceanIcons[type],
                                 group = "Ambientales",clusterOptions = markerClusterOptions(spiderfyOnMaxZoom=T,disableClusteringAtZoom=11,
                                                                                             removeOutsideVisibleBounds=T))
    } else {
      proxy %>% clearGroup("Ambientales")
    }
  })
  
  observeEvent(input$switch1, {
    proxy <- leafletProxy("map")
    if (input$switch1) {
      proxy %>% showGroup("Hex")
    } else {
      proxy %>% hideGroup("Hex")
      output$style <- renderUI({
        tags$style(style_hidden)
      })
      
      # toggleClass(class = "hexbin-hexagon2", selector = "div.hexbin-hexagon")
      # removeUI(selector = "div.hexbin-tooltip")
      leafletProxy("map") %>%
        # hideHexbin()%>%
        # showGroup("Hex") %>%
        #   # clearGroup("Hex2")%>%
        updateHexbin(colorRange = c("#fcfcfc00","#fcfcfc00"))
    }
  })
  

}

# Run the app
shinyApp(ui, server)




# rsconnect::setAccountInfo(name='pis-mapa-testeos', token='1CFD7B7F0BCD06421981F1AA1928462E', secret='7nekrHMRUgegrN0A+dke+qMSaLWcoGuRWYgOFl32')
# # 
# library(rsconnect)
# rsconnect::deployApp('./')
# runApp("~/shinyapp")
# 
# getwd()
# 
# rsconnect::showLogs()

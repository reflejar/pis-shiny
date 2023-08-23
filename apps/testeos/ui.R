library(shiny)
library(leaflet)
library(leaflet.extras2)
library(shinyjs)
library(sfarrow)
library(arrow)

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

shinyUI(fluidPage(
  includeCSS("../www/bootstrap.min.css", rel = 'stylesheet'),
  tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.min.css'),

  tags$head(tags$style(style)),
  uiOutput("style"),
  leafletOutput("map"),
  tags$footer(
    fluidRow(
      tags$div(
          column(
              tags$div(
                tags$a(tags$i(class="bi bi-twitter"), href="https://twitter.com/fundacionDER",target="_blank", class="btn mx-3 btn-lg btn-floating"),
                tags$a(tags$i(class="bi bi-instagram"), href="https://www.instagram.com/democraciaenred/",target="_blank", class="btn mx-3 btn-lg btn-floating"),
                tags$a(tags$i(class="bi bi-facebook"), href="https://www.facebook.com/democraciaenred",target="_blank", class="btn mx-3 btn-lg btn-floating"),
                tags$a(tags$i(class="bi bi-linkedin"), href="https://www.linkedin.com/company/democracia-en-red/",target="_blank", class="btn mx-3 btn-lg btn-floating"),
                class="text-center"
              ),
              width=12
          ),
      ),
    ),
    class="text-white position-relative pb-5 container",
    id="footer",
  ),
))




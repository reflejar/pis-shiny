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
  # includeCSS("../www/bootstrap.min.css", rel = 'stylesheet'),
  suppressDependencies("bootstrap"),
  theme="../www/bootstrap.min.css",
  tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.min.css'),
  tags$head(
    tags$style(style)
  ),

  tags$nav(
      tags$div(
        tags$a(
          tags$img(alt="Isotipo de PIS", height="70px", src="../www/img/PIS_isologo_negro.png")
        ),
        tags$nav(
          tags$a("Volver a PIS",class="btn text-uppercase", href="https://pis.org.ar"),
          class="navbar-nav"
        ),
        class="container"
      ),
      class="text-primary navbar navbar-expand-md navbar-light bg-light fixed-top",
  ),
  uiOutput("style"),
  tags$div(
    leafletOutput("map"),
    class="my-5 mx-5 min-vh-100"
  ),
  
  tags$footer(
      tags$div(
        fluidRow(
          tags$div(
            fluidRow(
              tags$div(
                tags$img(alt="Isotipo de PIS", height="70px", src="../www/img/PIS_isologo_negro.png")
                class="col-lg-2"
              ),
              tags$div(
                "PIS es un proyecto de",
                tags$a()
                class="col-lg-10"
              )
            )
            class="col-lg-6"
          )
        )
        class="container"
      )
      class="text-white position-relative py-4",
      id="footer"
  ),
))




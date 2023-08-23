library(shiny)
library(leaflet)
library(leaflet.extras2)
library(shinyjs)
library(shinyWidgets)
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
  # includeCSS("../assets/bootstrap.min.css", rel = 'stylesheet'),
  suppressDependencies("bootstrap"),
  theme="../assets/bootstrap.min.css",
  tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.min.css'),
  tags$head(tags$style(style)),
  tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap"),


  # NAVBAR
  tags$nav(
      tags$div(
        tags$a(
          tags$img(alt="Isotipo de PIS", height="70px", src="../assets/img/PIS_isologo_negro.png")
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

  # CONTENIDO
  tags$div(

    fluidRow(
      tags$div(
        tags$div(
          tags$h4(
            "Mapa colaborativo de testeos",
            class="text-white text-uppercase pt-2"
          ),
          tags$p(
            "Investigación de 200 casos realizados en las localidades de Lobos, Mar Chiquita , Saladillo, Barrio Nicole (La matanza) y CABA para la detección de plaguicidas en humanos.",
            class="mt-5"
          ),  
          tags$div(
            materialSwitch(inputId = "switch1", label = "Testeos Humanos", status = "danger",value=T),
            materialSwitch(inputId = "switch2", label = "Testeos Ambientales Iconos", status = "primary",value=F),
            class="mt-5"
          ),
          class="mt-5 container"
        ),
        class="col-lg-3 col-md-12"
      ),

      tags$div(
        tags$div(
          leafletOutput("map", width = "100%", height = "600px"),
          class="mt-5"
        ),
        class="col-lg-9 col-md-12"
      ),
      class="mt-5"
    ),
    
    class="my-5 mx-5 min-vh-75"
  ),

  # FOOTER
  tags$footer(
      tags$div(
        fluidRow(
          tags$div(
            fluidRow(
              tags$div(
                tags$img(alt="Isotipo de PIS", height="70px", src="../assets/img/PIS_isologo_negro.png"),
                class="col-lg-2"
              ),
              tags$div(
                "PIS es un proyecto de",
                tags$a(
                  "Democracia en Red",
                  href="https://democraciaenred.org",
                  target="_blank"
                ),
                ",",
                tags$br(),
                "una ONG con base en Buenos Aires, Argentina.",
                class="col-lg-10"
              )
            ),
            class="col-lg-6"
          ),
          tags$div(
            tags$a(
              "Explorá las demás herramientas",
              class="btn btn-outline-light text-uppercase",
              href="https://pis.org.ar"
            ),
            class="col-lg-6 text-end"
          )          
        ),
        class="container"
      ),
      class="text-white position-relative py-4",
      id="footer"
  ),

  

))




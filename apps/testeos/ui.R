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
  # includeCSS("bootstrap.min.css", rel = 'stylesheet'),
  tags$meta(name="viewport", content="width=device-width, initial-scale=1"),
  suppressDependencies("bootstrap"),
  theme="bootstrap.min.css",
  tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.min.css'),
  tags$head(tags$style(style)),
  tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap"),


  # NAVBAR
  tags$nav(
      tags$div(
        tags$a(
          tags$img(alt="Isotipo de PIS", height="70px", src="img/PIS_isologo_negro.png")
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
    tags$div(
        tags$div(
          tags$h3(
            "Mapa colaborativo de testeos",
            tags$a("V 1.0", href="#metodologia-testeos", class="btn btn-sm text-primary"),
            class="text-white pt-3 fw-bolder space-grotesk"
          ),
          tags$br(),
          tags$p(
            "Resultados de análisis e informes de trazas de agroquímicos. Buscá en el mapa y observá la presencia de agroquímicos en humanos, agua y territorios de la provincia de Buenos Aires.",
            class="text-white poppins"
          ),
          class="col-12 mt-5"          
        ),
        class="row"
    ),

    tags$div(
      tags$div(
        tags$div(

          tags$div(
            materialSwitch(inputId = "switch1", label = "Testeos Humanos", status = "danger",value=T, right = T),
            materialSwitch(inputId = "switch2", label = "Testeos Ambientales Iconos", status = "primary",value=T, right = T),
            class="mt-3 mb-5 text-white"
          ),
          tags$img(alt="Línea", src="img/linea.svg", class="mt-5 mb-3"),
          tags$p(
            "SUMÁ RASTROS DE PIS",
            tags$br(),
            "Este mapa se construye colaborativamente con estudios, informes e investigaciones provenientes de distintas fuentes. Tiene un enfoque colectivo, participativo y abierto por lo que podes",  
            tags$a("descargar el dataset", href="#"),
            "del mapa o aportar información de análisis aquí.",
            class="text-white poppins"            
          ),
          tags$a(
            tags$b("Sumá tus datos"),
            href="https://donaronline.org/democracia-en-red/campana-recaudacion-proyecto-pis",
            target="_blank",
            class="btn btn-primary text-black mt-2"
          ),
          class="container"
        ),
        class="col-lg-4 col-md-12"
      ),

      tags$div(
        tags$div(
          leafletOutput("map", width = "100%", height = "450px"),
          class="mt-3"
        ),
        class="col-lg-8 col-md-12"
      ),
      class="row"
    ),
    
    class="my-5 container min-vh-75"
  ),

  # FOOTER
  tags$footer(
      tags$div(
            fluidRow(
              tags$div(
                tags$img(alt="Isotipo de PIS", height="70px", src="img/PIS_isologo_negro.png"),
                tags$p(
                  "PIS es un proyecto de",
                  tags$a(
                    "Democracia en Red",
                    href="https://democraciaenred.org",
                    target="_blank"
                  ),
                  ",",
                  tags$br(),
                  "una ONG con base en Buenos Aires, Argentina.",
                  class="mx-4"
                  ),
                class="col-lg-6 d-flex align-items-center"
              ),
              tags$div(
                tags$a(
                  "Explorá las demás herramientas",
                  class="btn btn-outline-light text-uppercase",
                  href="https://pis.org.ar"
                ),
                class="col-lg-6 text-end mt-3"
              )          
            ),
        class="container"
      ),
      class="text-white position-relative py-4",
      id="footer"
  ),

  

))




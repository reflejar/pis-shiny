library(shiny)
library(leaflet)
library(leaflet.extras2)
library(shinyjs)
library(shinyWidgets)
library(sfarrow)
library(arrow)


shinyUI(fluidPage(
  # includeCSS("bootstrap.min.css", rel = 'stylesheet'),
  theme="bootstrap.min.css",
  suppressDependencies("bootstrap"),
  
  tags$head(
    tags$meta(name="viewport", content="width=device-width, initial-scale=1"),
    # tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.min.css'),
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css'),
    tags$link(rel="stylesheet", href = 'custom.css'),
    tags$link(rel="icon", type="image/x-icon", href = 'favicon.ico'),
    tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap"),
    tags$title("PIS")
  ),


  # NAVBAR
  tags$nav(
      tags$div(
        tags$a(
          tags$img(alt="Isotipo de PIS", height="70px", src="img/PIS_isologo_negro.png")
        ),
        tags$nav(
          tags$a("Volver a PIS",class="btn text-uppercase poppins", href="https://pis.org.ar"),
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
            materialSwitch(inputId = "switch2", label = "Testeos Ambientales", status = "primary",value=F, right = T),
            class="mt-3 mb-5 text-white"
          ),
          tags$img(alt="Línea", src="img/linea.svg", class="mt-5 mb-3"),
          tags$p(
            "SUMÁ RASTROS DE PIS",
            tags$br(),
            "Este mapa se construye colaborativamente con estudios, informes e investigaciones provenientes de distintas fuentes. Tiene un enfoque colectivo, participativo y abierto por lo que podes",  
            tags$a("descargar el dataset", href="data/Testeos.xlsx", target="_blank"),
            "del mapa o aportar información de análisis aquí.",
            class="text-white poppins"            
          ),
          tags$a(
            tags$b("Sumá tus datos"),
            href="https://docs.google.com/forms/d/e/1FAIpQLSeB0yNZPLNQxbWD-cJKVa96haz74oWVOGEPOZDCUBHEdHb4gg/viewform?usp=sf_link",
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

    tags$div(
      tags$div(
        tags$h5(tags$strong("METODOLOGÍA & PRODUCTO"), tags$span("V1.0", class="badge bg-primary text-black mx-3"), class="text-white pt-3 space-grotesk"),
        tags$p("Esta herramienta es un sistema de información geográfica (GIS) para mapear colaborativamente detección de agroquímicos en humanos , animales y ambiente. Se grafican datos anonimizados para georeferenciar el resultado tanto de análisis de orina que detectan trazas de plaguicidas en humanos, como también distintos análisis sobre la presencia de estos en el ambiente. Podemos clasificar a los análisis ambientales los podemos clasificar en 7 subtipos:"),
        tags$ul(
          tags$li(tags$i(class="fa fa-faucet"), "Análisis de agua de red."),
          tags$li(tags$i(class="fa fa-house-flood-water"), "Análisis de agua de pozo."),
          tags$li(tags$i(class="fa fa-water"),"Análisis de agua superficial."),
          tags$li(tags$i(class="fa fa-cloud-rain"), "Análisis de agua de lluvia."),
          tags$li(tags$i(class="fa fa-mountain"), "Análisis de sedimentos."),
          tags$li(tags$i(class="fa fa-mound"), "Análisis de suelo."),
          tags$li(tags$i(class="fa fa-leaf"), "Análisis de material vegetal."),
          tags$li(tags$i(class="fa fa-fish"), "Análisis en peces."),
        ),
        tags$p("El mapa posee información proveniente de distintas fuentes. Investigaciones científicas, estudios realizados por comunidades u organizaciones del territorio, muestras de análisis hechos por individuos particulares y resultados de una investigación realizada por P.I.S de más de 200 testeos realizados en las localidades de Lobos, Mar Chiquita, Saladillo, La Matanza y CABA. Cada dato se encuentra mapeado con su resultado, su fuente correspondiente y una pequeña descripción que amplía su información."),
        class="col-12 text-white mt-5", id="metodologia-testeos"
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




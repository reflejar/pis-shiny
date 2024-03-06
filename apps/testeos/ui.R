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
    tags$title("PIS"),
    tags$head(
      tags$script(
        src = "https://www.googletagmanager.com/gtag/js?id=G-4SVX2N6H9Z",
        async = ""
      ),
      tags$script(
        src = "js/gtag.js"
      )
    )
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
            "Testeos",
            tags$a("V 1.0", href="#metodologia-testeos", class="btn btn-sm text-primary"),
            class="text-white pt-3 fw-bolder space-grotesk"
          ),
          tags$br(),
          tags$p(
            "Sistema de información geográfica colaborativo de detecciones de agroquímicos en humanos, animales, agua, sedimentos y material vegetal. Buscá en el mapa y observá los reportes de presencia de agroquímicos en territorios de la Provincia de Buenos Aires.",
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
            materialSwitch(inputId = "switch2", label = "Testeos Ambientales", status = "primary",value=T, right = T),
            class="mt-3 mb-5 text-white"
          ),
          tags$img(alt="Línea", src="img/linea.svg", class="mt-5 mb-3"),
          tags$p(
            "SUMÁ RASTROS DE PIS",
            tags$br(),
            "Este mapa se construye colaborativamente con estudios, informes e investigaciones provenientes de distintas fuentes. Tiene un enfoque colectivo, participativo y abierto por lo que podes",  
            tags$a("descargar el dataset", href="https://docs.google.com/spreadsheets/u/1/d/1IBAYC8rleTYOV02HJ3ZDNDtIlRQZheXk/edit#gid=1161902790", target="_blank"),
            "del mapa o aportar información de análisis.",
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
        tags$p("Esta herramienta es un sistema de información geográfica (GIS) para mapear colaborativamente la ", tags$b("detección de agroquímicos en humanos, animales y el ambiente. ")),
        tags$p("Se visualizan datos anonimizados que georreferencian los resultados tanto de análisis de orina, que revelan trazas de plaguicidas en humanos, así como también distintos análisis sobre la presencia de estos en el ambiente. Los análisis ambientales se dividen en 8 subtipos, cada uno de estos se ubicarán en el mapa con su icono correspondiente:"),
        tags$p(tags$b("Ambientales")),
        tags$ul(
          tags$li(tags$i(tags$img(alt="Ícono de análisis de agua de red", height="35px", src="img/iconos/agua_red.svg")), "Análisis de agua de red."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de agua de pozo", height="35px", src="img/iconos/agua_pozo.svg")), "Análisis de agua de pozo."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de agua superficial.", height="35px", src="img/iconos/agua_superficial.svg")), "Análisis de agua superficial."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de agua de lluvia.", height="35px", src="img/iconos/agua_lluvia.svg")), "Análisis de agua de lluvia."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de sedimentos.", height="35px", src="img/iconos/sedimentos.svg")), "Análisis de sedimentos."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de suelo.", height="35px", src="img/iconos/suelo.svg")), "Análisis de suelo."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de material vegetal.", height="35px", src="img/iconos/materia_vegetal.svg")), "Análisis de material vegetal."),
          tags$li(tags$i(tags$img(alt="Ícono de análisis de particulas de aire.", height="35px", src="img/iconos/particulas_aire.svg")), "Análisis de Particulas de aire."),
        ),
        tags$p(tags$b("Animales")),
        tags$ul(
          tags$li(tags$i(tags$img(alt="Ícono de análisis en peces", height="35px", src="img/iconos/peces.svg")), "Análisis de peces."),
        ),
        tags$p(tags$b("Testeos ambientales superpuestos", class="text-uppercase")),
        tags$p("Al ingresar al mapa, se observarán zonas coloreadas con números que indican la cantidad de muestras en esas áreas. Estas zonas integran varios resultados superpuestos y a medida que se acerca el zoom, se revelan iconos o hexágonos según corresponda, proporcionando detalles específicos de cada análisis o testeo."), 
        tags$ul(
          tags$li(tags$i(tags$img(alt="Ícono de grupos de testeos ambientales", height="35px", src="img/iconos/grupos_ambientales.svg")), "Grupo de testeos ambientales."),
        ),
        tags$p(tags$b("Testeos en Humanos", class="text-uppercase")),
        tags$p("Por su parte los estudios de agroquímicos en humanos, se mostrarán como hexágonos distribuidos aleatoriamente en un rango previamente establecido de 5 km desde su ubicación original. (Todos los estudios en humanos se encuentran debidamente anonimizados, resguardando toda información sensible)."), 
        tags$ul(
          tags$li(tags$i(tags$img(alt="Ícono de grupos de testeos en humanos", height="35px", src="img/iconos/grupos_humanos.svg")), "Grupo de testeos positivos en Humanos."),
        ),
        tags$p(tags$i("Las áreas con una mayor concentración de casos positivos aparecerán con tonalidades más oscuras, mientras que aquellas con menos casos se visualizarán de manera más clara. "), class="w-50"),                
        tags$img(alt="Ícono de barra de peligrosidad", width="200px", src="img/iconos/barra.svg"),
        tags$p(tags$i("El mapa posee información proveniente de distintas fuentes. Investigaciones científicas, estudios realizados por comunidades u organizaciones del territorio, muestras de análisis hechos por individuos particulares y resultados de testeos propios realizados en el marco del Proyecto PIS. Cada dato se encuentra mapeado con su resultado, su fuente correspondiente y una pequeña descripción que amplía su información (cada muestra posee fecha, entidad solicitante y laboratorio que hizo el estudio).")),
        tags$p(tags$i('*Este proyecto posee un enfoque colectivo, participativo y abierto. Si encontraste algún error o información desactualizada comunícate a ', tags$a("contacto@democraciaenred.org",href="mailto:contacto@democraciaenred.org"))),
        tags$p(tags$i('Acede al data set de esta herramienta ', tags$a("acá", href="https://docs.google.com/spreadsheets/u/1/d/1IBAYC8rleTYOV02HJ3ZDNDtIlRQZheXk/edit#gid=1161902790", target="_blank"))),        
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




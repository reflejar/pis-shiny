FROM rocker/r-base:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libgdal-dev \
    libproj-dev \
    libgeos-dev \
    libudunits2-dev \
    netcdf-bin \    
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('shiny', 'shinyjs', 'data.table','sf','dplyr','tidyr', 'leaflet', 'leaflet.extras2'), repos='http://cran.rstudio.com/')"

RUN addgroup --system app \
    && adduser --system --ingroup app app

WORKDIR /home/app

COPY . .

RUN chown app:app -R /home/app

USER app

EXPOSE 3838

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL created $BUILD_DATE
LABEL version $VERSION
LABEL revision $REVISION

LABEL vendor "Democracia en Red & Reflejar"
LABEL title "Pesticidas introducidos silenciosamente"

CMD ["R", "-e", "shiny::runApp('/home/app/app.R')"]
FROM ghcr.io/rocker-org/shiny:4.3

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


RUN R -e "install.packages(c('shinyjs'))"
RUN R -e "install.packages(c('data.table'))"
RUN R -e "install.packages(c('units'))"
RUN R -e "install.packages(c('sf'))"
RUN R -e "install.packages(c('dplyr'))"
RUN R -e "install.packages(c('tidyr'))"
RUN R -e "install.packages(c('leaflet'))"
RUN R -e "install.packages(c('leaflet.extras2'))"
RUN R -e "install.packages(c('arrow'))"
RUN R -e "install.packages(c('sfarrow'))"
RUN R -e "install.packages(c('shinyWidgets'))"
RUN R -e "install.packages(c('fontawesome'))"

RUN rm -rf /srv/shiny-server

COPY apps/ /srv/shiny-server/
COPY config.sh /config.sh
RUN chmod +x /config.sh

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL created $BUILD_DATE
LABEL version $VERSION
LABEL revision $REVISION

LABEL vendor "Democracia en Red & Reflejar"
LABEL title "Pesticidas introducidos silenciosamente"

WORKDIR /srv/shiny-server/

CMD ["/bin/bash", "-c", "/config.sh && /usr/bin/shiny-server"]
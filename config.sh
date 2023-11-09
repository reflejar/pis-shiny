#!/bin/bash

if [ -z "$APP_CONFIG" ]; then
  echo "La variable de entorno APP_CONFIG no está definida."
  exit 1
fi

if [ ! -d "$APP_CONFIG" ]; then
  echo "La carpeta especificada en APP_CONFIG no existe."
  exit 1
fi

cp -r "$APP_CONFIG"/* /srv/shiny-server/
![Header](assets/img/ryder_isologotipos.png)

# PIS - Aplicaciones Shiny

Aplicaciones realizadas en R shiny para proyecto PIS de Democracia en Red

- Módulo de Testeos


## Manual de integración

El presente repositorio forma parte de un proyecto que integra múltiples tecnologías. Para conocer más accedé a nuestro [Manual de integración](https://github.com/reflejar/pis-manual)


## Setup

Hay 2 maneras de preparar el entorno para desarrollo. A través de un entorno virtual con renv, o a través de Docker

### 1 - Docker

> #### ⚠️ Prerequisitos
> 
> Este entorno virtual requiere de:
> - [Docker](https://docs.docker.com/engine/install/_) y (docker) compose (que en las nuevas versiones ya viene en la instalación de docker)

#### Instalación

Abrí una terminal del sistema en el directorio raiz del proyecto y construí la imagen de docker

```bash
$ docker compose build
```

#### Ejecución

Abrí una terminal del sistema en el directorio raiz del proyecto y ejecutá la imagen en un contenedor

```bash
$ docker compose up
```


### 2 - Entorno virtual (renv)

> #### ⚠️ Prerequisitos
> 
> ToDo
>

#### Instalación

Abrí una terminal del sistema en el directorio raiz del proyecto y ejecutá el archivo setup/dev.R.
Esto se fija si tenés instalado renv y si no está lo instala. Luego activa el entorno e instala las dependencias
Por último ejecuta la aplicación

```bash
$ Rscript setup.R
```

#### Ejecución

Abrí una terminal del sistema en el directorio raiz del proyecto y ejecutá la aplicación que necesites


```bash
$ Rscript -e "shiny::runApp('apps/<app-deseada>')"
```



## Licencia

El siguiente repositorio es un desarrollo de codigo abierto bajo la licencia GNU General Public License v3.0. Pueden acceder a la haciendo [click aqui](./LICENSE).


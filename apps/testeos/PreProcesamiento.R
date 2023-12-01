library(data.table)
library(openxlsx)
library(sf)
library(dplyr)
library(tidyr)
library(sfarrow)
library(arrow)
library(leaflet)
archivo_data_testeos="C:/Users/simon/Downloads/BASE_ANALISIS_AMBIENTALESyORINA(4).xlsx"
data=read.xlsx(archivo_data_testeos,sheet = "ORINA",detectDates = TRUE)
names(data)=iconv(names(data), from = "UTF-8", to = "ASCII//TRANSLIT")
data=data[!(is.na(data$GEORREFERENCIACON)),]

# names(data)[names(data)=="RESULTADOS"][1]="RESULTADOS1"

#Filtrar data para sacar casos no positivos (version simple por ahora)

data=data[grepl("/",data$GLIFOSATO.EN.ORINA)|grepl("/",data$`GLIFOSATO.EN.ORINA.(AMPA)`),]
data$FECHA=format(as.Date(data$FECHA), "%d/%m/%Y")

df <- separate(data, GEORREFERENCIACON, into = c("Lat", "Long"), sep = ",")
df$Long=as.numeric(df$Long)
df$Lat=as.numeric(df$Lat)

# df=st_as_sf(df,coords=c("Long","Lat"))

# leaflet(df)%>%addCircleMarkers()%>%addTiles()

#dataframe to spatial object
df2 <- st_as_sf(x = df,                         
                coords = c("Long", "Lat"),
                crs = "4326",
                na.fail=FALSE)
st_crs(df2)=st_crs(4326)




# df2$abun=1:nrow(df2)
# map=leaflet()%>%addCircleMarkers(data=df2)%>%addTiles()
# 
# 
# leaflet()%>%addTiles()%>%
# addHeatmap(lng=df$Long,lat=df$Lat,
#            layerId = NULL, group = NULL, minOpacity = 0.05, max = 1,
#            radius = 20, blur = 25, cellSize = 10)
# 


########
hex_data = st_transform(df2, 3857)

area_honeycomb_grid = st_make_grid(hex_data, cellsize = 10000, what = "polygons", square = FALSE)
# To sf and add grid ID
area_honeycomb_grid = st_sf(area_honeycomb_grid) %>%
  # add grid ID
  mutate(grid_id = 1:length(lengths(area_honeycomb_grid)))

# count number of points in each grid
# https://gis.stackexchange.com/questions/323698/counting-points-in-polygons-with-sf-package-of-r
int= st_intersects(area_honeycomb_grid, hex_data)

area_honeycomb_grid$Tooltip=NA
area_honeycomb_grid$Popup=NA

for (i in 1:length(int)){
  
  filas=int[[i]]
  
  if(length(filas)>0){
    tooltip=paste0(  "<span style='font-family: Fira Sans,sans-serif; font-size: 14px; line-height:2;'>","<center><b style='font-size: 16px;'>ANÁLISIS DE ORINA HUMANA</b></center>","<hr style='margin: 0;'>")
    
    largo=ifelse(length(filas)>3,3,length(filas))
    
    for(j in 1:length(filas)){
      if(j==1){
        tooltip=paste0(tooltip,"<center><b style='font-size: 12px;'>Testeo</b> <b style='font-size: 12px;'>",j,"</b>","</center>",
                       "<b>Glifosato en Orina:  </b>",data$GLIFOSATO.EN.ORINA[filas[j]],
                       " <br>","<b>Glifosato en Orina (AMPA):  </b>",data$`GLIFOSATO.EN.ORINA.(AMPA)`[filas[j]],
                       " <br>","<b>Fecha de Testeo:  </b>",data$FECHA[filas[j]],
                       " <br>","<center>","<b>Laboratorio:  </b>",data$LABORATORIO[filas[j]],"</center>",
                       "<center>","<b>Solicitante:  </b>",data$SOLICITANTE[filas[j]],"</center>"
        )  
      }else if(j<largo){
        tooltip=paste0(tooltip,"<hr style='margin: 0 ;'>","<center><b style='font-size: 12px;'>Testeo</b> <b style='font-size: 12px;'>",j,"</b>","</center>",
                       "<b>Glifosato en Orina:  </b>",data$GLIFOSATO.EN.ORINA[filas[j]],
                       " <br>","<b>Glifosato en Orina (AMPA):  </b>",data$`GLIFOSATO.EN.ORINA.(AMPA)`[filas[j]],
                       " <br>","<b>Fecha de Testeo:  </b>",data$FECHA[filas[j]],
                       " <br>","<center>","<b>Laboratorio:  </b>",data$LABORATORIO[filas[j]],"</center>",
                       "<center>","<b>Solicitante:  </b>",data$SOLICITANTE[filas[j]],"</center>")  
      }else if(j==largo){
        
        popup=paste0(tooltip,"<hr style='margin: 0 ;'>","<center><b style='font-size: 12px;'>Testeo</b> <b style='font-size: 12px;'>",j,"</b>","</center>",
                     "<b>Glifosato en Orina:  </b>",data$GLIFOSATO.EN.ORINA[filas[j]],
                     " <br>","<b>Glifosato en Orina (AMPA):  </b>",data$`GLIFOSATO.EN.ORINA.(AMPA)`[filas[j]],
                     " <br>","<b>Fecha de Testeo:  </b>",data$FECHA[filas[j]],
                     " <br>","<center>","<b>Laboratorio:  </b>",data$LABORATORIO[filas[j]],"</center>",
                     "<center>","<b>Solicitante:  </b>",data$SOLICITANTE[filas[j]],"</center>")
        tooltip=paste0(tooltip,"<hr style='margin: 0 ;'>","<center><b style='font-size: 12px;'>Click para ver ",ifelse(length(filas)-2==1, "1 resultado más",paste0(length(filas)-2," más resultados")) ,"</b> <b style='font-size: 12px;'>","</b>","</center>")
  
      }else if(j>largo){
      
        popup=paste0(popup,"<hr style='margin: 0 ;'>","<center><b style='font-size: 12px;'>Testeo</b> <b style='font-size: 12px;'>",j,"</b>","</center>",
                                     "<b>Glifosato en Orina:  </b>",data$GLIFOSATO.EN.ORINA[filas[j]],
                                     " <br>","<b>Glifosato en Orina (AMPA):  </b>",data$`GLIFOSATO.EN.ORINA.(AMPA)`[filas[j]],
                                     " <br>","<b>Fecha de Testeo:  </b>",data$FECHA[filas[j]],
                                     " <br>","<center>","<b>Laboratorio:  </b>",data$LABORATORIO[filas[j]],"</center>",
                                     "<center>","<b>Solicitante:  </b>",data$SOLICITANTE[filas[j]],"</center>")  
          
      }
      
      if(j==length(filas)){
        tooltip=paste0(tooltip,"</span>")
        popup=paste0(popup,"</span>")
        
      }
      
    }  
    area_honeycomb_grid$Tooltip[i]=tooltip  
    area_honeycomb_grid$Popup[i]=popup  
    
  }
  
}


area_honeycomb_grid$n_colli = lengths(int)

# remove grid without value of 0 (i.e. no points in side that grid)
honeycomb_count = filter(area_honeycomb_grid, n_colli > 0)

honeycomb_count=st_transform(honeycomb_count,4326)

df$Lat=as.numeric(df$Lat)
df$Long=as.numeric(df$Long)

honeycomb_count_centroide=st_centroid(honeycomb_count)
honeycomb_count$Lat <- st_coordinates(honeycomb_count_centroide$area_honeycomb_grid)[, 2]
honeycomb_count$Long <- st_coordinates(honeycomb_count_centroide$area_honeycomb_grid)[, 1]

df2_ajustado=st_join(df2,honeycomb_count)

df2_ajustado=st_drop_geometry(df2_ajustado)

# df2_ajustado <- st_as_sf(df2_ajustado, coords = c("Long", "Lat"))

# leaflet(df2_ajustado)%>%addCircleMarkers()%>%addTiles()

df2_ajustado[df2_ajustado=="NO DETECTABLE"]=NA
df2_ajustado=df2_ajustado[,-which(grepl("DIRECCI|LOCALIDAD",names(df2_ajustado)))]
df2_ajustado=df2_ajustado[,-which(names(df2_ajustado)=="ID")]


hover=lapply(honeycomb_count$Tooltip, htmltools::HTML)

leaflet(honeycomb_count)%>%addPolygons(label=hover)%>%addTiles()


write_parquet(df2_ajustado,"./data/puntos.parquet")
st_write_parquet(honeycomb_count,"./data/hexagonos.parquet")

###############################################################################


##########  AMBIENTALES  

library(leaflet)
library(stringr)

data=read.xlsx(archivo_data_testeos,sheet = "AMBIENTALES",detectDates = TRUE)
data$CITA.PAPER=iconv(data$CITA.PAPER, from = "UTF-8", to = "ASCII//TRANSLIT")
data$CITA.PAPER=gsub("Dato recuperado del articulo: ","",data$CITA.PAPER)

data$paper_fecha=as.numeric(str_extract(data$CITA.PAPER,  "(?<=\\().+?(?=\\))"))
# names(data)=iconv(names(data), from = "UTF-8", to = "ASCII//TRANSLIT")
data=data[!(is.na(data$GEOREFERENCIACIÓN)),]
# names(data)[names(data)=="RESULTADOS"][1]="RESULTADOS1"

#Filtrar data para sacar casos no positivos (version simple por ahora)


#CAMBIAR PARA AGREGAR TODAS LAS VARIABLES !!!!!!!!!
variables=c("Picloram", "Metomilo", "Imazapir", "Imidacloprid",
              "Dimetoato", "Atz-OH", "Atz-desisopropil", "Imazetapir", 
              "Imazapic", "Pirimicarb", "Aldicarb", "Atz-desetil",
              "Metsulfurón.Metil", "Imazaquin", "Alaclor", "Diclorvos",
              "Carbofuran", "Metribuzin", "Diclosulam", "Carbaril",
              "Metalaxil", "Ametrina", "Atrazina", "Hidroxiatrazina",
              "DEET", "Flumioxazin", "Paratión.metil", "Fomesafen",
              "Clorimurón.etil", "Malatión", "Epoxiconazol", "Azoxystrobina",
              "Triticonazol", "Flurocloridona", "Metolaclor", "Acetoclor", 
              "Acetamiprid", "Clorpirifos-Metil", "Metconazol", "Kresoxim.metil",
              "Tebuconazol", "Pirimifos.metil", "Diazinon", "Piperonil.butóxido",
              "Clorpirifos", "Tetrametrina", "Aletrina", "Pendimentalin",
              "Dicamba", "Fipronil", "2,4-DB", "2,4-D", "Halauxifen-M",
              "Glifosato", "AMPA", "Glufosinato",
            "POCs", "y-HCH", "β-HCH", "y-Chlordane"             , "α-Chlordane",             "Endosulfán",
            "α-Endosulfan",           "β-Endosulfan",             "Endosulfán.sulfato",      "p,p’-DDT", 
            "p,p’-DDE",               "p,p.́-DDD"                , "Aldrin",                  "Dieldrin",
            "Eldrin",                 "Heptacloro",               "Heptacloro.epóxido",      "Fluorocloridona",
            "Dietil-toluamida")

filas_con_data <- apply(data, 1, function(x) any(grepl("/", x)))
data=data[filas_con_data,]

data$FECHA=format(as.Date(data$FECHA), "%d/%m/%Y")
data=data[,!duplicated(names(data))]
data[is.na(data)]="-"

data <- separate(data, GEOREFERENCIACIÓN, into = c("Lat", "Long"), sep = ",")
data$Long=as.numeric(data$Long)
data$Lat=as.numeric(data$Lat)

# df=st_as_sf(df,coords=c("Long","Lat"))

# leaflet(df)%>%addCircleMarkers()%>%addTiles()

#dataframe to spatial object
datasf<- st_as_sf(x = data,                         
                coords = c("Long", "Lat"),
                crs = "4326",
                na.fail=FALSE)
st_crs(datasf)=st_crs(4326)

datasf$Tooltip=NA

#Poner ancho maximo del texto, para que no se hagan muy anchos los tooltips
data$CITA.PAPER=gsub("\n", "<br>",stringr::str_wrap(data$CITA.PAPER,width = 45))
data$SOLICITANTE.DEL.ESTUDIO=gsub("\n", "<br>",stringr::str_wrap(data$SOLICITANTE.DEL.ESTUDIO,width = 45))
data$LABORATORIO =gsub("\n", "<br>",stringr::str_wrap(data$LABORATORIO,width = 45))



names(data)

for (i in 1:nrow(data)){
  
  names(data)
  
  if(data$CITA.PAPER[i]=="-"){
    tooltip=paste0("<span style='font-family: Fira Sans,sans-serif; font-size: 14px; line-height:2;'>","<center><b style='font-size: 16px;'>",data$SECTOR.AMBIENTAL[i],"</b></center>","<hr style='margin: 0;'>",
                   " <br>","<b>Fecha de Testeo: </b>",data$FECHA[i])
    
    variables_con_data=variables[which(grepl("/",data[i,variables]))]
    
    for(variable in variables_con_data){
      tooltip=paste0(tooltip,"<br>","<b>",variable,": </b>",data[i,which(names(data)==variable)])
    }
    
    tooltip=paste0(tooltip,  " <br>","<b>Laboratorio: </b>",data$LABORATORIO[i],"<br>",
                   "<b>Solicitante:  </b>",data$SOLICITANTE.DEL.ESTUDIO[i])  
  }else{
    tooltip=paste0("<span style='font-family: Fira Sans,sans-serif; font-size: 14px; line-height:2;'>","<center><b style='font-size: 16px;'>",data$SECTOR.AMBIENTAL[i],"</b></center>","<hr style='margin: 0;'>",
                   " <br>","<b>Fecha del Paper: </b>",data$paper_fecha[i])
    
    variables_con_data=variables[which(grepl("/",data[i,variables]))]
    
    for(variable in variables_con_data){
      tooltip=paste0(tooltip,"<br>","<b>",variable,": </b>",data[i,which(names(data)==variable)])
    }
    
    tooltip=paste0(tooltip,  " <br>","<b>Cita: </b>",data$CITA.PAPER[i])
  }
  

  
  datasf$Tooltip[i]=tooltip
 
}

datasf$Lat=data$Lat
datasf$Long=data$Long



datasf$type=NA

datasf$type[grepl("agua",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_superficial"
datasf$type[grepl("pozo",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_pozo"
datasf$type[grepl("superficial",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_superficial"
datasf$type[grepl("lluvia",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_lluvia"
datasf$type[grepl("red",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_red"
datasf$type[grepl("vegetal",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="vegetal"
datasf$type[grepl("sedimento",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="sedimento"
datasf$type[grepl("suelo",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="suelo"
datasf$type[grepl("aire",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="aire"

datasf$type=factor(datasf$type)

datasf=datasf[!is.na(datasf$SECTOR.AMBIENTAL),]

datasf=datasf[,which(names(datasf) %in% c("type","Lat","Long","Tooltip"))]

st_write_parquet(datasf,"./data/ambientales.parquet")


# leaflet(df2_ajustado)%>%addCircleMarkers()%>%addTiles()
# 
# datasf[datasf=="NO DETECTABLE"]=NA
# datasf=datasf[,-which(grepl("DIRECCI|LOCALIDAD",names(datasf)))]
# datasf=datasf[,-which(names(datasf)=="ID")]

# 
# hover=lapply(datasf$Tooltip, htmltools::HTML)
# 
# 
# # Make a list of icons. We'll index into it based on name.
# oceanIcons <- iconList(
#   lluvia = makeIcon("https://www.svgrepo.com/show/485872/rain.svg", iconWidth = 25, iconHeight = 25),
#   agua_corriente = makeIcon("https://svgsilh.com/svg/1295981.svg", iconWidth = 25, iconHeight = 25),
#   vegetal=makeIcon("https://www.svgrepo.com/show/171604/leaf.svg", iconWidth = 25, iconHeight = 25),
#   suelo=makeIcon("https://img.icons8.com/?size=512&id=rVFkCOkaCd03&format=png", iconWidth = 25, iconHeight = 25)
# )
# 
# 
# 
# type = factor(
#   ifelse(runif(20) > 0.75, "pirate", "ship"),
#   c("ship", "pirate")
# )
# 
# 
# datasf$type=NA
# 
# datasf$type[grepl("agua",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="agua_corriente"
# datasf$type[grepl("agua de lluvia",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="lluvia"
# datasf$type[grepl("vegetal",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="vegetal"
# datasf$type[grepl("sedimento|suelo",datasf$SECTOR.AMBIENTAL,ignore.case = T)]="suelo"
# 
# datasf$type=factor(datasf$type)
# 
# datasf=datasf[!is.na(datasf$SECTOR.AMBIENTAL),]
# 
# custom_icon <- makeIcon("https://img.icons8.com/?size=512&id=rVFkCOkaCd03&format=png",iconWidth = 25, iconHeight = 25)
# leaflet() %>%
#   addTiles() %>%
#   addMarkers(lng = -122.4194, lat = 37.7749, icon = custom_icon)
# 
# # leaflet(datasf)%>%addAwesomeMarkers(label=hover,icon=custom_icon)%>%addTiles()
# 
# leaflet(datasf) %>%
#   addTiles() %>%
#   addMarkers(label=hover,icon = ~oceanIcons[type],clusterOptions = markerClusterOptions(spiderfyOnMaxZoom=T,
#                                                                                   removeOutsideVisibleBounds=T))
# 
# write_parquet(df2_ajustado,"./data/puntos.parquet")
# st_write_parquet(honeycomb_count,"./data/hexagonos.parquet")
# 
# 
# library(leaflet)
# data(quakes)
# leaflet(quakes) %>%
#   addTiles() %>%
#   addMarkers(clusterOptions = markerClusterOptions(iconCreateFunction = JS("
#     function(cluster) {
#       return L.divIcon({
#         html: '<b>' + cluster.getChildCount() + '</b>',
#         className: 'mycluster',
#         iconSize: L.point(40, 40)
#       });
#     }
#   ")))
# 
# 
# library(leaflet)
# data(quakes)
# leaflet(quakes) %>%
#   addTiles() %>%
#   addMarkers(clusterOptions = markerClusterOptions(iconCreateFunction = JS("
#     function(cluster) {
#       var childCount = cluster.getChildCount();
#       var radius = 25;
#       return L.divIcon({
#         html: '<div style=\"background-color: red; border-radius: 50%; width: ' + radius + 'px; height: ' + radius + 'px; line-height: ' + radius + 'px; text-align: center; color: white; font-size: 14px;\">' + childCount + '</div>',
#         className: 'mycluster',
#         iconSize: L.point(radius, radius)
#       });
#     }
#   ")))
# 
# library(leaflet)
# data(quakes)
# leaflet(quakes) %>%
#   addTiles() %>%
#   addMarkers(clusterOptions = markerClusterOptions(iconCreateFunction = JS("function(cluster) {
#                   var html = '<div style=\"background-color:rgba(77,77,77,0.5)\"><span>' + cluster.getChildCount() + '</div><span>'
#                   return new L.DivIcon({html: html, className: 'marker-cluster'});
# }")))
# 
# 

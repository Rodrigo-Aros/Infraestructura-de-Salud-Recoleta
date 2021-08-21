# borro memoria -----------------------------------------------------------

rm(list=ls())
graphics.off()

leafem::
# borro librerias ---------------------------------------------------------
library(leafem)
library(leaflet)
library(dplyr)
library(sf)
library(sp)

# cargo puntos Recoleta ---------------------------------------------------
reco<- st_read("C:/Users/Matías/Desktop/Recoleta/Recoleta_shp/Equipamientos_Salud_Recoleta.shp")


# transformo o asigno coordenadas -----------------------------------------

st_crs(reco)$epsg
st_crs(reco)$proj4string
Recoleta<- st_transform(reco, crs = 4326)



# uso leaflet() -----------------------------------------------------------


map1<- leaflet() %>%
  addTiles() %>%
  addProviderTiles(providers$OpenStreetMap) %>%
    addMarkers(data = reco_new, icon = greenLeafIcon, 
    
    
               
               addMiniMap(map1,
    position = "bottomright",
    width = 150,
    height = 150,
    collapsedWidth = 19,
    collapsedHeight = 19,
    zoomLevelOffset = -5)

map1

# vamos a darle la forma de punto al marker -------------------------------

greenLeafIcon <- makeIcon(
  iconUrl = "C:/Users/Matías/Desktop/circle-11.svg",
  iconWidth = 10, iconHeight = 50,
  iconAnchorX = 5, iconAnchorY = 50,
)

# vamos a darle info al pop up --------------------------------------------

pop_test<- paste0("<b>", "Unidad Vecinal: ", "</b>", as.character(Recoleta$UNIDAD_VEC), 
                    "<br>", "<b>", "Centro de Salud: ", "</b>", as.character(Recoleta$NOMBRE), "<br>", 
                    "<b>", "Dirección: ", "</b>", as.character(Recoleta$DIRECCIÓN), "<br>", "<b>", 
                    "Horario: ", "</b>", as.character(Recoleta$HORARIO), "<br>")


# prueba con add ----------------------------------------------------------

mapa2<- leaflet (Recoleta) %>% 
  addProviderTiles(providers$Stamen.TonerLines) %>% 
  leafem::addFeatures(Recoleta, group = "Centros de Salud", popup = pop_test) %>% 
  addCopyExtent(event.code = "KeyD") %>%
  addMouseCoordinates() %>%
  addPolygons(data = JJVV, 
              fill = F, weight = 5, color = "red", group = "Unidad Vecinal") %>%
  addLayersControl(overlayGroups = c("Centros de Salud", "Unidad Vecinal")) %>%
  addMiniMap(mapa2,
           position = "bottomright",
           width = 150,
           height = 150,
           collapsedWidth = 19,
           collapsedHeight = 19,
           zoomLevelOffset = -5) 
  
    


# agrego shape jjvv -------------------------------------------------------

shape_reco<- read_sf("C:/Users/Matías/Desktop/Recoleta/Recoleta_shp/Zonas JJVV.shp")
st_crs(JJVV)$epsg
st_crs(shape_reco)$proj4string
st_transform(shape_reco, crs = 4326) -> JJVV


# agrego detalles ---------------------------------------------------------
mapa3<- garnishMap(mapa2, addScaleBar, addMouseCoordinates, position = "bottomleft")
mapa3


# guardo ------------------------------------------------------------------

htmlwidgets::saveWidget(mapa3, "recoleta.html")

library(shiny)
library(ggplot2)
library(raster)
library(leaflet)
library(rgdal)

pathFile <-  "C:\\Users\\clayt\\Downloads\\Teste\\"

loadRData <- function(fileName) {
  load(fileName)
  get(ls()[ls() != "fileName"])
}

shinyServer(function(input, output) {
  output$mapa <- renderLeaflet({
    file = paste(pathFile, input$tipo_previsao, '.Rda', sep = "")
    
    weatherData <- loadRData(file)
    
    arquivo = paste(pathFile, "trabalho", sep = "")
    shape_br <-
      rgdal::readOGR(arquivo, "estados", GDAL1_integer64_policy = TRUE)
    
    if (input$estado == "BR")
      shape_estado <- shape_br
    else
      shape_estado <- shape_br[shape_br$sigla %in% input$estado, ]
    
    pontos <-
      data.frame(weatherData$LONGITUDE,
                 weatherData$LATITUDE,
                 weatherData[, c(3:length(weatherData[1, ]))])
    colnames(pontos) = c("LONGITUDE", "LATITUDE", c(1:5))
    sp::coordinates(pontos) <- c("LONGITUDE", "LATITUDE")
    sp::proj4string(pontos) <- sp::proj4string(shape_estado)
    new_pontos <-
      weatherData[!is.na(sp::over(pontos, as(shape_estado, "SpatialPolygons"))), ]
    
    tab_raster = raster::rasterFromXYZ(new_pontos)
    r <-
      raster::raster(tab_raster, layer = grep(3, colnames(new_pontos)))
    raster::crs(r) <- sp::CRS("+init=epsg:4326")
    
    graf_options <- switch(
      input$tipo_previsao,
      OCIS = c("white", "yellow", "orange", "red"),
      TP2M = c("blue", "green", "yellow", "orange", "red"),
      PREC = c("Blues"),
      V10M = c("Blues"),
      UR2M = c("red", "orange", "yellow", "green")
    )
    
    pal <-
      leaflet::colorNumeric(
        palette = graf_options,
        raster::values(r),
        na.color = "transparent",
        reverse = TRUE
      )
    pal1 <-
      leaflet::colorNumeric(
        palette = graf_options,
        raster::values(r),
        na.color = "transparent",
        reverse = FALSE
      )
    
    leaflet() %>%
      addTiles(attribution = 'Data source: <a href="https://cptec.inpe.br">CPTEC/INPE</a>') %>%
      addPolygons(
        data = shape_estado,
        color = "black",
        weight = 1,
        fillOpacity = 0
      ) %>%
      addRasterImage(r, colors = pal, opacity = 0.8) %>% addLegend(pal = pal1, values = raster::values(r))
  })
  
})
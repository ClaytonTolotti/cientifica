library(shiny)
library(ggplot2)
library(raster)
library(leaflet)
library(rgdal)

pathFile <-  paste(getwd(), '//', sep = '')

loadRData <- function(fileName) {
  load(fileName)
  get(ls()[ls() != "fileName"])
}

shinyServer(function(input, output) {
  output$mapa <- renderLeaflet({
    
    tipoCarga = 'date'    
    file = paste(pathFile, input$tipo_previsao, '.Rda', sep = "")

    if (input$dias == '0') {
      intervalo <- switch (
        input$date,
        "2018-03-19" = c(3:26),
        "2018-03-20" = c(27:50),
        "2018-03-21" = c(51:74),
        "2018-03-22" = c(75:98),
        "2018-03-23" = c(99:122),
        "2018-03-24" = c(123:146),
        "2018-03-25" = c(147:170),
        "2018-03-26" = c(171:194),
        "2018-03-27" = c(195:218),
        "2018-03-28" = c(219:242),
        "2018-03-29" = c(243:266)
      )
      tipoCarga = 'date'
    } else {
      intervalo <-
        switch (
          input$dias,
          "1" = c(3:26),   #carrega o dia 19
          "2" = c(3:50),   # carrega o dia 19-20
          "3" = c(3:74),   # carrega o dia 19-21
          "4" = c(3:98),   # carrega o dia 19-22
          "5" = c(3:122),  # carrega o dia 19-23
          "6" = c(3:146),  # carrega o dia 19-24
          "7" = c(3:170),  # carrega o dia 19-25
          "8" = c(3:194),  # carrega o dia 19-26
          "9" = c(3:218),  # carrega o dia 19-27
          "10" = c(3:242), # carrega o dia 19-28
          "11" = c(3:266)) # carrega o dia 19-29
        tipoCarga = 'dias'
    }
    weatherData <- loadRData(file)
    
    arquivo = paste(pathFile, "trabalho", sep = "")
    shape_br <-
      rgdal::readOGR(arquivo, "estados", GDAL1_integer64_policy = TRUE)
    
    if (input$estado == "BR")
      shape_estado <- shape_br
    else
      shape_estado <- shape_br[shape_br$sigla %in% input$estado, ]
    
    #Fazer a media pela quantidade de dias selecionados
    media <- rowSums(weatherData[, intervalo]) / (length(intervalo))
    
    pontos <-
      data.frame(weatherData$LONGITUDE,
                 weatherData$LATITUDE,
                 media)
    
    if(tipoCarga == 'dias')
      colnames(pontos) = c("LONGITUDE", "LATITUDE", c(3:intervalo))
    else
      colnames(pontos) = c("LONGITUDE", "LATITUDE", c(intervalo))
    
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
  
  output$grafico <- renderPlot({
    
    
  })
})
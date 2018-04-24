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
    file = paste(pathFile, input$tipo_previsao, '.Rda', sep = "")
  
    if (input$date == "2018-03-19"){ 
      intervalo = c(3:26)
    } else if (input$date == "2018-03-20") {
      intervalo = c(27:50)
    } else if (input$date == "2018-03-21") {
      intervalo = c(51:74)
    } else if (input$date == "2018-03-22") {
      intervalo = c(75:98)
    } else if (input$date ==  "2018-03-23") {
      intervalo = c(99:122)
    } else if (input$date == "2018-03-24") {
      interavalo = c(123:146)
    } else if (input$date == "2018-03-25") {
      intervalo = c(147:170)
    } else if (input$date == "2018-03-26") {
      intervalo = c(171:194)
    } else if (input$date == "2018-03-27") {
      intervalo = c(195:218)
    } else if (input$date == "2018-03-28") {
      intervalo = c(219:242)
    } else if (input$date == "2018-03-29") {
      intervalo = c(243:266)
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
    
    colnames(pontos) = c("LONGITUDE", "LATITUDE", str(intervalo))
    
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
  
  output$graficoTemp <- renderPlot({
    
    file = paste(pathFile, 'TP2M.Rda', sep = "")
    TP2M <- loadRData(file)
    
    D1 <-
      c(
        '2018-03-19' = sum(TP2M[, c(3:26)]) / (length(TP2M[, 3]) * 24),
        '2018-03-20' = sum(TP2M[, c(27:50)]) / (length(TP2M[, 3]) * 24),
        '2018-03-21' = sum(TP2M[, c(51:74)]) / (length(TP2M[, 3]) * 24),
        '2018-03-22' = sum(TP2M[, c(75:98)]) / (length(TP2M[, 3]) * 24),
        '2018-03-23' = sum(TP2M[, c(99:122)]) / (length(TP2M[, 3]) * 24),
        '2018-03-24' = sum(TP2M[, c(123:146)]) / (length(TP2M[, 3]) * 24),
        '2018-03-25' = sum(TP2M[, c(147:170)]) / (length(TP2M[, 3]) * 24),
        '2018-03-26' = sum(TP2M[, c(171:194)]) / (length(TP2M[, 3]) * 24),
        '2018-03-27' = sum(TP2M[, c(195:218)]) / (length(TP2M[, 3]) * 24),
        '2018-03-28' = sum(TP2M[, c(219:242)]) / (length(TP2M[, 3]) * 24),
        '2018-03-29' = sum(TP2M[, c(243:266)]) / (length(TP2M[, 3]) * 24)
      )
    barplot(D1, xlab = 'Dia', ylab = 'Temperatura em Celcius', col = 'green')
  })
})
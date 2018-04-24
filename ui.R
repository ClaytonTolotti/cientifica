library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(
  headerPanel('Dados Meteorologicos'),
  
  sidebarPanel(
    selectInput(
      "estado",
      h3("Estado"),
      choices <- c(
        "Brasil" = "BR",
        "Acre" = "AC",
        "Alagoas" = "AL",
        "Amapa" = "AP",
        "Amazonas" = "AM",
        "Bahia" = "BA",
        "Ceara" = "CE",
        "Distrito Federal" = "DF",
        "Espirito Santo" = "ES",
        "Goias" = "GO",
        "Maranhao" = "MA",
        "Mato Grosso" = "MT",
        "Mato Grosso do Sul" = "MS",
        "Minas Gerais" = "MG",
        "Para" = "PA",
        "Paraiba" = "PB",
        "Parana" = "PR",
        "Pernambuco" = "PE",
        "Piaua" = "PI",
        "Rio de Janeiro" = "RJ",
        "Rio Grande do Norte" = "RN",
        "Rio Grande do Sul" = "RS",
        "Rondonia" = "RO",
        "Roraima" = "RR",
        "Santa Catarina" = "SC",
        "Sao Paulo" = "SP",
        "Sergipe" = "SE"
      )
    ),
    
    hr(),
    
    dateInput(
      "date",
      label = h3("Data: "),
      value = as.Date("2018-03-19"),
      min = as.Date("2018-03-19"),
      max = as.Date("2018-03-29")
    ),
    
    hr(),
    
    selectInput(
      "tipo_previsao",
      h3("Dados"),
      c(
        `Temperatura` = "TP2M",
        `Radiacao Solar` = "OCIS",
        `Precipitacao` = "PREC",
        `Umidade Relativa` = "UR2M",
        `Vento` = "V10M"
      )
    )
  ),
  
  mainPanel(tabsetPanel(
    
    tabPanel(
      'Mapa Meteorologico',
      leafletOutput('mapa', width = "100%", height = "500")
    ),
    
    tabPanel(
      'Grafico Temperatura',
      plotOutput('graficoTemp',width = "100%", height = "500"))
  ))
))
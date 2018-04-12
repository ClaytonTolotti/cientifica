library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(
  headerPanel('Dados Metereologicos'),
  
  sidebarPanel(
    selectInput(
      "estado",
      "Estado",
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
        "Piaui" = "PI",
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
    selectInput("dias",
                "Dias",
                choices <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)),
    selectInput(
      "tipo_previsao",
      "Dados",
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
    tabPanel('Graficos',
             dataTableOutput('PREC')),
    tabPanel(
      'Mapa Metereologicos',
      leafletOutput('mapa', width = "100%", height = "450")
    )
  ))
))
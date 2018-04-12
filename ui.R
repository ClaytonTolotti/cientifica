library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(
  headerPanel('Dados Meteorológicos'),
  
  sidebarPanel(
    selectInput(
      "estado",
      "Estado",
      choices <- c(
        "Brasil" = "BR",
        "Acre" = "AC",
        "Alagoas" = "AL",
        "Amapá" = "AP",
        "Amazonas" = "AM",
        "Bahia" = "BA",
        "Ceará" = "CE",
        "Distrito Federal" = "DF",
        "Espirito Santo" = "ES",
        "Goiás" = "GO",
        "Maranhão" = "MA",
        "Mato Grosso" = "MT",
        "Mato Grosso do Sul" = "MS",
        "Minas Gerais" = "MG",
        "Pará" = "PA",
        "Paraíba" = "PB",
        "Paraná" = "PR",
        "Pernambuco" = "PE",
        "Piauí" = "PI",
        "Rio de Janeiro" = "RJ",
        "Rio Grande do Norte" = "RN",
        "Rio Grande do Sul" = "RS",
        "Rondônia" = "RO",
        "Rorâima" = "RR",
        "Santa Catarina" = "SC",
        "São Paulo" = "SP",
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
    tabPanel('Gráficos',
             dataTableOutput('PREC')),
    tabPanel(
      'Mapa Meteorológico',
      leafletOutput('mapa', width = "100%", height = "450")
    )
  ))
))
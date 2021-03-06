
# Preprocesado de la aplicacion
library(shiny)
library(shinythemes)
library(rjson)
library(RSocrata)
library(BatchGetSymbols)
library(plotly)
library(dplyr)

#Lectura de los datos y procesamiento

TRM2 <- read.socrata("https://www.datos.gov.co/resource/ceyp-9c7c.csv")
oil2 = read.csv("https://datasource.kapsarc.org/explore/dataset/opec-crude-oil-price/download/?format=csv&timezone=America/Bogota&lang=en&use_labels_for_header=true&csv_separator=%3B" ,
               sep = ";")
oil <- oil2
TRM <- TRM2
oil$Date <- as.POSIXct(oil$Date, format = "%Y-%m-%d")
TRM <-  TRM[order(as.Date(TRM$vigenciadesde, format="%Y-%m-%d")),]
oil <-  oil[order(as.Date(oil$Date, format = "%Y-%m-%d")),]
oil <-  oil[oil$Date >= '2008-01-01',]
TRM <-  TRM[TRM$vigenciadesde >= '2008-01-01',]
copvsoil <- merge(x = TRM , y = oil , by.x = "vigenciadesde" , by.y = "Date", all = FALSE )
copvsoil$año <- format(copvsoil$vigenciadesde , format = "%Y")
copvsoil$mes <- format(copvsoil$vigenciadesde , format = "%Y-%m")
copvsoil$mesnum <- format(copvsoil$vigenciadesde , format = "%m")

# Generamos la tabla que va a aparecer en el tablero con los datos maximo minimo y promedio

tabla <- copvsoil  %>% select(año,valor) %>% group_by(año) %>% summarise(minimo = min(valor), maximo = max(valor), Promedio = mean(valor))


first.date <- "2017-01-01"
last.date <- Sys.Date()
#df.SP500 <- GetSP500Stocks()
#tickers <- df.SP500$Tickers
tickers <- c('FB','MMM','APD','GOOGL','ALGN','AFL')


out <- BatchGetSymbols(tickers = tickers,
                       first.date = first.date,
                       last.date = last.date)

out2 <- out

financial_data <- as.data.frame(out2$df.tickers)

financial_data$año <-  format(financial_data$ref.date , format = "%Y")


# Diseñamos el panel de la interfaz grafica del usuario 

#La pagina fué creado de forma fluid page con dos viñetas parte uno y parte dos para dar respuestas a las dos
#primeras partes de la prueba el tema elegido es “cerulean” y se trabajó una malla de tal forma que pudieramos
#obtener el fluidRow divido en dos grandes renglones de ubicamos 2 y 3 plot respectivamente .
#En la parte superior ubicamos los respectivos inputs del modelo Indicador(petroleo,TRM), Año y mes

ui <- shinyUI(fluidPage(theme = shinytheme("cerulean"),

        titlePanel("PRUEBA ANALISTA DE INVERSIONES SURA"),
        
        navbarPage("Respuestas: ",
                   tabPanel("Parte 1",

  fluidPage(
    fluidRow(
   
    
    # Input: Selector de la variable a visualizar
    column(4,
    selectInput("var","Seleccionar precios: ",
                choices = c("Petroleo"= "Crude.Oil.Price",
                             "TRM" = "valor"
                             ))),
    # Input 2:  Chekbok 
    column(4,
    selectInput("year","Año: ",
                choices = c("2020"= "2020",
                            "2019" = "2019",
                            "2018" = "2018",
                            "2017" = "2017",
                            "2016" = "2016",
                            "2015" = "2015",
                            "2014" = "2014",
                            "2013" = "2013",
                            "2012" = "2012",
                            "2011" = "2011",
                            "2010" = "2010",
                            "2009" = "2009",
                            "2008" = "2008"
                ))),
    
    column(4,
    
    selectInput("mounth","Mes: ",
                choices = c("Enero"= "01",
                            "Febrero" = "02",
                            "Marzo" = "03",
                            "Abril" = "04",
                            "Mayo " = "05",
                            "Junio" = "06",
                            "Julio" = "07",
                            "Agosto" = "08",
                            "Septiembre" = "09",
                            "Octubre" = "10",
                            "Noviembre" = "11",
                            "Diciembre" = "12"
                            
                )))
    
) ),
  
  # Visualizacion de resultados
  mainPanel(
    # Output 1: Texto de la formula
    
    
    
    # Output 2 : Plot de la variable de salida
    fluidRow(
   
      column(6,
    
            h5(textOutput("frase")),
            plotlyOutput("mpgPlot")),
    
      column(6,
             plotlyOutput("box"))),
    fluidRow( 
      column(4,
    
    plotlyOutput("mes")),
    
    column(4,
           
    h3(textOutput("correl")),
    plotlyOutput("correlacion")),
    
    column(4,
    
    tableOutput('table'))),
    
    width = 100

  )
),

tabPanel("Parte 2",
fluidPage(
  column(4,
         selectInput("accion","Seleccione una acción: ",
                     choices = c("FB"= "FB",
                                  "MMM" = "MMM",
                                  "APD" = "APD",
                                  "GOOGL"= "GOOGL" ,
                                  "ALGN"= "ALGN",
                                   "AFL"=  "AFL" ))),
  # Input 2:  Chekbok 
  column(4,
         selectInput("yearx","Año: ",
                     choices = c("2020"= "2020",
                                 "2019" = "2019",
                                 "2018" = "2018",
                                 "2017" = "2017",
                                 "2016" = "2016",
                                 "2015" = "2015",
                                 "2014" = "2014",
                                 "2013" = "2013"
                    
                )))
  
  
),

mainPanel(
  # Output 1: Texto de la formula
  
  
  
  # Output 2 : Plot de la variable de salida
  fluidRow(
    
    column(6,
           
           h4(textOutput("tselect")),
           plotlyOutput("finanza")),
    
    column(6,
           
           h4("Volumen"),
           plotlyOutput("finanza2"))),

  
  width = 100 )

)
)))

# Logica del servidor

#En este paso configuramos todos nuestros input reactivos configuramos 
#nuestras graficas con la libreria

server <- function(input,output){
  
  # Calcular el texto de la formula
  # Es una expresion reactiva
  
  acselect <- reactive({
    paste("Precios de cierre por año de la accion  ", input$accion)
    
  })
  
 
  formulaTexto <- reactive({
    paste("Fecha vs ", input$var)
    
  })
  
 
  
  output$frase <- renderText({
    
    formulaTexto()
    
})  
  
 
output$tselect   <- renderText({
  
  acselect()
  
})  
  
 copvsoil2 <- reactive({
   copvsoil[copvsoil$año == input$year,]
  
}
   
)
  
 copvsoil3 <- reactive({
   copvsoil2()[copvsoil2()$mesnum == input$mounth,]
   
 })
 
 bolsa <- reactive({
   financial_data[(financial_data$ticker == input$accion) & (financial_data$año == input$yearx),]
   
 }
 
 )

  
    seleccion2 <- reactive({
    copvsoil2()[,input$var]})
  
  
    seleccion <- reactive({
    copvsoil[,input$var]})
  
    seleccion3 <- reactive({
    copvsoil3()[,input$var]})
    
    
  
  
  
  
  #Generacion del grafico
  
  output$mpgPlot <- renderPlotly({
    plot_ly(copvsoil,
            x = copvsoil$vigenciadesde,
            y = seleccion(), type = 'scatter', mode = 'lines')
  }
)
  
  
  corx <-  reactive({
    paste("La Correlacion entre la TRM y el Petroleo para el año seleccionado es  ", round(cor(copvsoil2()$Crude.Oil.Price,copvsoil2()$valor),2))
     
    
    
  })
  
  output$correl  <- renderText({
    
    corx()
    
  })  
  
  
  # Grafico de boxplox
  
  output$box <- renderPlotly({
    plot_ly(copvsoil2(), y = seleccion2(), x = copvsoil2()$mes, type = "box",color="red")
  
  }
)
  



output$mes <- renderPlotly({
  plot_ly(copvsoil3(), y = seleccion3(), x = copvsoil3()$vigenciadesde, type = 'scatter', mode = 'lines')
  
}
)


output$correlacion <- renderPlotly({
  plot_ly(data = copvsoil2(), x = copvsoil2()$valor, y = copvsoil2()$Crude.Oil.Price ) } )




output$finanza <- renderPlotly({
  plot_ly(bolsa(), y = bolsa()$price.close  , x = bolsa()$ref.date , type = 'scatter', mode = 'lines')
  
}
)

output$finanza2 <- renderPlotly({
  plot_ly(bolsa(), y = bolsa()$volume  , x = bolsa()$ref.date , type = 'scatter', mode = 'lines' , color = "Red")
  
}
)

output$table <- renderTable(tabla)
  
}
# Unir las dos partes y lanzar la aplicacion

shinyApp(ui = ui , server = server)






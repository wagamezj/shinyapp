install.packages("shinythemes")
install.packages("rjson")
install.packages("RSocrata")
install.packages("BatchGetSymbols")
install.packages("ploty")



# Preprocesado de la aplicacion
library(shiny)
library(shinythemes)
library(rjson)
library(RSocrata)
library(BatchGetSymbols)
library(plotly)



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
ac <- "Acciones"

first.date <- "2017-01-01"
last.date <- Sys.Date()
#df.SP500 <- GetSP500Stocks()
#tickers <- df.SP500$Tickers
tickers <- c('FB','MMM','APD','GOOGL','ALGN','AFL')


#out <- BatchGetSymbols(tickers = tickers,
                      # first.date = first.date,
                       #last.date = last.date)

out2 <- out

financial_data <- as.data.frame(out2$df.tickers)




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
                            "2019" = "2019"
                ))),
    
    column(4,
    
    selectInput("mounth","Mes: ",
                choices = c("Enero"= "01",
                            "Febrero" = "02"
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
      column(6,
    
    plotlyOutput("mes")),
    
    column(6,
    
    plotlyOutput("correlacion"))),
    
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
         selectInput("year","Año: ",
                     choices = c("2020"= "2020",
                                 "2019" = "2019"
                     )))
  
  
),

mainPanel(
  # Output 1: Texto de la formula
  
  
  
  # Output 2 : Plot de la variable de salida
  fluidRow(
    
    column(12,
           
           h5(ac),
           plotlyOutput("finanza")),

  
  width = 100
  
))

)
)))

# Logica del servidor

server <- function(input,output){
  # Calcular el texto de la formula
  # Es una expresion reactiva
  
  
  formulaTexto <- reactive({
    paste("Fecha vs ", input$var)
    
  })
  
  # Titulo del grafico es la variable de outputtexto
  
  output$frase <- renderText({
    
    formulaTexto()
    
})  
  
 

  
 copvsoil2 <- reactive({
   copvsoil[copvsoil$año == input$year,]
  
}
   
)
  
 copvsoil3 <- reactive({
   copvsoil2()[copvsoil2()$mesnum == input$mounth,]
   
 })
 
 bolsa <- reactive({
   financial_data[financial_data$ticker == input$accion,]
   
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
  plot_ly(data = copvsoil, x = copvsoil$valor, y = copvsoil$Crude.Oil.Price ) } )




output$finanza <- renderPlotly({
  plot_ly(bolsa(), y = bolsa()$price.close  , x = bolsa()$ref.date , type = 'scatter', mode = 'lines')
  
}
)

  
}
# Unir las dos partes y lanzar la aplicacion

shinyApp(ui = ui , server = server)






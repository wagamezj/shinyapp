
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
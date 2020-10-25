
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






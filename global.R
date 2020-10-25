#install.packages("shinythemes")
#install.packages("rjson")
#install.packages("RSocrata")
#install.packages("BatchGetSymbols")
#install.packages("ploty")



# Preprocesado de la aplicacion
library(shiny)
library(shinythemes)
library(rjson)
#library(RSocrata)
library(BatchGetSymbols)
library(plotly)


#TRM2 <- read.socrata("https://www.datos.gov.co/resource/ceyp-9c7c.csv")

TRM2 <- read.csv('~/TRM2.csv')

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
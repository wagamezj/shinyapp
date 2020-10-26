library(readr)
library(dplyr)
library(stringr)
library(zoo)


BASE <- read_delim("clase_shiny/BASE.txt", 
                   ";", escape_double = FALSE, col_types = cols(Fecha = col_date(format = "%d/%m/%Y")), 
                   trim_ws = TRUE)

# A

subtotal_USD <- BASE[BASE$Moneda == 'USD',] %>% select(Empresa,Moneda,Ingreso) %>% group_by(Empresa,Moneda) %>% summarise(total = sum(Ingreso))


#B

total_empresaa <- BASE[BASE$Empresa == 'Empresa A',] %>% select(Empresa,Moneda,Ingreso) %>% group_by(Empresa,Moneda) %>% summarise(total = sum(Ingreso))

#C

BASE$Empresa = str_replace_all(BASE$Empresa ,"EmpresaC","Empresa C")
menor_ingreso <- BASE[(BASE$Fecha>='2017-01-01') & (BASE$Fecha<='2017-06-30') & (BASE$Moneda == 'PESO'),] %>% group_by(Empresa,Moneda) %>% summarise(total = sum(Ingreso))


#D

BASE$Trim <- as.yearqtr(BASE$Fecha, format = "%Y-%m-%d")

Trimestre <- BASE[BASE$Moneda == 'PESO',] %>%  select(Trim,Empresa,Moneda,Ingreso) %>% group_by(Trim,Empresa,Moneda) %>% summarise(total = sum(Ingreso))

#E

total_emp_moneda <- BASE  %>% select(Empresa,Moneda,Ingreso) %>% group_by(Empresa,Moneda )%>% summarise(total = sum(Ingreso))




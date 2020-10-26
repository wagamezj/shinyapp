/*
3- Muestre el nombre del último o los últimos productos que se hayan vendido.
*/


SELECT TOP 2
            D.Codigo,
			P.Nombre
			FROM user_stage.wilmagju_Pedido D
			LEFT JOIN user_stage.wilmagju_Producto P ON D.Codigo = P.Codigo
			ORDER BY D.Fecha DESC 
			
			
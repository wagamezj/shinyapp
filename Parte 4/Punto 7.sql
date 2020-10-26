/*
7- Muestre todos los datos de los productos que son más baratos que un 'Portátil' y más caros que un 'Lapicero'
*/

SELECT P.Nombre,
	   P.Precio
	  FROM user_stage.wilmagju_Producto P 
	  WHERE P.Precio > (SELECT Precio FROM user_stage.wilmagju_Producto WHERE Nombre = 'Lapicero')
		AND P.Precio < (SELECT Precio FROM user_stage.wilmagju_Producto WHERE Nombre = 'Portatil')
	  
	  

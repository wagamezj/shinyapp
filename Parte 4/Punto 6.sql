/*
6- Muestre todos los datos de las personas que son de 'Cali' y han hecho compras superiores a 1 millón de pesos.
*/


SELECT 
A.Nombre,
A.Ciudad,
Sum(B.Cantidad*B.Precio) AS venta

FROM  user_stage.wilmagju_cliente A
RIGHT JOIN 
(SELECT 
            D.Cedula,
			D.Codigo,
			P.Nombre,
			D.Cantidad,
			P.Precio
			FROM user_stage.wilmagju_Pedido D
			LEFT JOIN user_stage.wilmagju_Producto P ON D.Codigo = P.Codigo) B ON A.cedula = B.Cedula
			
  WHERE A.Ciudad = 'Cali'
  HAVING venta >= 1000000
  GROUP BY 1,2
			
			


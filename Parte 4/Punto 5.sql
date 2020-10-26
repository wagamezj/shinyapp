SELECT 
A.Fecha,
Sum(A.Cantidad*B.Precio) Venta
FROM user_stage.wilmagju_Pedido A
LEFT JOIN user_stage.wilmagju_Producto B ON A.Codigo = B.Codigo
GROUP BY A.Fecha
ORDER BY A.Fecha ASC



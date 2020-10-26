/*
8- Muestre todos los datos de los clientes que no han comprado ningún producto.
*/

SELECT 
A.Nombre,
Sum (B.Cantidad) Cantidad
FROM user_stage.wilmagju_cliente A 
LEFT JOIN user_stage.wilmagju_Pedido B ON   A.Cedula = B.Cedula
WHERE B.Cantidad IS NULL
GROUP BY 1

/*
4- Muestre el nombre del último o los últimos productos que se hayan vendido.
*/


SELECT
A.Nombre,
Sum(B.Cantidad) AS cantidad
FROM user_stage.wilmagju_cliente A
RIGHT JOIN user_stage.wilmagju_Pedido B ON A.Cedula = B.Cedula
GROUP BY A.Nombre
ORDER BY Sum(B.Cantidad) DESC




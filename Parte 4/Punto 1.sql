SELECT
A.Nombre,
C.Nombre
FROM user_stage.wilmagju_cliente A
RIGHT JOIN (SELECT 
            D.Cedula,
			D.Codigo,
			P.Nombre,
			FROM user_stage.wilmagju_Pedido D
			LEFT JOIN user_stage.wilmagju_Producto P ON D.Codigo = P.Codigo) C ON A.Cedula = C.Cedula



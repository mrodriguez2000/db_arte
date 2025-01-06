-- Active: 1727036930520@@127.0.0.1@5432@db_arte@public
SELECT v.fecha_venta, c.nombre_cliente, pa.nombre_pieza FROM cliente c 
INNER JOIN venta v ON v.id_cliente = c.id_cliente
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
INNER JOIN pieza_arte pa ON dv.id_pieza = pa.id_pieza
ORDER BY v.fecha_venta;



SELECT ta.nombre_arte, COUNT(pa.id_arte) AS cantidad FROM tipo_arte ta 
INNER JOIN pieza_arte pa ON ta.id_arte = pa.id_arte
GROUP BY ta.nombre_arte
ORDER BY cantidad DESC;


SELECT v.fecha_venta, c.nombre_cliente, pa.id_pieza, pa.nombre_pieza, dv.cantidad FROM venta v
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
INNER JOIN cliente c ON c.id_cliente = v.id_cliente
INNER JOIN pieza_arte pa ON pa.id_pieza = dv.id_pieza
ORDER BY v.fecha_venta;


SELECT a.nombre_artista, COUNT(pa.id_artista) AS cantidad_pieza_arte FROM artista a 
INNER JOIN pieza_arte pa ON pa.id_artista = a.id_artista
GROUP BY a.nombre_artista
ORDER BY cantidad_pieza_arte DESC;
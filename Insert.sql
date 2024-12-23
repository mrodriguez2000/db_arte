-- Active: 1727036930520@@127.0.0.1@5432@db_arte@public
-- Insertando los tipos de arte
INSERT INTO tipo_arte
(nombre_arte)
VALUES
('Pintura'), ('Escultura'), ('Fotografia'), ('Litografía');

-- Insertando categorias de piezas
INSERT INTO categoria
(nombre_categoria)
VALUES
('Personas'), ('Paisajes'), ('Bodegones'), ('Cultura'), ('Vídeo juegos');

-- Insertando artistas
INSERT INTO artista -- En este caso no se va a ingresar la edad porque se crea un trigger que calcula la edad y la actualiza después de insertar uno o varios artistas
(nombre_artista, fecha_nacimiento_artista)
VALUES
('Zorvenia', '1991-12-30'),
('Aaron Tailow', '1995-01-01'),
('Nyxora', '2000-04-21'),
('Oliver', '1982-08-10'),
('Rosendo', '1990-10-09'),
('Arnold', '1992-05-10');

INSERT INTO cliente
(nombre_cliente, direccion_cliente)
VALUES
('Gonzalo', 'Barranquilla'),
('Armano', 'Santa Marta'),
('Andrés', 'Santa Marta'),
('Maria', 'Bucaramanga'),
('Laura', 'Barrancabermeja'),
('Lorena', 'Bogotá'),
('Melissa', 'Bogotá'),
('Sofia', 'Bogotá');

INSERT INTO pieza_arte
(id_artista, id_arte, fecha_lanzamiento, nombre_pieza, precio_venta)
VALUES
(1, 1, '2011-12-30', 'Artes', 1000000);

INSERT INTO venta
(id_pieza, id_cliente, fecha_venta, cantidad_comprada)
VALUES
(1, 1, '2012-01-05', 3);

INSERT INTO venta
(id_pieza, id_cliente, fecha_venta, cantidad_comprada)
VALUES
(1, 2, '2012-01-06', 2),
(1, 3, '2012-01-06', 3);


SELECT c.nombre_cliente, pa.nombre_pieza, v.cantidad_comprada FROM cliente c 
INNER JOIN venta v ON v.id_cliente = c.id_cliente
INNER JOIN pieza_arte pa ON pa.id_pieza = v.id_pieza
ORDER BY v.cantidad_comprada DESC;
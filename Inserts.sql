-- Active: 1727036930520@@127.0.0.1@5432@db_arte@public
-- Insercion de artistas con nombres reales
INSERT INTO artista (nombre_artista, fecha_nacimiento_artista) 
VALUES
    ('Banksy', '1980-07-01'),
    ('Keith Haring', '1970-05-04'),
    ('Jean-Michel Basquiat', '1975-12-22'),
    ('Frida Kahlo', '1985-07-06'),
    ('Georgia O''Keeffe', '1977-11-15'),
    ('Yayoi Kusama', '1965-03-22');

-- Insercion de clientes con nombres propios
INSERT INTO cliente (nombre_cliente, direccion_cliente) 
VALUES
    ('Carlos Pérez', 'Calle Luna 123'),
    ('María Gómez', 'Av. Sol 456'),
    ('Juan Torres', 'Calle Estrella 789'),
    ('Ana Fernández', 'Av. Mar 101'),
    ('Luis Ramírez', 'Calle Cielo 234'),
    ('Laura Herrera', 'Plaza Nube 567'),
    ('David Castro', 'Calle Río 890'),
    ('Isabel Díaz', 'Av. Lago 321'),
    ('Pedro Molina', 'Calle Bosque 654'),
    ('Miguel Ruiz', 'Av. Rayo 357');

-- Insercion de tipos de arte
INSERT INTO tipo_arte (nombre_arte) VALUES
    ('Pintura'), ('Escultura'), ('Fotografia'), ('Ceramica'), ('Dibujo');

-- Inserción de categorias
INSERT INTO categoria (nombre_categoria) VALUES
    ('Personas'), ('Paisajes'), ('Naturaleza'), ('Poema'), ('Romance'), ('Comedia');

-- Insercion de piezas de arte
INSERT INTO pieza_arte (id_artista, id_arte, fecha_lanzamiento, nombre_pieza, precio_venta) 
VALUES
    (1, 3, '1996-03-10', 'La belleza de nuestro planeta', 250000),
    (1, 4, '1996-05-09', 'El Secreto de la Montaña', 100000),
    (2, 5, '1992-01-20', 'Lluvia en el Valle', 230000),
    (2, 1, '1993-05-10', 'El Guardián del Bosque', 320000),
    (3, 5, '1992-05-22', 'El Latido de la Tierra', 300000),
    (3, 5, '1992-11-06', 'Lágrimas de Luna', 350000),
    (4, 2, '2000-10-09', 'Almas Gemelas', 500000),
    (4, 3, '2001-02-21', 'Espiral de Emociones', 400000),
    (5, 4, '1992-05-10', 'Recuerdos de Invierno', 460000),
    (5, 1, '1992-10-10', 'El Arte del Silencio', 200000),
    (6, 5, '1985-06-15', 'El Cuadro Travieso', 192000),
    (6, 3, '1985-06-30', 'Reflejo en el Lago', 200000);

INSERT INTO categoria_pieza (id_pieza, id_categoria) VALUES
    (1, 2), (1, 3), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3), (4, 4), (4, 6),
    (5, 4), (6, 4), (6, 5), (7, 5), (7, 6), (8, 1), (8, 4), (9, 1), (9, 4), (9, 5),
    (10, 3), (10, 5), (11, 1), (11, 6), (12, 1), (12, 2), (12, 3);

INSERT INTO venta (id_cliente, fecha_venta) VALUES
    (1, '1993-05-20'),
    (2, '1996-09-12'),
    (3, '1993-05-21'),
    (4, '1986-09-12'),
    (5, '1986-09-12'),
    (6, '1995-02-10'),
    (7, '1995-06-10'),
    (8, '1996-06-12'),
    (9, '1996-06-12'),
    (10, '1996-06-12'),
    (6, '2000-11-30'),
    (9, '2000-11-30'),
    (10, '2000-12-10'),
    (1, '2001-03-02'),
    (3, '2001-03-05');


INSERT INTO detalle_venta (id_venta, id_pieza, cantidad) VALUES
    (1, 3, 1),
    (1, 6, 1),
    (2, 1, 2),
    (3, 3, 2),
    (3, 10, 1),
    (4, 11, 2),
    (5, 12, 2),
    (5, 11, 1),
    (6, 11, 2),
    (6, 12, 2),
    (7, 3, 2),
    (7, 9, 1),
    (8, 12, 1),
    (9, 4, 2),
    (9, 6, 2),
    (10, 1, 3),
    (10, 6, 2),
    (11, 7, 3),
    (11, 3, 1),
    (12, 7, 2),
    (12, 1, 1),
    (13, 7, 1),
    (13, 5, 2),
    (14, 8, 2),
    (15, 7, 2),
    (15, 1, 1);
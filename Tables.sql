-- Active: 1727036930520@@127.0.0.1@5432@db_arte@public
-- Tabla artista 
CREATE TABLE artista(
    ID_Artista SERIAL PRIMARY KEY, -- El tipo de dato SERIAL permite que cada vez que se inserte un nuevo registro el ID_Artista autoincrementará de uno en uno 
    Nombre_Artista VARCHAR(50) NOT NULL,
    Fecha_Nacimiento_Artista DATE NOT NULL,
    Edad_Artista INT
);
-- Tabla tipo de arte
CREATE TABLE tipo_arte(
    ID_Arte SERIAL PRIMARY KEY,
    Nombre_Arte VARCHAR(30) NOT NULL
);
-- tabla de clientes
CREATE TABLE cliente(
    ID_Cliente SERIAL PRIMARY KEY,
    Nombre_Cliente VARCHAR(50) NOT NULL,
    Direccion_Cliente VARCHAR(50),
    Dinero_Invertido INT,
    Cantidad_Compras INT DEFAULT 0
);
-- tabla de categorias
CREATE TABLE categoria(
    ID_Categoria SERIAL PRIMARY KEY,
    Nombre_Categoria VARCHAR(30) NOT NULL
);
-- tabla de pieza de arte
CREATE TABLE pieza_arte(
    ID_Pieza SERIAL PRIMARY KEY,
    ID_Artista INT NOT NULL,
    ID_Arte INT NOT NULL,
    Fecha_Lanzamiento DATE NOT NULL,
    Nombre_Pieza VARCHAR(50) NOT NULL UNIQUE,
    Precio_Venta INT NOT NULL,
    -- Añadir claves foraneas
    CONSTRAINT FK_ARTISTA FOREIGN KEY(ID_Artista) REFERENCES artista(ID_Artista)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    /* las últimas lineas on delete y on update cascade funcionan para modificar o 
    eliminar registros de la clave foranea de la tabla pieza_arte en caso de que algún elemento 
    de la clave primaria ID_Artista sea eliminado o modificado en la tabla */
    CONSTRAINT FK_ARTE FOREIGN KEY(ID_Arte) REFERENCES tipo_arte(ID_Arte)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Tabla de categorias de pieza de arte
CREATE TABLE categoria_pieza(
    ID_Categoria_Pieza SERIAL PRIMARY KEY,
    ID_Pieza INT NOT NULL,
    ID_Categoria INT NOT NULL,
    CONSTRAINT FK_PIEZA FOREIGN KEY(ID_Pieza) REFERENCES pieza_arte(ID_Pieza)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_CATEGORIA_PIEZA FOREIGN KEY(ID_Categoria) REFERENCES categoria(ID_Categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Tabla de ventas
CREATE TABLE venta(
    ID_Venta SERIAL PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Fecha_Venta DATE NOT NULL,
    CONSTRAINT FK_CLIENTE FOREIGN KEY(ID_Cliente) REFERENCES cliente(ID_Cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Tabla de detalle de ventas
CREATE TABLE detalle_venta(
    ID_Detalle SERIAL PRIMARY KEY,
    ID_Venta INT NOT NULL,
    ID_Pieza INT NOT NULL,
    Cantidad INT NOT NULL CHECK(Cantidad > 0),
    CONSTRAINT FK_VENTA FOREIGN KEY(ID_Venta) REFERENCES venta(ID_Venta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_PIEZA_VENDIDA FOREIGN KEY(ID_Pieza) REFERENCES pieza_arte(ID_Pieza)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
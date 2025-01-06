-- Active: 1727036930520@@127.0.0.1@5432@db_arte@public
/* Función que calcula la edad de un artista */
CREATE OR REPLACE FUNCTION retorna_edad_Artista() RETURNS TRIGGER AS
$$
    -- Iniciamos creando una variable llamada Artista_Edad y asignamos el tipo de dato correcto
    DECLARE
        Artista_Edad INT;
    BEGIN
    /* En el siguiente código usaremos una función EXTRACT para extraer el año de una operación que calcula 
    la diferencia entre la fecha actual y la fecha de nacimiento de un artista, posteriormente esa operación 
    se le va asignar a la variable que fue creada anteriormente mediante el comando INTO*/
        SELECT EXTRACT(YEAR FROM AGE(NOW(), NEW.fecha_nacimiento_artista)) INTO Artista_Edad FROM artista;
    /* Una vez asignado el valor a la variable se crea la operación a ejecutar, en este caso
    se va implementar un update sobre la columna edad_artista, ya que esa variable permite valores nulos*/    
        UPDATE artista SET edad_artista = Artista_Edad WHERE NEW.id_artista = id_artista;

        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

/* Posteriormente se crea el trigger que va a insertar la función que fue creada anteriormente mediante el
   la función AFTER INSERT que indica que el trigger se va a ejecutar después de insertar algunos registros 
   en la tabla de artistas*/
CREATE OR REPLACE TRIGGER edad_artista AFTER INSERT ON artista FOR EACH ROW
EXECUTE PROCEDURE retorna_edad_Artista();

-- Función que calcula el número de veces que un cliente realiza una compra y el valor de la compra
CREATE OR REPLACE FUNCTION contar_compras() RETURNS TRIGGER AS
$$
DECLARE
    cantidad_compras_cliente INT;
BEGIN
    SELECT COUNT(v.id_cliente) INTO cantidad_compras_cliente FROM venta v 
    INNER JOIN cliente c ON c.id_cliente = v.id_cliente WHERE v.id_cliente = NEW.id_cliente;

    UPDATE cliente SET cantidad_compras = cantidad_compras_cliente WHERE id_cliente = NEW.id_cliente;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER contar_compras AFTER INSERT ON venta FOR EACH ROW
EXECUTE PROCEDURE contar_compras();


-- Función que calcula el dinero invertido en una compra por cliente

CREATE OR REPLACE FUNCTION calcular_valor_invertido() RETURNS TRIGGER AS
$$
DECLARE
    Valor_Invertido_Cliente INT;
BEGIN
    -- Obtener el cliente asociado a la venta desde detalle_venta
    SELECT c.dinero_invertido 
    INTO Valor_Invertido_Cliente
    FROM cliente c
    JOIN venta v ON c.id_cliente = v.id_cliente
    WHERE v.id_venta = NEW.id_venta;

    -- Sumar el valor de la pieza comprada al cliente
    UPDATE cliente
    SET dinero_invertido = COALESCE(dinero_invertido, 0) + (
        SELECT (pa.precio_venta * NEW.cantidad)
        FROM pieza_arte pa
        WHERE pa.id_pieza = NEW.id_pieza
    )
    WHERE id_cliente = (
        SELECT v.id_cliente
        FROM venta v
        WHERE v.id_venta = NEW.id_venta
    );

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER valor_invertido AFTER INSERT ON detalle_venta FOR EACH ROW
EXECUTE PROCEDURE calcular_valor_invertido();





-- Función que evita que una fecha de venta sea menor a la fecha de lanzamiento de la pieza de arte

CREATE OR REPLACE FUNCTION comprueba_fecha_venta() RETURNS TRIGGER AS
$$
DECLARE
    Fecha_Venta_Arte DATE;
    Fecha_De_Lanzamiento DATE;
BEGIN    
    -- Obtener la fecha de venta directamente del nuevo registro
    SELECT fecha_venta INTO Fecha_Venta_Arte 
    FROM venta 
    WHERE id_venta = NEW.id_venta;
    
    -- Obtener la fecha de lanzamiento de la pieza
    SELECT fecha_lanzamiento INTO Fecha_De_Lanzamiento 
    FROM pieza_arte 
    WHERE id_pieza = NEW.id_pieza;

    -- Validar que la venta no sea anterior o igual al lanzamiento
    IF Fecha_Venta_Arte <= Fecha_De_Lanzamiento THEN
        RAISE EXCEPTION 'No es posible añadir una fecha de venta menor o igual que la 
        fecha de lanzamiento de la pieza de arte.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

-- Crear el trigger
CREATE OR REPLACE TRIGGER fecha_de_venta BEFORE INSERT OR UPDATE ON detalle_venta FOR EACH ROW
EXECUTE FUNCTION comprueba_fecha_venta();

-- Función que evita que una fecha de lanzamiento sea menor a la fecha de nacimiento del artista

CREATE OR REPLACE FUNCTION comprueba_fecha_nacimiento() RETURNS TRIGGER AS
$$
DECLARE
    Fecha_Nacimiento_Del_Artista DATE;
    Fecha_Lanzamiento_Arte DATE;
BEGIN    
    -- Asignando valor a las variables
    SELECT a.fecha_nacimiento_artista INTO Fecha_Nacimiento_Del_Artista FROM artista a WHERE id_artista = NEW.id_artista;

    SELECT fecha_lanzamiento INTO Fecha_Lanzamiento_Arte FROM pieza_arte WHERE id_pieza = NEW.id_pieza;

    -- Se programa una excepción en caso de que la fecha de lanzamiento de una pieza de arte sea menor o igual que la fecha de nacimiento del artistaa
    IF Fecha_Lanzamiento_Arte <= Fecha_Nacimiento_Del_Artista THEN
        RAISE EXCEPTION 'No es posible añadir una fecha de lanzamiento menor o igual que la fecha de nacimiento del artista.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER fecha_de_nacimiento AFTER INSERT ON pieza_arte FOR EACH ROW
EXECUTE PROCEDURE comprueba_fecha_nacimiento();
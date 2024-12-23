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
    cantidad INT;
    valor_invertido INT;
BEGIN
    SELECT COUNT(*) INTO cantidad FROM venta v INNER JOIN cliente c ON
    c.id_cliente = v.id_cliente WHERE v.id_cliente = NEW.id_cliente;

    SELECT pa.precio_venta * v.cantidad_comprada INTO valor_invertido FROM pieza_arte pa INNER JOIN venta v
    ON v.id_pieza = pa.id_pieza INNER JOIN cliente c ON c.id_cliente = v.id_cliente WHERE NEW.id_pieza = pa.id_pieza;

    UPDATE cliente SET cantidad_compras = cantidad WHERE id_cliente = NEW.id_cliente;

    UPDATE cliente SET dinero_invertido = valor_invertido WHERE id_cliente = NEW.id_cliente;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER contar_compras AFTER INSERT ON venta FOR EACH ROW
EXECUTE PROCEDURE contar_compras();

-- Función que evita que una fecha de lanzamiento sea menor a la fecha de nacimiento del artista

CREATE OR REPLACE FUNCTION comprueba_fecha_nacimiento() RETURNS TRIGGER AS
$$
DECLARE
    Fecha_Nacimiento_Del_Artista DATE;
    Fecha_Lanzamiento_Arte DATE;
BEGIN    
    -- Asignando valor a las variables
    SELECT fecha_nacimiento_artista INTO Fecha_Nacimiento_Del_Artista FROM artista WHERE id_artista = NEW.id_artista;

    SELECT fecha_lanzamiento INTO Fecha_Lanzamiento_Arte FROM pieza_arte WHERE id_pieza = NEW.id_pieza;

    -- Se programa una excepción en caso de que la fecha de lanzamiento de una pieza de arte sea menor o igual que la fecha de nacimiento del artistaa
    IF Fecha_Lanzamiento_Arte <= Fecha_Nacimiento_Del_Artista THEN
        RAISE EXCEPTION 'No es posible añadir una fecha de lanzamiento menor o igual que la fecha de nacimiento del artista.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER prueba AFTER INSERT ON pieza_arte FOR EACH ROW
EXECUTE PROCEDURE comprueba_fecha_nacimiento();

-- Función que evita que una fecha de venta sea menor a la fecha de lanzamiento de la pieza de arte

CREATE OR REPLACE FUNCTION comprueba_fecha_venta() RETURNS TRIGGER AS
$$
DECLARE
    Fecha_Venta_Arte DATE;
    Fecha_De_Lanzamiento DATE;
BEGIN    
    -- Asignando valor a las variables
    SELECT fecha_venta INTO Fecha_Venta_Arte FROM venta WHERE id_venta = NEW.id_venta;

    SELECT fecha_lanzamiento INTO Fecha_De_Lanzamiento FROM pieza_arte WHERE id_pieza = NEW.id_pieza;

    -- Se programa una excepción en caso de que la fecha de venta de una pieza de arte sea menor o igual que la fecha de lanzamiento de una pieza de arte
    IF Fecha_Venta_Arte <= Fecha_De_Lanzamiento THEN
        RAISE EXCEPTION 'No es posible añadir una fecha de venta menor o igual que la fecha de lanzamiento de la fecha de arte.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER prueba2 AFTER INSERT ON venta FOR EACH ROW
EXECUTE PROCEDURE comprueba_fecha_venta();
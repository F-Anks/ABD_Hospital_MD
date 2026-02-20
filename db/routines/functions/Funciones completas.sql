-- NOMBRE DEL EQUIPO: Quantify
-- DESCRIPCION DEL CODIGO: Este bloque crea funciones para generar datos sintéticos coherentes
-- utilizados en la población automática de pacientes.
--
-- Incluye generación de nombres, apellidos, país de origen,
-- género con baja probabilidad de "Otro", grupo sanguíneo ponderado,
-- fechas de nacimiento por rango de edad, estatus médico y títulos
-- de cortesía acordes al género y edad.
--
-- También genera RFC y CURP conforme a reglas de negocio:
-- solo para personas mexicanas y RFC únicamente para mayores de edad.
--
-- Estas funciones apoyan los procedimientos de población de datos,
-- garantizando consistencia y realismo en los registros generados.

-- CREADO POR: ChatGPT 5.2 
-- ADAPTADO POR: Al Farias Leyva
-- SUPERVISADO POR: Francisco Garcia Garcia

DELIMITER $$

-- --------- Nombres por género ---------
DROP FUNCTION IF EXISTS fn_nombre_masculino $$
CREATE FUNCTION fn_nombre_masculino() RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
  RETURN ELT(1 + FLOOR(RAND()*25),
    'Juan','Jose','Luis','Carlos','Miguel','Jorge','Daniel','Sergio','Diego','Fernando',
    'Alejandro','Manuel','Ricardo','Eduardo','Hector','Roberto','Francisco','Rafael','Mario','Andres',
    'Adrian','Alberto','Angel','Emiliano','Oscar'
  );
END $$

DROP FUNCTION IF EXISTS fn_nombre_femenino $$
CREATE FUNCTION fn_nombre_femenino() RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
  RETURN ELT(1 + FLOOR(RAND()*25),
    'Maria','Guadalupe','Juana','Veronica','Fernanda','Daniela','Sofia','Valeria','Camila','Andrea',
    'Paola','Karla','Alejandra','Lucia','Martha','Patricia','Claudia','Rosa','Gabriela','Monica',
    'Ana','Elizabeth','Ximena','Regina','Natalia'
  );
END $$

DROP FUNCTION IF EXISTS fn_apellido $$
CREATE FUNCTION fn_apellido() RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
  RETURN ELT(1 + FLOOR(RAND()*30),
    'Garcia','Hernandez','Lopez','Martinez','Gonzalez','Perez','Sanchez','Ramirez','Cruz','Flores',
    'Gomez','Vazquez','Reyes','Morales','Jimenez','Torres','Diaz','Gutierrez','Ruiz','Mendoza',
    'Aguilar','Castillo','Ortiz','Romero','Alvarez','Silva','Ramos','Chavez','Rivera','Delgado'
  );
END $$

-- --------- País ponderado ---------
DROP FUNCTION IF EXISTS fn_pais_origen $$
CREATE FUNCTION fn_pais_origen() RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE r DOUBLE;
  SET r = RAND();
  IF r < 0.85 THEN RETURN 'Mexico';
  ELSEIF r < 0.89 THEN RETURN 'Colombia';
  ELSEIF r < 0.92 THEN RETURN 'Argentina';
  ELSEIF r < 0.95 THEN RETURN 'Peru';
  ELSEIF r < 0.97 THEN RETURN 'Chile';
  ELSEIF r < 0.99 THEN RETURN 'Guatemala';
  ELSE RETURN 'España';
  END IF;
END $$

-- --------- Género con baja probabilidad de "Otro" ---------
DROP FUNCTION IF EXISTS fn_genero_peso $$
CREATE FUNCTION fn_genero_peso() RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  DECLARE r DOUBLE;
  SET r = RAND();
  IF r < 0.495 THEN RETURN 'M';
  ELSEIF r < 0.99 THEN RETURN 'F';
  ELSE RETURN 'Otro'; -- 1%
  END IF;
END $$

-- --------- Grupo sanguíneo ponderado (O+ más común) ---------
DROP FUNCTION IF EXISTS fn_grupo_sanguineo_peso $$
CREATE FUNCTION fn_grupo_sanguineo_peso() RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
  DECLARE r DOUBLE;
  SET r = RAND();
  IF r < 0.38 THEN RETURN 'O+';
  ELSEIF r < 0.45 THEN RETURN 'A+';
  ELSEIF r < 0.52 THEN RETURN 'B+';
  ELSEIF r < 0.58 THEN RETURN 'AB+';
  ELSEIF r < 0.65 THEN RETURN 'O-';
  ELSEIF r < 0.78 THEN RETURN 'A-';
  ELSEIF r < 0.90 THEN RETURN 'B-';
  ELSE RETURN 'AB-';
  END IF;
END $$

-- --------- Fecha nacimiento por rango de edad ---------
DROP FUNCTION IF EXISTS fn_fecha_nacimiento_entre $$
CREATE FUNCTION fn_fecha_nacimiento_entre(p_edad_min INT, p_edad_max INT) RETURNS DATE
DETERMINISTIC
BEGIN
  DECLARE v_min DATE;
  DECLARE v_max DATE;

  SET p_edad_min = IFNULL(p_edad_min, 0);
  SET p_edad_max = IFNULL(p_edad_max, 90);
  IF p_edad_max < p_edad_min THEN SET p_edad_max = p_edad_min; END IF;

  SET v_min = DATE_SUB(CURDATE(), INTERVAL p_edad_max YEAR);
  SET v_max = DATE_SUB(CURDATE(), INTERVAL p_edad_min YEAR);

  RETURN DATE_ADD(v_min, INTERVAL FLOOR(RAND() * (DATEDIFF(v_max, v_min)+1)) DAY);
END $$

-- --------- Estatus médico ponderado (solo para VIVOS) ---------
DROP FUNCTION IF EXISTS fn_estatus_medico_peso $$
CREATE FUNCTION fn_estatus_medico_peso() RETURNS VARCHAR(150)
DETERMINISTIC
BEGIN
  DECLARE r DOUBLE;
  SET r = RAND();
  IF r < 0.55 THEN RETURN 'Estable';
  ELSEIF r < 0.70 THEN RETURN 'Observacion';
  ELSEIF r < 0.78 THEN RETURN 'Recuperacion';
  ELSEIF r < 0.85 THEN RETURN 'Pediatrico';
  ELSEIF r < 0.90 THEN RETURN 'Cuidados Paliativos';
  ELSEIF r < 0.94 THEN RETURN 'Coma';
  ELSEIF r < 0.98 THEN RETURN 'Vegetativo';
  ELSE RETURN 'Terapia Intensiva';
  END IF;
END $$

-- --------- Título de cortesía coherente por género y edad ---------
DROP FUNCTION IF EXISTS fn_titulo_cortesia $$
CREATE FUNCTION fn_titulo_cortesia(p_genero VARCHAR(10), p_edad INT) RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
  DECLARE r DOUBLE;
  SET r = RAND();

  IF p_genero = 'M' THEN
    IF p_edad < 18 THEN
      RETURN ELT(1+FLOOR(r*2),'Joven','Sr.');
    ELSE
      RETURN ELT(1+FLOOR(r*3),'Sr.','Dr.','Ing.');
    END IF;

  ELSEIF p_genero = 'F' THEN
    IF p_edad < 18 THEN
      RETURN ELT(1+FLOOR(r*2),'Srta.','Srita.');
    ELSE
      RETURN ELT(1+FLOOR(r*3),'Sra.','Dra.','Ing.');
    END IF;

  ELSE
    RETURN 'Mx.';
  END IF;
END $$

-- --------- RFC (NULL si no México o menor de 18) ---------
DROP FUNCTION IF EXISTS fn_rfc_generado $$
CREATE FUNCTION fn_rfc_generado(
  p_nombre VARCHAR(60),
  p_ap1 VARCHAR(60),
  p_ap2 VARCHAR(60),
  p_fnac DATE,
  p_id INT,
  p_pais VARCHAR(50),
  p_edad INT
) RETURNS VARCHAR(14)
DETERMINISTIC
BEGIN
  IF p_pais <> 'Mexico' THEN RETURN NULL; END IF;
  IF p_edad < 18 THEN RETURN NULL; END IF;

  RETURN CONCAT(
    UPPER(LEFT(p_ap1,1)),
    UPPER(LEFT(p_ap2,1)),
    UPPER(LEFT(p_nombre,2)),
    DATE_FORMAT(p_fnac,'%y%m%d'),
    LPAD(MOD(p_id,10000),4,'0')
  );
END $$

-- --------- CURP (NULL si no México) ---------
DROP FUNCTION IF EXISTS fn_curp_generado $$
CREATE FUNCTION fn_curp_generado(
  p_nombre VARCHAR(60),
  p_ap1 VARCHAR(60),
  p_ap2 VARCHAR(60),
  p_fnac DATE,
  p_genero VARCHAR(10),
  p_id INT,
  p_pais VARCHAR(50)
) RETURNS VARCHAR(18)
DETERMINISTIC
BEGIN
  IF p_pais <> 'Mexico' THEN RETURN NULL; END IF;

  RETURN CONCAT(
    UPPER(LEFT(p_ap1,2)),
    UPPER(LEFT(p_ap2,1)),
    UPPER(LEFT(p_nombre,1)),
    DATE_FORMAT(p_fnac,'%y%m%d'),
    IF(p_genero='F','M',IF(p_genero='M','H','X')),
    'MX',
    LPAD(MOD(p_id,100000),5,'0')
  );
END $$

DELIMITER ;
-- NOMBRE DEL EQUIPO: Quantify
-- DESCRIPCION DEL CODIGO: Procedimiento almacenado para insertar un paciente completo
-- respetando la jerarquía Persona -> Persona Física -> Paciente.
-- Genera datos coherentes (nombre/apellidos, género, edad, país, sangre,
-- estatus de vida y estatus médico) aplicando reglas de negocio:
-- finado = "Fallecido", pediátrico solo si edad <= 17, RFC/CURP solo para México
-- (y RFC solo para mayores de edad), y fechas consistentes (registro/actualización
-- y última cita entre registro y hoy). Inserta en las 3 tablas dentro de una
-- transacción para asegurar integridad.

-- CREADO POR: ChatGPT 5.2 
-- ADAPTADO POR: Francisco Garcia Garcia
-- SUPERVISADO POR: Jesus Alejandro Artiaga Morales

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_insertar_paciente $$
CREATE PROCEDURE sp_insertar_paciente(
  IN p_genero VARCHAR(10),         -- 'M'/'F'/'Otro' o NULL
  IN p_edad_min INT,               -- NULL libre
  IN p_edad_max INT,               -- NULL libre
  IN p_edad_maxima INT,            -- NULL libre
  IN p_estatus_vida VARCHAR(10),   -- 'Vivo'/'Finado' o NULL
  IN p_estatus_medico VARCHAR(150) -- NULL => ponderado
)
BEGIN
  DECLARE v_id INT UNSIGNED;

  DECLARE v_genero VARCHAR(10);
  DECLARE v_fnac DATE;
  DECLARE v_edad INT;

  DECLARE v_nombre VARCHAR(60);
  DECLARE v_ap1 VARCHAR(60);
  DECLARE v_ap2 VARCHAR(60);

  DECLARE v_pais VARCHAR(50);
  DECLARE v_grupo VARCHAR(3);

  DECLARE v_estatus_vida VARCHAR(10);
  DECLARE v_estatus_medico VARCHAR(150);

  DECLARE v_reg DATETIME;
  DECLARE v_act DATETIME;
  DECLARE v_ult_cita DATETIME;

  DECLARE v_curp VARCHAR(18);
  DECLARE v_rfc VARCHAR(14);
  DECLARE v_titulo VARCHAR(40);

  -- Género
  SET v_genero = IFNULL(p_genero, fn_genero_peso());

  -- Nombre coherente por género
  IF v_genero = 'F' THEN
    SET v_nombre = fn_nombre_femenino();
  ELSEIF v_genero = 'M' THEN
    SET v_nombre = fn_nombre_masculino();
  ELSE
    SET v_nombre = IF(RAND()<0.5, fn_nombre_masculino(), fn_nombre_femenino());
  END IF;

  -- Apellidos
  SET v_ap1 = fn_apellido();
  SET v_ap2 = fn_apellido();

  -- País
  SET v_pais = fn_pais_origen();

  -- Fecha nacimiento + edad
  SET v_fnac = fn_fecha_nacimiento_entre(p_edad_min, p_edad_max);
  IF v_fnac > CURDATE() THEN SET v_fnac = CURDATE(); END IF;
  SET v_edad = TIMESTAMPDIFF(YEAR, v_fnac, CURDATE());

  -- Tope edad máxima
  IF p_edad_maxima IS NOT NULL AND v_edad > p_edad_maxima THEN
    SET v_fnac = fn_fecha_nacimiento_entre(0, p_edad_maxima);
    SET v_edad = TIMESTAMPDIFF(YEAR, v_fnac, CURDATE());
  END IF;

  -- Sangre ponderada
  SET v_grupo = fn_grupo_sanguineo_peso();

  -- Estatus vida
  SET v_estatus_vida = IFNULL(p_estatus_vida, IF(RAND()<0.92,'Vivo','Finado'));

  -- Regla: Finado => Fallecido
  IF v_estatus_vida = 'Finado' THEN
    SET v_estatus_medico = 'Fallecido';
  ELSE
    SET v_estatus_medico = IFNULL(p_estatus_medico, fn_estatus_medico_peso());

    -- Regla: Pediatrico => edad <= 17
    IF v_estatus_medico = 'Pediatrico' AND v_edad > 17 THEN
      SET v_fnac = fn_fecha_nacimiento_entre(0, 17);
      SET v_edad = TIMESTAMPDIFF(YEAR, v_fnac, CURDATE());
    END IF;
  END IF;

  -- Título de cortesía por género/edad
  SET v_titulo = fn_titulo_cortesia(v_genero, v_edad);

  -- Fechas coherentes (registro en últimos 3 años)
  SET v_reg = DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*1095) DAY);
  SET v_act = DATE_ADD(v_reg, INTERVAL FLOOR(RAND()*180) DAY);
  IF v_act > NOW() THEN SET v_act = NOW(); END IF;

  -- Última cita entre registro y hoy (regla: no antes que registro)
  SET v_ult_cita = DATE_ADD(v_reg, INTERVAL FLOOR(RAND() * (DATEDIFF(NOW(), v_reg)+1)) DAY);
  IF v_ult_cita > NOW() THEN SET v_ult_cita = NOW(); END IF;

  START TRANSACTION;

  -- Insert persona (RFC temporal para obtener ID, luego se actualiza)
  INSERT INTO tbb_personas (tipo, rfc, pais_origen, fecha_registro, fecha_actualizacion, estatus)
  VALUES ('FISICA', CONCAT('TMP', LPAD(FLOOR(RAND()*100000000000), 11, '0')), v_pais, v_reg, v_act, b'1');

  SET v_id = LAST_INSERT_ID();

  -- RFC según reglas (no México => NULL, menor de 18 => NULL)
  SET v_rfc = fn_rfc_generado(v_nombre, v_ap1, v_ap2, v_fnac, v_id, v_pais, v_edad);
  UPDATE tbb_personas SET rfc = v_rfc WHERE ID = v_id;

  -- CURP según reglas (no México => NULL)
  SET v_curp = fn_curp_generado(v_nombre, v_ap1, v_ap2, v_fnac, v_genero, v_id, v_pais);

  INSERT INTO tbb_personas_fisicas(
    ID, titulo_cortesia, nombre, primer_apellido, segundo_apellido,
    genero, fecha_nacimiento, curp, grupo_sanguineo,
    fecha_registro, fecha_actualizacion, estatus
  )
  VALUES(
    v_id, v_titulo, v_nombre, v_ap1, v_ap2,
    v_genero, v_fnac, v_curp, v_grupo,
    v_reg, v_act, b'1'
  );

  INSERT INTO tbb_pacientes(
    ID, estatus_medico, estatus_vida, fecha_ultima_cita_medica,
    fecha_registro, fecha_actualizacion, estatus
  )
  VALUES(
    v_id, v_estatus_medico, v_estatus_vida, v_ult_cita,
    v_reg, v_act, b'1'
  );

  COMMIT;
END $$

DELIMITER ;
-- NOMBRE DEL EQUIPO: Quantify
-- DESCRIPCION DEL CODIGO: Procedimientos almacenados para la población masiva de pacientes.
-- sp_poblar_pacientes inserta N registros llamando repetidamente a
-- sp_insertar_paciente, permitiendo aplicar filtros por género, rango de edad,
-- estatus de vida y estatus médico. Valida que el total sea mayor a cero.
--
-- sp_poblar_pacientes_lotes realiza la misma población, pero en bloques (lotes)
-- con transacciones por lote para mejorar el rendimiento y la estabilidad en
-- cargas grandes (por ejemplo 10,000 a 1,000,000 registros), reduciendo el riesgo
-- de fallos durante inserciones masivas.

-- CREADO POR: ChatGPT 5.2 
-- ADAPTADO POR: Jesus Alejandro Artiaga Morales
-- SUPERVISADO POR: Francisco Garcia Garcia

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_poblar_pacientes $$
CREATE PROCEDURE sp_poblar_pacientes(
  IN p_total INT,
  IN p_genero VARCHAR(10),
  IN p_edad_min INT,
  IN p_edad_max INT,
  IN p_edad_maxima INT,
  IN p_estatus_vida VARCHAR(10),
  IN p_estatus_medico VARCHAR(150)
)
BEGIN
  DECLARE i INT DEFAULT 0;

  IF p_total IS NULL OR p_total <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_total debe ser > 0';
  END IF;

  WHILE i < p_total DO
    CALL sp_insertar_paciente(p_genero, p_edad_min, p_edad_max, p_edad_maxima, p_estatus_vida, p_estatus_medico);
    SET i = i + 1;
  END WHILE;
END $$

DROP PROCEDURE IF EXISTS sp_poblar_pacientes_lotes $$
CREATE PROCEDURE sp_poblar_pacientes_lotes(
  IN p_total INT,
  IN p_lote INT,
  IN p_genero VARCHAR(10),
  IN p_edad_min INT,
  IN p_edad_max INT,
  IN p_edad_maxima INT,
  IN p_estatus_vida VARCHAR(10),
  IN p_estatus_medico VARCHAR(150)
)
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE j INT DEFAULT 0;

  IF p_total IS NULL OR p_total <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_total debe ser > 0';
  END IF;

  SET p_lote = IFNULL(p_lote, 10000);
  IF p_lote <= 0 THEN SET p_lote = 10000; END IF;

  WHILE i < p_total DO
    SET j = 0;

    START TRANSACTION;
    WHILE j < p_lote AND i < p_total DO
      CALL sp_insertar_paciente(p_genero, p_edad_min, p_edad_max, p_edad_maxima, p_estatus_vida, p_estatus_medico);
      SET i = i + 1;
      SET j = j + 1;
    END WHILE;
    COMMIT;

  END WHILE;
END $$

DELIMITER ;
-- NOMBRE DEL EQUIPO: Quantify
-- DESCRIPCION DEL CODIGO: Script de ejecución de pruebas (tests) para validar la población de datos
-- generada por los procedimientos sp_poblar_pacientes y sp_poblar_pacientes_lotes.
-- Incluye pruebas de volumen (1, 10, 100, 1,000, 10,000 y 1,000,000 registros)
-- y pruebas de naturaleza (género, rangos de edad, estatus de vida y estatus médico).
-- Después de cada inserción se ejecutan consultas COUNT(*) y validaciones con filtros
-- para comprobar que se insertó la cantidad correcta y que los atributos cumplen
-- las condiciones solicitadas. Finaliza con una consulta JOIN que muestra un registro
-- completo de las 3 tablas (Persona -> Persona Física -> Paciente) como evidencia
-- de integridad relacional y llenado coherente de campos.

-- CREADO POR: ChatGPT 5.2 
-- ADAPTADO POR: Jesus Alejandro Artiaga Morales
-- SUPERVISADO POR: Al farias Leyva

-- TEST 1 — Registrar 1 paciente
CALL sp_poblar_pacientes(1, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

-- TEST 2 — Registrar 10 pacientes
CALL sp_poblar_pacientes(10, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

-- TEST 3 — Registrar 100 pacientes
CALL sp_poblar_pacientes(100, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

-- TEST 4 — Registrar 1000 pacientes
CALL sp_poblar_pacientes(1000, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

-- TEST 5 — Registrar 10,000 pacientes
CALL sp_poblar_pacientes(10000, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

-- TEST 6 — Registrar 1,000,000 pacientes (por lotes)
CALL sp_poblar_pacientes_lotes(1000000, 50000, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS pacientes FROM tbb_pacientes;

SELECT
 (SELECT COUNT(*) FROM tbb_personas) AS personas,
 (SELECT COUNT(*) FROM tbb_personas_fisicas) AS personas_fisicas,
 (SELECT COUNT(*) FROM tbb_pacientes) AS pacientes;

-- TESTS DE NATURALEZA
-- TEST 7 — 150 mujeres
CALL sp_poblar_pacientes(150, 'F', NULL, NULL, NULL, NULL, NULL);
SELECT COUNT(*) AS mujeres
FROM tbb_personas_fisicas
WHERE genero = 'F';

-- TEST 8 — 340 varones entre 20 y 30
CALL sp_poblar_pacientes(340, 'M', 20, 30, NULL, NULL, NULL);
SELECT COUNT(*) AS hombres_20_30
FROM tbb_personas_fisicas
WHERE genero = 'M'
AND TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) BETWEEN 20 AND 30;

-- TEST 9 — 500 pacientes con edad máxima 65
CALL sp_poblar_pacientes(500, NULL, NULL, NULL, 65, NULL, NULL);
SELECT COUNT(*) AS menores_65
FROM tbb_personas_fisicas
WHERE TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) <= 65;

-- TEST 10 — 2200 pacientes vivos
CALL sp_poblar_pacientes(2200, NULL, NULL, NULL, NULL, 'Vivo', NULL);
SELECT COUNT(*) AS vivos
FROM tbb_pacientes
WHERE estatus_vida = 'Vivo';

-- TEST 11 — 502 mujeres finadas mayores de 45
CALL sp_poblar_pacientes(502, 'F', 46, 95, NULL, 'Finado', NULL);
SELECT COUNT(*) AS mujeres_finadas_mayores_45
FROM tbb_personas_fisicas pf
JOIN tbb_pacientes pa ON pa.ID = pf.ID
WHERE pf.genero = 'F'
AND pa.estatus_vida = 'Finado'
AND TIMESTAMPDIFF(YEAR, pf.fecha_nacimiento, CURDATE()) > 45;

-- TEST 12 — 30 pacientes en coma
CALL sp_poblar_pacientes(30, NULL, NULL, NULL, NULL, NULL, 'Coma');
SELECT COUNT(*) AS en_coma
FROM tbb_pacientes
WHERE estatus_medico = 'Coma';

-- TEST 13 — 15 pacientes en estado vegetativo
CALL sp_poblar_pacientes(15, NULL, NULL, NULL, NULL, NULL, 'Vegetativo');
SELECT COUNT(*) AS vegetativo
FROM tbb_pacientes
WHERE estatus_medico = 'Vegetativo';

-- TEST 14 — 107 pacientes en cuidados paliativos
CALL sp_poblar_pacientes(107, NULL, NULL, NULL, NULL, NULL, 'Cuidados Paliativos');
SELECT COUNT(*) AS paliativos
FROM tbb_pacientes
WHERE estatus_medico = 'Cuidados Paliativos';

-- TEST 15 — 208 pacientes pediátricos (0–17)
CALL sp_poblar_pacientes(208, NULL, 0, 17, NULL, NULL, 'Pediatrico');
SELECT COUNT(*) AS pediatricos
FROM tbb_pacientes
WHERE estatus_medico = 'Pediatrico';

SELECT
    p.ID,
    p.pais_origen,
    p.rfc,
    pf.nombre,
    pf.primer_apellido,
    pf.genero,
    pf.curp,
    pf.grupo_sanguineo,
    pa.estatus_vida,
    pa.estatus_medico,
    pa.fecha_ultima_cita_medica
FROM tbb_personas p
JOIN tbb_personas_fisicas pf ON pf.ID = p.ID
JOIN tbb_pacientes pa ON pa.ID = pf.ID
LIMIT 1;
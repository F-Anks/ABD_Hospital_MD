# 🏥 ABD Práctica 05: Automatización y Análisis de Pacientes - Quantify - Base de Datos MD

Este repositorio contiene los scripts y recursos para la **Práctica 05** de la asignatura de Administración de Bases de Datos. El objetivo principal es la implementación de rutinas SQL (Procedimientos Almacenados y Funciones) para la generación masiva de datos y la visualización de métricas mediante un dashboard.

## Poblacion de Datos Pacientes

## 📂 Estructura del Proyecto

El proyecto está organizado de la siguiente manera para separar la lógica de base de datos de la capa de presentación:

```bash
ABD_PRACTICA05_AREA/
├── dashboard/                  # Archivos de visualización y reportes
│   └── dashboard_pacientes.nbi # Archivo de Navicat BI para análisis de pacientes
│
├── db/                         # Núcleo de la base de datos
│   ├── backups/                # Copias de seguridad lógicas
│   │   ├── backup_onlystructure.sql
│   │   └── backup_onlydata.sql
│   │
│   ├── routines/               # Lógica programable
│   │   ├── functions/
│   │   │   └── fn_genera_fech_nacimiento.sql
│   │   │
│   │   └── stored_procedures/
│   │       └── sp_poblar_pacientes.sql
│   │
│   ├── scripts/                # Scripts DDL/DML adicionales
│   └── tests/                  # Pruebas unitarias
│
└── README.md                   # Documentación del proyecto
```

## DESCRIPCION
 El estudiante se coordinara con su equipo de trabajo para trabajar en las rutinas SQL (funciones y/o procedimientos almacenados) necesarias para la poblacion pacientes, respetando la estructura jerarquica relacional del modelo de dato, testeando en diferentes escenarios de pruebas basados en volumen y naturaleza.

## TEST

## 📊 Tabla de los Test (15)

| Nº Test | Descripción | Cantidad | Condiciones / Filtros | Estado |
|---------|------------|----------|------------------------|--------|
| Test 1  | Registro de Paciente | 1 | Sin condiciones | En espera ⌛️|
| Test 2  | Registro de Pacientes | 10 | Sin condiciones | En espera ⌛️|
| Test 3  | Registro de Pacientes | 100 | Sin condiciones | En espera ⌛️|
| Test 4  | Registro de Pacientes | 1000 | Sin condiciones | En espera ⌛️|
| Test 5  | Registro de Pacientes | 10000 | Sin condiciones | En espera ⌛️|
| Test 6  | Registro de Pacientes | 1000000 | Sin condiciones | En espera ⌛️|
| Test 7  | Registro de Pacientes Mujeres | 150 | Género: Femenino | En espera ⌛️|
| Test 8  | Registro de Pacientes Varones | 340 | Género: Masculino, Edad entre 20 y 30 años | En espera ⌛️|
| Test 9  | Registro de Pacientes | 500 | Edad máxima: 65 años | En espera ⌛️|
| Test 10 | Registro de Pacientes Vivos | 2200 | Estado: Vivo | En espera ⌛️|
| Test 11 | Registro de Pacientes Mujeres Finados | 502 | Género: Femenino, Estado: Finado, Edad > 45 años | En espera ⌛️|
| Test 12 | Registro de Pacientes en Coma | 30 | Estado Médico: Coma | En espera ⌛️|
| Test 13 | Registro de Pacientes en Estado Vegetativo | 15 | Estado Médico: Vegetativo | En espera ⌛️|
| Test 14 | Registro de Pacientes en Cuidados Paliativos | 107 | Estado Médico: "Cuidados Paliativos" | En espera ⌛️|
| Test 15 | Registro de Pacientes Pediátricos | 208 | Clasificación: Pediátrico | En espera ⌛️|

## 📑 REGLAS DE NEGOCIO CONSIDERADAS

Las siguientes reglas de negocio fueron definidas para garantizar la integridad, coherencia y validez de los datos generados durante la automatización y análisis de pacientes:

### 1️⃣ Reglas Generales de Registro
- Todo paciente debe tener un identificador único (PK).
- Ningún paciente puede registrarse sin nombre, género y fecha de nacimiento.
- La edad debe calcularse a partir de la fecha de nacimiento (no almacenarse directamente si es campo derivado).
- La edad permitida debe estar en un rango válido (0 a 120 años).
- No se permiten registros duplicados con la misma combinación de CURP o identificador oficial (si aplica).

### 2️⃣ Reglas de Género
- Los valores permitidos para género son:
  - `H` → Hombre
  - `M` → Mujer
  - `NB` → No Binario
- No se aceptan otros valores fuera del catálogo definido.

### 3️⃣ Reglas de Estado Vital
- El estado del paciente solo puede ser:
  - `VIVO`
  - `FINADO`
- Si el paciente está marcado como `FINADO`, debe existir fecha de defunción.
- Un paciente `FINADO` no puede tener estados médicos activos posteriores a la fecha de defunción.

### 4️⃣ Reglas de Estado Médico
Los estados médicos permitidos son:
- `COMA`
- `VEGETATIVO`
- `CUIDADOS PALIATIVOS`
- `ESTABLE`
- `CRÍTICO`

- Un paciente solo puede tener un estado médico principal activo a la vez.
- El estado médico debe ser coherente con el estado vital.

### 5️⃣ Reglas de Clasificación por Edad
- Paciente Pediátrico: Edad menor a 18 años.
- Paciente Adulto: Edad entre 18 y 59 años.
- Paciente Adulto Mayor: Edad igual o mayor a 60 años.

### 6️⃣ Reglas para Generación Masiva (Procedimiento sp_poblar_pacientes)
- El procedimiento debe validar:
  - Que la cantidad solicitada sea mayor a 0.
  - Que el género enviado como parámetro sea válido.
  - Que el rango de edad mínimo y máximo sea coherente.
- En pruebas de alto volumen (ej. 1,000,000 registros), se debe garantizar:
  - No violación de llaves primarias.
  - No bloqueos prolongados.
  - Uso eficiente de transacciones.

### 7️⃣ Reglas de Integridad Referencial
- Todo paciente debe respetar la estructura jerárquica relacional del modelo.
- No se permiten registros huérfanos en tablas relacionadas.
- Se deben respetar llaves foráneas y restricciones definidas en el modelo.

### 8️⃣ Reglas para Pruebas (Testing)
- Cada escenario de prueba debe validar:
  - Cantidad exacta de registros generados.
  - Cumplimiento de filtros aplicados.
  - Correcto almacenamiento en base de datos.
- Los resultados deben poder visualizarse en el dashboard BI para análisis estadístico.





## 📋 Tabla de Integrantes

| Integrante | Contacto | Rol |
| :--- | :--- | :--- |
| Jesús Alejandro Artiaga Morales | [Jesus Artiaga](https://github.com/JesuuusArt) | Developer - Encargado del área de registros médicos |
| Angel de Jesús Baños Tellez | [Angel_JesusBT](https://github.com/angelJesus13) | Developer - Encargado del área de registros médicos |
| Al Farias Leyva | [Al Farias](https://github.com/fariasdgs) | Developer - Encargado del área de registros médicos |
| Francisco Garcia Garcia | [Francisco Garcia](https://github.com/F-Anks) | Developer - Encargado del área de registros médicos |

---

## 🌳 Estructura Jerárquica del Equipo

- **Equipo ABD - Práctica 05**
  - **Área: Registros Médicos**
    - Jesús Alejandro Artiaga Morales
    - Angel de Jesús Baños Tellez
    - Al Farias Leyva
    - Francisco Garcia Garcia
  - **Responsabilidad General**
    - Desarrollo de rutinas SQL
    - Implementación de pruebas de volumen
    - Validación de reglas de negocio
    - Visualización de métricas en dashboard BI
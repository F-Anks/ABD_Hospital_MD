# 🏥 ABD Práctica 05: Automatización y Análisis de Pacientes

Este repositorio contiene los scripts y recursos para la **Práctica 05** de la asignatura de Administración de Bases de Datos. El objetivo principal es la implementación de rutinas SQL (Procedimientos Almacenados y Funciones) para la generación masiva de datos y la visualización de métricas mediante un dashboard.

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

NOMBRE REPO
NOMBRE DEL EQUIPO - ROLE REGISTROS MEDICOS
NOMBRE DE LA PRACTICA 
DESCRIPCION DE PADLET 
OBJETIVO DE LA PRACTICA 
TABLA DE LOS TEST 15 
PRUEBAS DE VOLUMEN Y NATURALEZA
REGLAS DE NEGOCIO CONSIDERADAS
ESTRUCTURA DEL PROYECTO
INTEGRANTES MERMA 


# 🏥 Práctica 05 — Población de Datos de Pacientes

**Firmas:** 40  
**Fecha de entrega:** Viernes 13 de Febrero  

---

## 📌 Objetivo

El estudiante se coordinará con su equipo de trabajo para desarrollar las rutinas SQL necesarias (Funciones y/o Procedimientos Almacenados) para la población de pacientes, respetando la estructura jerárquica relacional del modelo de datos.

Se deberán realizar pruebas en distintos escenarios basados en:

- Volumen de registros  
- Naturaleza de los datos  

---

## 🧠 Recomendaciones

- Modularizar las funciones para su reutilización en futuros procesos de población de datos.  
- Considerar las reglas de negocio (validaciones y límites permitidos) para generar datos coherentes.  
- Utilizar mecanismos compatibles con SQL como:
  - ELT()
  - RAND()
  - SUBQUERIES
  - TRANSACTION
  - ROLLBACK
- Aplicar buenas prácticas de programación.  
- Documentar adecuadamente el código de las rutinas.  

---

## ⚙️ Actividades

### 1️⃣ Actualización del Modelo

- Actualizar la composición de las tablas:
  - Persona  
  - Persona Física  
  - Paciente  
- Verificar las relaciones de integridad (Llaves Foráneas).  

---

### 2️⃣ Procedimiento Almacenado

Actualizar el procedimiento:

sp_poblar_pacientes

Implementando las rutinas necesarias para generar dinámicamente los datos de cada columna en las tablas aplicables.

---

## 🧪 Escenarios de Pruebas

### 🔢 Pruebas de Volumen

| Test | Escenario |
|------|-----------|
| Test 1 | Registro de 1 Paciente |
| Test 2 | Registro de 10 Pacientes |
| Test 3 | Registro de 100 Pacientes |
| Test 4 | Registro de 1,000 Pacientes |
| Test 5 | Registro de 10,000 Pacientes |
| Test 6 | Registro de 1,000,000 Pacientes |

---

### 👥 Pruebas de Naturaleza

| Test | Escenario |
|------|-----------|
| Test 7 | Registro de 150 Pacientes Mujeres |
| Test 8 | Registro de 340 Pacientes Varones entre 20 y 30 años |
| Test 9 | Registro de 500 Pacientes con edad máxima de 65 años |
| Test 10 | Registro de 2,200 Pacientes Vivos |
| Test 11 | Registro de 502 Pacientes Mujeres Finadas mayores de 45 años |
| Test 12 | Registro de 30 Pacientes en Coma |
| Test 13 | Registro de 15 Pacientes en Estado Vegetativo |
| Test 14 | Registro de 107 Pacientes en estado médico "Cuidados Paliativos" |
| Test 15 | Registro de 208 Pacientes Pediátricos |

---

## 💾 Entregables

El proyecto deberá documentarse en un repositorio privado de GitHub, considerando:

- Inclusión de colaboradores  
- Manejo adecuado de ramas (Practica05)  

### 📦 Respaldos Requeridos

- Respaldo Estructural (Tablas)  
- Respaldo Funcional (Rutinas)  
- Respaldo Post-Población (Tablas + Rutinas + Datos)  

---

## 📄 Documentación

- Archivo README.md  
- Documentación del código SQL  
- Evidencias de pruebas realizadas  

---

## 📁 Estructura del Proyecto

ABD_Hospital_<EQUIPO>

Donde <EQUIPO> puede ser:

- GE  
- PH  
- HR  
- MR  
- MD  
- MS  

# Integrantes
| Integrante | Contacto | Rol |
| :--- | :--- | :--- |
| Jesús Alejandro Artiaga Morales| [Jesus Artiaga](https://github.com/JesuuusArt) | Developer - Encargado del área de registros medicos |
| Angel de Jesús Baños Tellez | [Angel_JesusBT](https://github.com/angelJesus13) | Developer - Encargado del área de registros medicos |
| Al Farias Leyva | [Al Farias](https://github.com/fariasdgs) | Developer - Encargado del área de registros medicos |
| Francisco Garcia Garcia | [Francisco Garcia](https://github.com/F-Anks) | Developer - Encargado del área de registros medicos |
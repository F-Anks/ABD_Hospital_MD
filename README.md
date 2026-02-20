# 🏥 ABD Práctica 05: Automatización y Análisis de Pacientes

Este repositorio contiene los scripts y recursos para la **Práctica 05** de la asignatura de Administración de Bases de Datos. El objetivo principal es la implementación de rutinas SQL (Procedimientos Almacenados y Funciones) para la generación masiva de datos y la visualización de métricas mediante un dashboard.

## 📂 Estructura del Proyecto

El proyecto está organizado de la siguiente manera para separar la lógica de base de datos de la capa de presentación:


ABD_PRACTICA05_AREA/
├── 📊 dashboard/           # Archivos de visualización y reportes
│   └── dashboard_pacientes.nbi  # Archivo de Navicat BI para análisis de pacientes
│
├── 🗄️ db/                  # Núcleo de la base de datos
│   ├── 💾 backups/         # Copias de seguridad lógicas
│   │   ├── backup_onlystructure.sql  # Solo esquema (tablas, vistas, sin datos)
│   │   └── backup_onlydata.sql       # Solo inserciones (datos actuales)
│   │
│   ├── ⚙️ routines/        # Lógica programable (PL/SQL)
│   │   ├── 𝑓 functions/
│   │   │   └── fn_genera_fech_nacimiento.sql  # Función auxiliar para generar fechas aleatorias
│   │   │
│   │   └── ⚡ stored procedures/
│   │       └── sp_poblar_pacientes.sql        # Procedimiento principal para inserción masiva
│   │
│   ├── 📜 scripts/         # Scripts DDL/DML adicionales
│   └── 🧪 tests/           # Pruebas unitarias de los procedimientos
│
└── ℹ️ readme.md            # Documentación del proyecto
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


# Integrantes
| Integrante | Contacto | Rol |
| :--- | :--- | :--- |
| Jesús Alejandro Artiaga Morales| [Jesus Artiaga](https://github.com/JesuuusArt) | Developer - Encargado del área de registros medicos |
| Angel de Jesús Baños Tellez | [Angel_JesusBT](https://github.com/angelJesus13) | Developer - Encargado del área de registros medicos |
| Al Farias Leyva | [Al Farias](https://github.com/fariasdgs) | Developer - Encargado del área de registros medicos |
| Francisco Garcia Garcia | [Francisco Garcia](https://github.com/F-Anks) | Developer - Encargado del área de registros medicos |

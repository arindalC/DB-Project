# DB-Project: Análisis de accidentes de tráfico en Inglaterra 

Integrantes del equipo: 
- Arindal Contreras Arrellano — 208529
- Lourdes Angélica Gutiérrez Landa — 207706
- Arturo Rodríguez Vázquez — 198271
- Bernardo González Moreno — 208780
  
## Descripción general de los datos 
Este proyecto busca analizar una base de datos que recopila información detallada sobre accidentes automovilísticos ocurridos en Inglaterra. Nuestro objetivo es identificar patrones y factores que influyen en los accidentes de tránsito y determinar las variables que estén asociadas con una mayor cantidad de incidencias. En particular, buscamos analizar si existe alguna relación entre las condiciones ambientales, el tipo de vehículo o la hora del día con la cantidad de accidentes que se producen. Los datos se encuentran en [este link](https://www.kaggle.com/datasets/xavierberge/road-accident-dataset?resource=download).

Este conjunto de datos fue recolectado por Xavier Berge, a partir de información proporcionada por UK Road Safety y está disponible en la plataforma Kaggle. La base de datos no cuenta con actualizaciones periódicas, ya que se trata de una recopilación estática.

Por un lado, el conocimiento de estos datos conlleva consideraciones éticas, ya que, puede ayudar a mejorar la seguridad vial, como la instalación de semáforos o la reducción de límites de velocidad en ciertas zonas. Sin embargo, también puede ser utilizado de manera negativa, como por parte de las autoridades para imponer multas de manera injusta o que personas busquen causar un accidente. Haremos uso de esta base de datos siendo conscientes de que no solamente “Accident_Index” es un identificador, sino que se hará con el respeto que se merece. 
### Información general de la base de datos: 
- Número de atributos: 23
- Número de tuplas: 307,973
  
| **Atributo** | **Descripción** | **Tipo de atributo** |
|-------------|---------------|----------------|
| Accident_Index | Identificador único del accidente | Texto|
| Accident Date | Fecha del accidente | Temporal |
| Month | Mes del accidente | Categórico |
| Day_of_Week | Día de la semana en que ocurrió | Categórico |
| Year | Año del accidente. | Numérico |
| Junction_Control | Indica cómo se controlaba el tráfico en la intersección donde ocurrió el accidente. | Categórico |
| Junction_Detail | Describe cómo es la intersección donde ocurrió el accidente. | Categórico |
| Accident_Severity | Gravedad del accidente | Categórico |
| Latitude | Latitud de la ubicación. | Numérico |
| Light_Conditions | Condiciones de luz en el momento del accidente. | Categórico |
| Local_Authority_(District) | Indica en qué distrito ocurrió el accidente. | Categórico |
| Carriageway_Hazards | Indica si había peligros en la carretera que pudieron contribuir al accidente. | Categórico |
| Longitude | Longitud de la ubicación. | Numérico |
| Number_of_Casualties | Número de víctimas. | Numérico |
| Number_of_Vehicles | Número de vehículos involucrados. | Numérico |
| Police_Force | Fuerza policial a cargo del reporte. | Categórico |
| Road_Surface_Conditions | Condiciones de la superficie de la carretera. | Categórico |
| Road_Type | Tipo de vía. | Categórico |
| Speed_limit | Límite de velocidad en la zona. | Numérico |
| Time | Hora del accidente. | Temporal |
| Urban_or_Rural_Area | Si el accidente ocurrió en área urbana o rural. | Categórico |
| Weather_Conditions | Condiciones climáticas al momento del accidente. | Categórico |
| Vehicle_Type | Tipo de vehículo involucrado. | Categórico |

### Carga inicial de datos en PostgreSQL:
**Nota**: Asegúrate de guardar el archivo `.csv` antes de comenzar.

1. Crear la base de datos (desde psql):

   CREATE DATABASE accidentes_trafico;
   
3. Conectarse a la base de datos (psql):

   postgres=# \c accidentes_trafico
   
3. Crear el esquema y la tabla (desde PostgresSQL):

    [Ver carga_inicial.sql](https://github.com/arindalC/DB-Project/blob/main/carga_inicial.sql)
  
4. Cargar datos desde un archivo .csv (desde psql):

  accidentes_trafico=# \copy road_data.road_accidents(accident_index, accident_date, month, day_of_week, year, junction_control, junction_detail, accident_severity,               latitude, light_conditions,     local_authority_district, carriageway_hazards, longitude, number_of_casualties, number_of_vehicles, police_force, road_surface_conditions,        road_type, speed_limit, accident_time,  urban_or_rural_area, weather_conditions, vehicle_type) FROM '/Users/Desktop/Road Accident Data.csv' WITH (FORMAT CSV, HEADER true,        DELIMITER ',');

 ###  Análisis exploratorio de datos:
 El archivo [road_accidents_eda.sql](https://github.com/arindalC/DB-Project/blob/main/road_accidents_eda.sql) contiene una colección de consultas SQL utilizadas para realizar el análisis exploratorio de los datos. 
   
###  Limpieza de datos:
Este repositorio contiene los datos y scripts asociados a la limpieza y preparación de datos sobre la base de datos. 
[limpieza_datos_proyecto.sql](https://github.com/arindalC/DB-Project/blob/main/limpieza_datos_proyecto.sql)

Las siguientes actividades fueron llevadas a cabo para limpiar los datos:
1. Para realizar la limpieza de datos se creó un nuevo esquema (cleaned_road_data) y una tabla en lugar de modificar la existente.
2. Eliminación de columnas redundantes:
   Se eliminaron las columnas Month, Year y Day_of_Week, ya que esta información ya está contenida en Accident Date.
3. Conversión de tipos de datos:
   Se transformaron las fechas (Accident Date) al tipo DATE.
   Se separó la hora (Time) en un campo TIME para facilitar el análisis por franjas horarias.
4. Cambio de nombres de columnas:
   Se renombraron columnas a un formato estandarizado y legible, por ejemplo, Number_of_Casualties a casualties.
5. Normalización de valores:
   Se agruparon y homogeneizaron valores en campos como Accident Severity, Weather_Conditions y Urban_or_Rural_Area.
6. Eliminación de registros o columnas:
   Se descartaron columnas como Accident_Index y se creó un nuevo id artificial ya que habían ids duplicados pero con datos diferentes. De igual manera se eliminó la columna "carriageway_hazard" y "juction_control" ya que habían muy pocos datos con un valor diferente a "None". Tampocó se agregaron los atributos "local_authority_district", "police_force", "road_sruface_conditions", ya que consideramos que no los usaremos para nuestro análisis y objetivo principal. 
   
###  Normalización de datos:
Las dependencias funcionales y multivaluadas que encontramos fueron las siguientes:
| **Dependencias** | **Descripción** | 
|------------------|-----------------|
|F1. {accident_id} → {accident_date, accident_time, severity_type, number_casualties, number_vehicles, vehicle_type}| Un accidente tiene una fecha, una hora, tiene una severidad asociada, junto con el número de heridos, vehículos involucrados y el tipo de vehículo que tuvo el accidente| 
|F2.{accident_id}  → {latitude, longitude, juction_type, road_type, speed_limit}| Un accidente tiene una ubicación: latitud y longitud, tiene una intersección víal, una velocidad y un tipo de viaje|
|MV1. {accident_id} ↠ {weather_type}| Un accidente puede ocurrir bajo varias condiciones climáticas, por lo que obtenemos un conjunto de ellas|
|MV2. {accident_id} ↠ {light_type}| Un accidente puede ocurrir bajo varias condiciones de iluminación, por lo que obtenemos un conjunto de ellas|
###  Diagrama de entidad-relación:
<img width="843" alt="Captura de Pantalla 2025-05-05 a la(s) 21 52 14" src="https://github.com/user-attachments/assets/70be2aac-6558-4233-8362-f6a224ca73fd" />


###  Descomposición de datos:
El archivo [descomposicion_de_datos:](https://github.com/arindalC/DB-Project/blob/main/descomposicio%CC%81n_road_accident.sql) contiene todas las descomposiciones necesarias para alcanzar el diagrama de entidad-relación.

###  Consultsd y resultados:

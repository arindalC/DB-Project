
# DB-Project: Análisis de accidentes de tráfico en Inglaterra 

Integrantes del equipo: 
- Arindal Contreras Arrellano — 208529
- Arturo Rodríguez Vázquez 
- Bernardo González Moreno — 208780
- Lourdes Angélica Gutiérrez Landa — 207706
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
# **psql**
CREATE DATABASE accidentes_trafico;
postgres=# \c accidentes_trafico

# **PostgresSQL**
Apartado en carga_inicial

# **psql**
accidentes_trafico=# \copy road_data.road_accidents(accident_index, accident_date, month, day_of_week, year, junction_control, junction_detail, accident_severity, latitude, light_conditions, local_authority_district, carriageway_hazards, longitude, number_of_casualties, number_of_vehicles, police_force, road_surface_conditions, road_type, speed_limit, aacident_time, urban_or_rural_area, weather_conditions, vehicle_type) FROM '/Users/Desktop/Road Accident Data.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',')

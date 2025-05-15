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
**Nota**: Asegúrate de guardar el archivo `.csv` antes de comenzar. Se encuentra en: [Base de datos](https://github.com/arindalC/DB-Project/blob/main/Road%20Accident%20Data.csv.zip)

1. Crear la base de datos (desde psql):
  ```
  CREATE DATABASE accidentes_trafico;
  ``` 
3. Conectarse a la base de datos (psql):
  ```
  \c accidentes_trafico
  ```
3. Crear el esquema y la tabla (desde PostgresSQL):

    [Ver carga_inicial.sql](https://github.com/arindalC/DB-Project/blob/main/carga_inicial.sql)
  
4. Cargar datos desde un archivo .csv (desde psql):
```
\copy road_data.road_accidents(accident_index, accident_date, month, day_of_week, year, junction_control, junction_detail, accident_severity,latitude, light_conditions, local_authority_district, carriageway_hazards, longitude, number_of_casualties, number_of_vehicles, police_force, road_surface_conditions,road_type, speed_limit, accident_time,  urban_or_rural_area, weather_conditions, vehicle_type) 
FROM '/Users/Desktop/Road Accident Data.csv' 
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```

 ###  Análisis exploratorio de datos:
 El archivo [road_accidents_eda.sql]([https://github.com/arindalC/DB-Project/blob/main/road_accidents_eda.sql](https://github.com/arindalC/DB-Project/blob/main/Road%20Accident%20Data.csv.zip)) contiene una colección de consultas SQL utilizadas para realizar el análisis exploratorio de los datos. 

Durante el análisis exploratorio de los datos, identificamos varias inconsistencias. Por ejemplo, observamos que la variable id, que se supone que debería de ser un identificador único, presentaba únicamente 197,644 valores únicos a pesar de que el conjunto total contenía 307,973 observaciones. También notamos que en la columna "Carriage_hazards" hay 302,546 datos con el valor "none" y en la columna de "junction_control" habían 98056 datos con el valor de "Data missing or out of range".
   
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

### Consultas y Resultados

#### I. Consultas Exploratorias

---

**1. Tipos de Vehículos Más Comunes en Accidentes**  
**Consulta:** Cuenta la cantidad de accidentes por tipo de vehículo involucrado.


| Vehículo    | Total Accidentes |
|-------------|------------------|
| Car                                       | 239,794          |
| Van/ Goods 3.5 tonnes mgw or under        | 15,695           |
| Motorcycle over 500cc                     | 11,226           |
| Bus or Coach (17 or more pass seats)      | 8,686            |
| Motorcycle 125cc and under                | 6,852            |

![Grafica 1 autos](https://github.com/user-attachments/assets/51a255d8-4bf1-4ede-9cdd-14152dcde08d)

**Hallazgo:** Los automóviles por sí solos representan el 78 % de todos los accidentes registrados, por lo que cualquier estrategia de seguridad vial debe centrarse en el comportamiento de los autos particulares (velocidad, distracción, deterioro de las capacidades).


**2. Tipos de Cruces Más Peligrosos**  
**Consulta:** Analiza la cantidad de accidentes por tipo de cruce.

| Cruce                                | Total Accidentes |
|--------------------------------------|------------------|
| Not at junction or within 20 meters  | 123,081          |
| T or staggered junction              | 96,715           |
| Crossroads                           | 29,945           |
| Roundabout                           | 27,264           |
| Private drive or entrance            | 10,874           |

**Hallazgo:** Casi la mitad de todas las colisiones ocurren en intersecciones en T, desfasadas o en cruceta, zonas donde las normas de prioridad suelen malinterpretarse. La solucion seria mejorar la señalizacion y la visibilidad en estos puntos.

---

**3. Condiciones Climáticas Más Frecuentes en Accidentes**  
**Consulta:** Cuenta la cantidad de accidentes según el clima reportado.

| Clima       | Total Accidentes |
|-------------|------------------|
| No high winds    | 284,193  |
| Fine             | 247,628  |
| Raining          | 38,398   |
| Other            | 8,801    |
| high winds       | 7,210    |
| Not Specified    | 6,057    |
| Snowing          | 5,377    |
| Fog or mist      | 1,690    |



**Hallazgo:** La lluvia es menos frecuente, pero se correlaciona con un mayor número de lesiones. Las medidas preventivas para carreteras mojadas, como el drenaje de superficie y los recubrimientos antideslizantes, ofrecen un alto impacto.

---

**4. Accidentes por Período del Día**  
**Consulta:** Agrupa los accidentes según el momento del día.

| Período del Día | Total Accidentes |
|------------------|------------------|
| Tarde (15-18h)         | 132,398          |
| Mañana (05-12h)        | 88,369           |
| Noche (18-24h)         | 72,305            |
| Madrugada (00-05h)     | 14,901            |

![Grafica 2 Horas](https://github.com/user-attachments/assets/88325946-f009-4b69-8ef3-931bfc006cb6)

**Hallazgo:** Las tardes concentran el mayor número de accidentes, probablemente debido a la hora pico de salida laboral.

---

**5. Horas con Mayor Número de Accidentes**  
**Consulta:** Muestra las horas del día con más accidentes.

| Hora   | Accidentes |
|--------|------------|
| 17:00  | 26,964     |
| 16:00  | 24,903     |
| 15:00  | 24,151     |
| 08:00  | 22,552     |
| 18:00  | 21,063     |
| 14:00  | 19,067     |
| 13:00  | 18,971     |
| 12:00  | 18,342     |
| 11:00  | 16,141     |
| 19:00  | 15,851     |

![Grafica 3 Horario](https://github.com/user-attachments/assets/5432da42-0b3b-4b76-9a41-6fef69841225)

**Hallazgo:** Las 17:00 h es la hora con mayor incidencia, lo que refuerza el hallazgo anterior.


#### II. Consultas Analíticas


1. **Severidad de accidentes por tipo de vía y límite de velocidad**  
   **Consulta:** Clasifica accidentes por gravedad, tipo de vía y límite de velocidad.  
   **Hallazgo:** Vías rápidas con límites superiores a 80 km/h tienen alta incidencia de accidentes severos o fatales.

2. **Combinación clima más iluminación**  
   **Consulta:** Agrupa accidentes por clima e iluminación.  
   
| Iluminación               | Clima                  | Accidentes Totales  | Accidentes Fatales  |
|---------------------------|------------------------|---------------------|---------------------|
| Daylight                  | Fine no high winds     | 188,558             | 2,047               |
| Darkness – lights lit     | Fine no high winds     | 42,668              | 701                 |
| Daylight                  | Raining no high winds  | 21,603              | 197                 |
| Darkness – no lighting    | Fine no high winds     | 10,817              | 491                 |
| Darkness – lights lit     | Raining no high winds  | 10,190              | 96                  |

   **Hallazgo:** El día y el clima seco representan más de la mitad del conjunto de datos, pero el riesgo de mortalidad aumenta en escenas oscuras y sin iluminación, lo que justifica las inversiones en iluminación vial.
3. **Análisis jerárquico de cruces peligrosos**  
   **Consulta:** Usa ROLLUP para jerarquizar cruces por gravedad y número de víctimas.  
   **Hallazgo:** Los cruces tipo "T" con alta proporción de accidentes graves/fatales deberían ser intervenidos prioritariamente.

4. **Combinaciones de factores de riesgo**  
   **Consulta:** Agrupa por tipo de vía, clima e iluminación.

| Severidad | Tipo de Vía            | Límite de Velocidad (mph)   | Accidentes |
|-----------|------------------------|-----------------------------|------------|
| Slight    | Single carriageway     | 30                          | 144,412    |
| Slight    | Single carriageway     | 40                          | 12,269     |
| Slight    | Single carriageway     | 60                          | 32,159     |
| Serious   | Single carriageway     | 30                          | 20,765     |
| Slight    | Dual carriageway       | 70                          | 16,660     |

   **Hallazgo:** Estos puntos críticos guían la ubicación de cámaras de velocidad y la revisión de los límites de velocidad.


6. **Coordenadas geográficas con accidentes recurrentes**  
   **Consulta:** Ubicaciones exactas donde se repiten accidentes bajo las mismas condiciones de luz.
   
| Latitud   | Longitud    | Condiciones de Luz | Accidentes |
|-----------|-------------|--------------------|------------|
| 51.496389 | –3.143767   | Daylight           | 15         |
| 52.967634 | –1.190861   | Daylight           | 15         |
| 52.949719 | –0.977611   | Daylight           | 14         |
| 51.506693 | –3.310596   | Daylight           | 13         |
| 51.494771 | –3.206534   | Daylight           | 12         |
   **Hallazgo:** Compartir estas coordenadas con los consejos locales permite realizar auditorías micro de la señalización, las condiciones de la superficie y la iluminación.
8. **Vehículos en accidentes fatales**  
   **Consulta:** Identifica los tipos de vehículos con más participación en accidentes fatales.  

   | Tipo de Vehículo | Accidentes Fatales |
   |------------------|--------------------|
   | Car                     | 432                |
   | Van / Goods < 3.5t      | 321                |
   | Motorcycle > 500cc      | 210                |
   | Bus/ coach (> 17 seats) | 86                 |
   | Motorcycle < 125cc      | 81                 |

   ![Grafica 4 Accidentes fatales](https://github.com/user-attachments/assets/ab371ffd-e0ee-45cf-9a58-f74904faa738)

   **Hallazgo:** Los automóviles siguen siendo los más mortales simplemente por su exposición, pero las motocicletas de alta cilindrada están sobrerrepresentadas en relación con su participación en el tráfico.

9. **Porcentaje de accidentes fatales**  
   **Consulta:** Sobre el numero de accidentes totales, sacar el porcentaje de accidentes mortales.  
   | Tipo de Vehículo | Total de accidentes | Accidentes Fatales | Tasa de Mortalidad |
   |------------------|--------------------|------------------|--------------------|
   | Car                     | 432                | 239,794          |  0.18% |
   | Van / Goods < 3.5t      | 321                | 15,695           |  2.04% |
   | Motorcycle > 500cc      | 210                | 11,226           |  1.87% |
   | Bus/ coach (> 17 seats) | 86                 | 8,686            |  0.99% |
   | Motorcycle < 125cc      | 81                 | 6,852            |  1.18% |
  

   **Hallazgo:** Apesar de que hay un numero mayor de automoviles el porcantaje de accidentes mortales sobre la cantidad total de accidentes es mayor en vehiculos de carga o en motocicletas.

   
**Posdata**
Es Importante recalcar que estos hallazgos no sólo son insumos para análisis técnico, sino también una herramienta ética y social. Con el cual nos preguntamos como podemos contribuir para disminuir el número de accidentes y disminuir el número de afectados. Es un recordatorio de que detrás de cada número hay una vida, y que los datos, usados con responsabilidad y empatía, también pueden salvarlas.


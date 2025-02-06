# DB-Project
# Análisis de accidentes de tráfico en Inglaterra 
Por: 
Arindal Contreras Arrellano — 208529
Arturo Rodríguez Vázquez 
Bernardo González Moreno — 208780
Lourdes Angélica Gutiérrez Landa — 207706

## Road Accident Dataset 
(https://www.kaggle.com/datasets/xavierberge/road-accident-dataset?resource=download)


### Descripcion general de los datos 
Este proyecto busca analizar una base de datos que recopila información detallada sobre accidentes automovilísticos en Inglaterra. Nuestro objetivo es identificar patrones y factores que influyen en los accidentes de tránsito y determinar las variables que estén asociadas con una mayor cantidad de incidencias. En particular, buscamos analizar si existe alguna relación entre las condiciones ambientales, el tipo de vehículo  o la hora con la cantidad de accidentes que puede haber en un día o mes. 

### Fuente de los datos: 
Recolector: Xavier Berge (Propietario)
Fuente: UK Road Safety
Disponible en:Kaggle 
Frecuencia de actualización: Nunca 
###Estructura de la base de datos: 
Número de atributos: 23
Número de tuplas: 307,973
**Atributos:**
- Accident_Index: Identificador único del accidente.
- Accident Date: Fecha del accidente.
- Month: Mes del accidente.
- Day_of_Week: Día de la semana en que ocurrió.
- Year: Año del accidente.
- Junction_Control: Indica cómo se controlaba el tráfico en la intersección donde ocurrió el accidente.
- Junction_Detail:Describe cómo es la intersección donde ocurrió el accidente.
- Accident_Severity: Gravedad del accidente (Leve, Grave, Fatal).
- Latitude: Latitud de la ubicación.
- Light_Conditions: Condiciones de luz en el momento del accidente.
- Local_Authority_(District): Indica en qué distrito ocurrió el accidente
- Carriageway_Hazards: Si había algún peligro en la carretera que pudo haber contribuido al accidente
- Longitude: Longitud de la ubicación. 
- Number_of_Casualties: Número de víctimas.
- Number_of_Vehicles: Número de vehículos involucrados.
- Police_Force: Fuerza policial a cargo del reporte.
- Road_Surface_Conditions: Condiciones de la superficie de la carretera.
- Road_Type: Tipo de vía.
- Speed_limit: Límite de velocidad en la zona.
- Time: Hora del accidente.
- Urban_or_Rural_Area: Si el accidente ocurrió en área urbana o rural.
- Weather_Conditions: Condiciones climáticas al momento del accidente.
- Vehicle_Type: Tipo de vehículo involucrado.

### Tipos de datos: 
- Numéricos: Year, Latitude, Longitude, Number_of_Casualties, Number_of_Vehicles, Speed_limit
- Categóricos:Accident_Severity, Light_Conditions, Road_Surface_Conditions, Road_Type, Urban_or_Rural_Area, Weather_Conditions, Vehicle_Type, Local_Authority_(District), Junction_Control, Junction_Detail, Police_Force, Carriageway_Hazards. 
- Temporales: Accident Date, Time 
- Texto: Vehicle_Type, Weather_Conditions, Urban_or_Rural_Area, Road_Type,Road_Surface_Conditions, Police_Force,Carriageway_Hazards, Light_Conditions, Local_Authority_(District), Accident_Severity, Junction_Detail, Junction_Control, Day_of_Week,Month, Accident_Index

### Consideraciones éticas: 
Por un lado, el conocimiento de estos datos conlleva consideraciones éticas, ya que, puede ayudar a mejorar la seguridad vial, como la instalación de semáforos o la reducción de límites de velocidad en ciertas zonas. Sin embargo, también puede ser utilizado de manera negativa, como por parte de las autoridades para imponer multas de manera injusta o que personas busquen causar un accidente. Haremos uso de esta base de datos siendo conscientes de que no solamente “Accident_Index” es un identificador, sino que se hará con el respeto que se merece. 

---Análisis exploratorio de datos

-- 1. Veamos la cantidad de tuplas 
SELECT COUNT(*) AS total_tuplas
FROM road_data.road_accidents;

-- 2. Veamos la cantidad de atributos
SELECT COUNT(column_name) AS total_atributos
FROM information_schema.columns
WHERE table_name = 'road_accidents'
AND table_schema = 'road_data';

-- 3. Atributos con su tipo de datos
SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_name = 'road_accidents';

-- 4. Valores únicos
SELECT 'accident_index' AS columna,
       COUNT(DISTINCT accident_index) AS valores_unicos
FROM road_data.road_accidents

UNION ALL

SELECT 'month',
       COUNT(DISTINCT month)
FROM road_data.road_accidents

UNION ALL

SELECT 'accident_severity',
       COUNT(DISTINCT accident_severity)
FROM road_data.road_accidents;


--5. Estadísticas básicas (Mínimos, máximos y promedios de valores numéricos)
SELECT MIN(latitude) AS min_latitud,
       MAX(latitude) AS max_latitud,
       AVG(latitude) AS avg_latitud,
	   MIN(longitude) AS min_longitud,
	   MAX(longitude) AS max_longitud,
	   AVG(longitude) AS avg_longitud,
	   MIN(number_of_vehicles) AS min_vehiculos,
	   MAX(number_of_vehicles) AS max_vehiculos,
       AVG(number_of_vehicles) AS avg_vehiculos,
	   MIN(number_of_casualties) AS min_victimas,
	   MAX(number_of_casualties) AS max_victimas,
	   AVG(number_of_casualties) AS avg_victimas
FROM road_data.road_accidents;

-- 6. Mínimos y Máximos de Fechas
SELECT MIN(accident_date) AS fecha_minima,
       MAX(accident_date) AS fecha_maxima
FROM road_data.road_accidents;

--7. Duplicados en atributos categóricos (para ver la frecuencia de cada una)
SELECT junction_control,
       COUNT(*) AS duplicados
FROM road_data.road_accidents
GROUP BY junction_control
HAVING COUNT(*) > 1;

SELECT accident_severity,
       COUNT(*) AS duplicados
FROM road_data.road_accidents
GROUP BY accident_severity
HAVING COUNT(*) > 1;

SELECT month,
       COUNT(*) AS duplicados
FROM road_data.road_accidents
GROUP BY month
HAVING COUNT(*) > 1;

SELECT day_of_week, COUNT(*) AS total_accidentes
FROM road_data.road_accidents
GROUP BY day_of_week
ORDER BY total_accidentes DESC;

SELECT urban_or_rural_area, COUNT(*) AS total_accidentes
FROM road_data.road_accidents
GROUP BY urban_or_rural_area
ORDER BY total_accidentes DESC;

SELECT road_type, COUNT(*) AS total_accidentes
FROM road_data.road_accidents
GROUP BY road_type
ORDER BY total_accidentes DESC;

--8. Cantidad de valores nulos por atributo
SELECT 'accident_index' AS column_name,COUNT(*)-COUNT(accident_index) AS valores_nulos FROM road_data.road_accidents
UNION
SELECT 'accident_date',COUNT(*)-COUNT(accident_date) FROM road_data.road_accidents
UNION
SELECT 'month', COUNT(*)-COUNT(month) FROM road_data.road_accidents
UNION
SELECT 'day_of_week', COUNT(*)- COUNT(day_of_week) FROM road_data.road_accidents
UNION
SELECT 'year', COUNT(*) - COUNT(year) FROM road_data.road_accidents
UNION
SELECT 'junction_control', COUNT(*) - COUNT(junction_control) FROM road_data.road_accidents
UNION
SELECT 'junction_detail', COUNT(*) - COUNT(junction_detail) FROM road_data.road_accidents
UNION
SELECT 'accident_severity', COUNT(*) - COUNT(accident_severity) FROM road_data.road_accidents
UNION
SELECT 'latitude', COUNT(*) - COUNT(latitude) FROM road_data.road_accidents
UNION
SELECT 'light_conditions', COUNT(*) - COUNT(light_conditions) FROM road_data.road_accidents
UNION
SELECT 'local_authority_district', COUNT(*) - COUNT(local_authority_district) FROM road_data.road_accidents
UNION
SELECT 'carriageway_hazards', COUNT(*) - COUNT(carriageway_hazards) FROM road_data.road_accidents
UNION
SELECT 'longitude', COUNT(*) - COUNT(longitude) FROM road_data.road_accidents
UNION
SELECT 'number_of_casualties', COUNT(*) - COUNT(number_of_casualties) FROM road_data.road_accidents
UNION
SELECT 'number_of_vehicles', COUNT(*) - COUNT(number_of_vehicles) FROM road_data.road_accidents
UNION
SELECT 'police_force', COUNT(*) - COUNT(police_force) FROM road_data.road_accidents
UNION
SELECT 'road_surface_conditions', COUNT(*) - COUNT(road_surface_conditions) FROM road_data.road_accidents
UNION
SELECT 'road_type', COUNT(*) - COUNT(road_type) FROM road_data.road_accidents
UNION
SELECT 'speed_limit', COUNT(*) - COUNT(speed_limit) FROM road_data.road_accidents
UNION
SELECT 'accident_time', COUNT(*) - COUNT(accident_time) FROM road_data.road_accidents
UNION
SELECT 'urban_or_rural_area', COUNT(*) - COUNT(urban_or_rural_area) FROM road_data.road_accidents
UNION
SELECT 'weather_conditions', COUNT(*) - COUNT(weather_conditions) FROM road_data.road_accidents
UNION
SELECT 'vehicle_type', COUNT(*) - COUNT(vehicle_type) FROM road_data.road_accidents;

-- 9.Checamos inconsistencias geográficas
SELECT *
FROM road_data.road_accidents
WHERE latitude < -90 OR latitude > 90 OR longitude < -180 OR longitude > 180;


--10. Checamos errores posibles con accident_index
SELECT accident_index, COUNT(*) 
FROM road_data.road_accidents
GROUP BY accident_index
HAVING COUNT(*) > 1;

SELECT DISTINCT accident_index
FROM road_data.road_accidents;

SELECT COUNT(*) AS total_filas,
       COUNT(DISTINCT accident_index) AS ids_unicos
FROM road_data.road_accidents;

--11. Columnas potencialmente redundantes (valores únicos por columna)
SELECT 'junction_control' AS columna, COUNT(DISTINCT junction_control) AS distintos FROM road_data.road_accidents
UNION ALL
SELECT 'urban_or_rural_area', COUNT(DISTINCT urban_or_rural_area) FROM road_data.road_accidents
UNION ALL
SELECT 'police_force', COUNT(DISTINCT police_force) FROM road_data.road_accidents
UNION ALL
SELECT 'light_conditions', COUNT(DISTINCT light_conditions) FROM road_data.road_accidents
UNION ALL
SELECT 'road_type', COUNT(DISTINCT road_type) FROM road_data.road_accidents
UNION ALL
SELECT 'vehicle_type', COUNT(DISTINCT vehicle_type) FROM road_data.road_accidents
UNION ALL
SELECT 'weather_conditions', COUNT(DISTINCT weather_conditions) FROM road_data.road_accidents
UNION ALL
SELECT 'speed_limit', COUNT(DISTINCT speed_limit) FROM road_data.road_accidents;
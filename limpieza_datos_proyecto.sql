-- CREAR ESQUEMA CON LOS DATOS LIMPIOS
DROP SCHEMA IF EXISTS cleaed_road_data;
CREATE SCHEMA IF NOT EXISTS cleaned_road_data; 



-- Eliminar tabla final si existe
DROP TABLE IF EXISTS cleaned_road_data.road_data_db;

-- Crear nueva tabla limpia con estructura mejorada
CREATE TABLE cleaned_road_data.road_data_db (
	accident_ID SERIAL PRIMARY KEY,
	accident_date DATE,
    accident_time TIME,
    -- Eliminar columnas redundantes (no seleccionar month, year, day_of_week)
    junction_control VARCHAR(100),
    junction_detail VARCHAR(100),
    accident_severity VARCHAR(20),
    latitude NUMERIC,
    longitude NUMERIC,
    casualties INTEGER,
    vehicles INTEGER,
    weather_conditions TEXT,
    road_type TEXT,
    speed_limit INTEGER,
    urban_or_rural_area VARCHAR(20),
    vehicle_type TEXT
);
    
INSERT INTO cleaned_road_data.road_data_db (accident_date,
    accident_time,
    junction_control,
    junction_detail,
    accident_severity,
    latitude,
    longitude,
    casualties,
    vehicles,
    weather_conditions,
    road_type,
    speed_limit,
    urban_or_rural_area,
    vehicle_type)
SELECT
	DISTINCT
    -- Fechas y tiempos validados
    accident_date,
    accident_time,
    
    -- Eliminar columnas redundantes (no seleccionar month, year, day_of_week)
    junction_control,
    junction_detail,
    accident_severity,
    
    -- Coordenadas validadas
    CASE WHEN latitude BETWEEN -90 AND 90 THEN ROUND(latitude::numeric, 6) END AS latitude,
    CASE WHEN longitude BETWEEN -180 AND 180 THEN ROUND(longitude::numeric, 6) END AS longitude,
    
    -- Datos numéricos corregidos
    GREATEST(number_of_casualties, 0) AS casualties,
    GREATEST(number_of_vehicles, 0) AS vehicles,
    
    -- Condiciones estandarizadas
    
    COALESCE(
        NULLIF(TRIM(weather_conditions), ''),  -- Primero eliminar espacios y convertir empty strings a NULL
        'Not specified'
    ) AS weather_conditions,
    
    -- Columnas restantes limpias
    COALESCE(
        NULLIF(TRIM(road_type), ''),  -- Primero eliminar espacios y convertir empty strings a NULL
        'Not specified'
    ) AS road_type,
    
    
    speed_limit,
    urban_or_rural_area,
    TRIM(vehicle_type) AS vehicle_type

FROM road_data.road_accidents
WHERE
    accident_date IS NOT NULL
-- 
    AND latitude BETWEEN -90 AND 90
    AND longitude BETWEEN -180 AND 180;
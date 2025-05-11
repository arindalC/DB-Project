----------------- CÓDIGO DE CONSULTAS Y ANÁLISIS --------------------


-- I) Consultas simples para tener un mejor entendimiento de la base y el contexto:
-- 1. Tipos de vehículos más comunes en accidentes
SELECT v.vehicle_type AS "Vehículo", COUNT(av.accident_id) AS "Total Accidentes"
FROM public.accident_vehicle av
JOIN public.vehicle v ON av.vehicle_id = v.id
GROUP BY v.vehicle_type
ORDER BY COUNT(av.accident_id) DESC
LIMIT 5;

-- 2. Top 5 tipos de cruces más peligrosos
SELECT j.junction_type AS "Cruce", COUNT(l.accident_id) AS "Total Accidentes"
FROM public.location l
JOIN public.junction j ON l.junction_id = j.id
GROUP BY j.junction_type
ORDER BY COUNT(l.accident_id) DESC
LIMIT 5;

-- 3. Condiciones climáticas más frecuentes
SELECT w.weather_type AS "Clima", COUNT(aw.accident_id) AS "Total Accidentes"
FROM public.accident_weather aw
JOIN public.weather_condition w ON aw.weather_id = w.id
GROUP BY w.weather_type
ORDER BY COUNT(aw.accident_id) DESC;

-- 4. Cantidad de accidentes por periodo del día
SELECT
  CASE
    WHEN accident_time BETWEEN TIME '05:00' AND TIME '11:59' THEN 'Mañana'
    WHEN accident_time BETWEEN TIME '12:00' AND TIME '17:59' THEN 'Tarde'
    WHEN accident_time BETWEEN TIME '18:00' AND TIME '23:59' THEN 'Noche'
    ELSE 'Madrugada'
  END AS "Periodo del Día",
  COUNT(*) AS "Total Accidentes"
FROM cleaned_road_data.road_data_db
GROUP BY "Periodo del Día"
ORDER BY "Total Accidentes" ASC;

-- 5. Horas del día con mayor número de accidentes
SELECT 
  EXTRACT(HOUR FROM accident_time) AS "Hora del Día",
  COUNT(*) AS "Total Accidentes"
FROM cleaned_road_data.road_data_db
GROUP BY "Hora del Día"
ORDER BY "Total Accidentes" DESC;

-- II) Consultas mas complejas para un mejor análisis

-- 1. Severidad de accidentes por tipo de vía y límite de velocidad. Ordena los accidentes de acuerdo a la severidad primeramente 
-- y despues de acuerdo al total de accidentes en al base, de acuerdo a cierto tipo de vía y cierta velocidad maxima. 
SELECT 
  s.severity_type as "Gravedad",
  rt.road_type as "Tipo de Vía",
  sl.speed_limit as "Velocidad Máxima",
  COUNT(a.id) as "Total Accidentes",
  AVG(a.number_casualties) as "Lesiones Promedio",
  RANK() OVER(PARTITION BY s.severity_type ORDER BY COUNT(a.id) DESC) as "Ranking"
FROM public.accident a
JOIN public.severity s ON a.severity_id = s.id
JOIN public.location l ON a.id = l.accident_id
JOIN public.road_characteristics rc ON l.road_characteristics_id = rc.id
JOIN public.road_type_table rt ON rc.road_type_id = rt.id
JOIN public.speed_limit_table sl ON rc.speed_limit_id = sl.id
GROUP BY s.severity_type, rt.road_type, sl.speed_limit;




-- 2. Análisis de condiciones lumínicas y meteorológicas combinadas, analiza el numero de accidentes de acuerdo al clima y la
-- iluminación durante el accidente
SELECT 
  lc.light_type as "Iluminación",
  wc.weather_type as "Clima",
  COUNT(DISTINCT a.id) as total_accidentes,
  COUNT(DISTINCT CASE WHEN s.severity_type = 'Fatal' THEN a.id END) as accidentes_fatales
FROM public.accident a
JOIN public.accident_light al ON a.id = al.accident_id
JOIN publica.light_condition lc ON al.light_id = lc.id
JOIN public.accident_weather aw ON a.id = aw.accident_id
JOIN public.weather_condition wc ON aw.weather_id = wc.id
JOIN public.severity s ON a.severity_id = s.id
GROUP BY CUBE(lc.light_type, wc.weather_type)
ORDER BY total_accidentes DESC;


-- 3. Análisis jerárquico de cruces peligrosos
WITH junction_analysis AS (
  SELECT 
    j.junction_type as cruce,
    s.severity_type as gravedad,
    COUNT(*) as accidentes,
    SUM(a.number_casualties) as victimas
  FROM public.location l
  JOIN public.junction j ON l.junction_id = j.id
  JOIN public.accident a ON l.accident_id = a.id
  JOIN public.severity s ON a.severity_id = s.id
  GROUP BY ROLLUP(j.junction_type, s.severity_type)
  )
SELECT 
  cruce,
  gravedad,
  accidentes,
  victimas,
  ROUND(100.0 * accidentes / SUM(accidentes) OVER(PARTITION BY cruce), 2) as porcentaje_gravedad
FROM junction_analysis
WHERE gravedad IS NOT NULL
ORDER BY porcentaje_gravedad DESC;

-- 4. Combinaciones de condiciones de iluminación, clima y tipo de vía con mayor número de accidentes
SELECT 
  road_type AS "Tipo de Vía",
  weather_conditions AS "Clima",
  light_conditions AS "Iluminación",
  COUNT(*) AS "Total Accidentes"
FROM cleaned_road_data.road_data_db
GROUP BY road_type, weather_conditions, light_conditions
ORDER BY "Total Accidentes" DESC
LIMIT 10;

--5. Coordenadas geográficas que se repiten con la misma condición de luz
SELECT 
  latitude AS "Latitud",
  longitude AS "Longitud",
  light_conditions AS "Condición de Luz",
  COUNT(*) AS "Total Accidentes"
FROM cleaned_road_data.road_data_db
GROUP BY latitude, longitude, light_conditions
HAVING COUNT(*) > 1
ORDER BY "Total Accidentes" DESC;

--6. Tipos de vehículos más frecuentes en accidentes fatales
SELECT 
  v.vehicle_type AS "Tipo de Vehículo",
  COUNT(*) AS "Accidentes Fatales"
FROM public.accident_vehicle av
JOIN public.accident a ON av.accident_id = a.id
JOIN public.severity s ON a.severity_id = s.id
JOIN public.vehicle v ON av.vehicle_id = v.id
WHERE s.severity_type = 'Fatal'
GROUP BY v.vehicle_type
ORDER BY "Accidentes Fatales" DESC;

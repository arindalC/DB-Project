----------------- CÓDIGO DE CONSULTAS Y ANÁLISIS --------------------


-- I) Consultas simples para tener un mejor entendimiento de la base y el contexto:
-- 1. Tipos de vehículos más comunes en accidentes
SELECT v.vehicle_type AS "Vehículo", COUNT(av.accident_id) AS "Total Accidentes"
FROM cleaned_road_data.accident_vehicle av
JOIN cleaned_road_data.vehicle v ON av.vehicle_id = v.id
GROUP BY v.vehicle_type
ORDER BY COUNT(av.accident_id) DESC
LIMIT 5;

-- 2. Top 5 tipos de cruces más peligrosos
SELECT j.junction_type AS "Cruce", COUNT(l.accident_id) AS "Total Accidentes"
FROM cleaned_road_data.location l
JOIN cleaned_road_data.junction j ON l.junction_id = j.id
GROUP BY j.junction_type
ORDER BY COUNT(l.accident_id) DESC
LIMIT 5;

-- 3. Condiciones climáticas más frecuentes
SELECT w.weather_type AS "Clima", COUNT(aw.accident_id) AS "Total Accidentes"
FROM cleaned_road_data.accident_weather aw
JOIN cleaned_road_data.weather_condition w ON aw.weather_id = w.id
GROUP BY w.weather_type
ORDER BY COUNT(aw.accident_id) DESC;


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
FROM cleaned_road_data.accident a
JOIN cleaned_road_data.severity s ON a.severity_id = s.id
JOIN cleaned_road_data.location l ON a.id = l.accident_id
JOIN cleaned_road_data.road_characteristics rc ON l.road_characteristics_id = rc.id
JOIN cleaned_road_data.road_type_table rt ON rc.road_type_id = rt.id
JOIN cleaned_road_data.speed_limit_table sl ON rc.speed_limit_id = sl.id
GROUP BY s.severity_type, rt.road_type, sl.speed_limit;




-- 2. Análisis de condiciones lumínicas y meteorológicas combinadas, analiza el numero de accidentes de acuerdo al clima y la
-- iluminación durante el accidente
SELECT 
  lc.light_type as "Iluminación",
  wc.weather_type as "Clima",
  COUNT(DISTINCT a.id) as total_accidentes,
  COUNT(DISTINCT CASE WHEN s.severity_type = 'Fatal' THEN a.id END) as accidentes_fatales
FROM cleaned_road_data.accident a
JOIN cleaned_road_data.accident_light al ON a.id = al.accident_id
JOIN cleaned_road_data.light_condition lc ON al.light_id = lc.id
JOIN cleaned_road_data.accident_weather aw ON a.id = aw.accident_id
JOIN cleaned_road_data.weather_condition wc ON aw.weather_id = wc.id
JOIN cleaned_road_data.severity s ON a.severity_id = s.id
GROUP BY CUBE(lc.light_type, wc.weather_type)
ORDER BY total_accidentes DESC;


-- 3. Análisis jerárquico de cruces peligrosos
WITH junction_analysis AS (
  SELECT 
    j.junction_type as cruce,
    s.severity_type as gravedad,
    COUNT(*) as accidentes,
    SUM(a.number_casualties) as victimas
  FROM cleaned_road_data.location l
  JOIN cleaned_road_data.junction j ON l.junction_id = j.id
  JOIN cleaned_road_data.accident a ON l.accident_id = a.id
  JOIN cleaned_road_data.severity s ON a.severity_id = s.id
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

---Creamos tabla severity
DROP TABLE IF EXISTS public.severity;
CREATE TABLE public.severity (
	id BIGSERIAL PRIMARY KEY,
	severity_type VARCHAR(20)
);
INSERT INTO public.severity (severity_type)
SELECT DISTINCT accident_severity
FROM cleaned_road_data.road_data_db;


---Creamos tabla road_type_table
DROP TABLE IF EXISTS public.road_type_table;
CREATE TABLE public.road_type_table(
	id BIGSERIAL PRIMARY KEY,
	road_type VARCHAR(100) UNIQUE NOT NULL
);
INSERT INTO public.road_type_table (road_type)
SELECT DISTINCT road_type
FROM cleaned_road_data.road_data_db;


---Creamos tabla speed_limit_table
DROP TABLE IF EXISTS public.road_characteristics;
CREATE TABLE public.road_characteristics (
  id SERIAL PRIMARY KEY,
  road_type_id INTEGER REFERENCES public.road_type_table(id), 
  speed_limit_id INTEGER REFERENCES public.speed_limit_table(id),
   
  UNIQUE(road_type_id, speed_limit_id)
);
INSERT INTO public.road_characteristics (road_type_id, speed_limit_id) 
SELECT DISTINCT
  rt.id,
  sl.id
FROM cleaned_road_data.road_data_db ot
JOIN public.road_type_table rt ON ot.road_type = rt.road_type 
JOIN public.speed_limit_table sl ON ot.speed_limit = sl.speed_limit 
WHERE ot.road_type IS NOT NULL AND ot.speed_limit IS NOT NULL;


---Creamos la tabla junction
DROP TABLE IF EXISTS public.junction; 
CREATE TABLE public.junction ( 
  id SERIAL PRIMARY KEY,
  junction_type VARCHAR(100)
);
INSERT INTO public.junction (junction_type) 
SELECT DISTINCT junction_detail
FROM cleaned_road_data.road_data_db;


---Creamos tabla vehicle
DROP TABLE IF EXISTS public.vehicle;
CREATE TABLE public.vehicle (
	id BIGSERIAL PRIMARY KEY,
	vehicle_type VARCHAR(100) UNIQUE NOT NULL
);
INSERT INTO public.vehicle (vehicle_type)
SELECT DISTINCT vehicle_type
FROM cleaned_road_data.road_data_db;


---Creamos tabla accident 
DROP TABLE IF EXISTS public.accident;
CREATE TABLE public.accident (
  id SERIAL PRIMARY KEY,
  accident_date DATE NOT NULL,
  accident_time TIME,
  severity_id INTEGER REFERENCES public.severity(id),
  number_casualties INTEGER NOT NULL,
  number_vehicles INTEGER NOT NULL
);
INSERT INTO public.accident (id, accident_date, accident_time, severity_id, number_casualties, number_vehicles)
SELECT
  rdd.accident_id,
  rdd.accident_date,
  rdd.accident_time,
  s.id,
  rdd.casualties,
  rdd.vehicles
FROM cleaned_road_data.road_data_db rdd
JOIN public.severity s
  ON rdd.accident_severity = s.severity_type;


---Tabla pivote 
DROP TABLE IF EXISTS public.accident_vehicle;
CREATE TABLE public.accident_vehicle (
  id SERIAL PRIMARY KEY,
  accident_id BIGINT REFERENCES public.accident(id),
  vehicle_id INTEGER REFERENCES public.vehicle(id)
);
INSERT INTO public.accident_vehicle (accident_id, vehicle_id)
SELECT DISTINCT
  a.id,
  v.id
FROM cleaned_road_data.road_data_db rdd
JOIN public.accident a 
  ON a.id = rdd.accident_id
JOIN public.vehicle v 
  ON v.vehicle_type = rdd.vehicle_type
WHERE rdd.vehicle_type IS NOT NULL;


---Creamos tabla location
DROP TABLE IF EXISTS public.location;
CREATE TABLE public.location (
  id BIGSERIAL PRIMARY KEY,
  accident_id BIGINT NOT NULL REFERENCES public.accident(id),
  latitude NUMERIC NOT NULL,
  longitude NUMERIC NOT NULL,
  junction_id INTEGER REFERENCES public.junction(id),
  road_characteristics_id INTEGER REFERENCES public.road_characteristics(id),
  is_urbal BOOL NOT NULL
);
INSERT INTO  public.location (
  accident_id, latitude, longitude, junction_id, road_characteristics_id, is_urbal
)
SELECT
  a.id,
  rdd.latitude,
  rdd.longitude,
  j.id,
  rc.id,
  CASE 
    WHEN rdd.urban_or_rural_area ILIKE 'urban' THEN TRUE
    ELSE FALSE
  END
FROM cleaned_road_data.road_data_db rdd
JOIN  public.accident a
  ON a.id = rdd.accident_id
JOIN  public.junction j
  ON j.junction_type = rdd.junction_detail
JOIN  public.road_type_table rt
  ON rt.road_type = rdd.road_type
JOIN  public.speed_limit_table sl
  ON sl.speed_limit = rdd.speed_limit
JOIN  public.road_characteristics rc
  ON rc.road_type_id = rt.id AND rc.speed_limit_id = sl.id;


---Creamos tabla light_condition
DROP TABLE IF EXISTS public.light_condition;
CREATE TABLE public.light_condition (
  id SERIAL PRIMARY KEY,
  light_type VARCHAR(100) UNIQUE NOT NULL
);
INSERT INTO public.light_condition (light_type)
SELECT DISTINCT TRIM(l)
FROM cleaned_road_data.road_data_db rdd,
LATERAL unnest(string_to_array(rdd.light_conditions, '-')) AS l;


---Creamos la tabla accident_light
DROP TABLE IF EXISTS public.accident_light;
CREATE TABLE public.accident_light (
  accident_id BIGINT REFERENCES public.accident(id),
  light_id INTEGER REFERENCES public.light_condition(id)
);
INSERT INTO public.accident_light (accident_id, light_id)
SELECT
  a.id,
  lc.id
FROM cleaned_road_data.road_data_db rdd
JOIN public.accident a ON a.id = rdd.accident_id,
LATERAL unnest(string_to_array(rdd.light_conditions, '–')) AS l
JOIN public.light_condition lc ON TRIM(l) = lc.light_type;


---Creamos tabla weather_condition
DROP TABLE IF EXISTS public.weather_condition;
CREATE TABLE public.weather_condition (
  id SERIAL PRIMARY KEY,
  weather_type VARCHAR(100) UNIQUE NOT NULL
);
INSERT INTO public.weather_condition (weather_type)
SELECT DISTINCT TRIM(w)
FROM cleaned_road_data.road_data_db rdd,
LATERAL unnest(string_to_array(
  REPLACE(rdd.weather_conditions, ' no ', ' + no '),
  '+'
)) AS w;


----Creamos tabla accident_weather
DROP TABLE IF EXISTS public.accident_weather;
CREATE TABLE public.accident_weather (
  accident_id BIGINT REFERENCES public.accident(id),
  weather_id INTEGER REFERENCES public.weather_condition(id)
);
INSERT INTO public.accident_weather (accident_id, weather_id)
SELECT
  a.id,
  wc.id
FROM cleaned_road_data.road_data_db rdd
JOIN public.accident a ON a.id = rdd.accident_id,
LATERAL unnest(string_to_array(
  REPLACE(rdd.weather_conditions, ' no ', ' + no '),
  '+'
)) AS w
JOIN public.weather_condition wc ON TRIM(w) = wc.weather_type;


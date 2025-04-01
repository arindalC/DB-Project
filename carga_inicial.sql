---Creamos el esquema
DROP SCHEMA IF EXISTS road_data;
CREATE SCHEMA IF NOT EXISTS road_data;

---Creamos la tabla dentro del esquema 
DROP TABLE IF EXISTS road_data.road_accidents;
CREATE TABLE road_data.road_accidents(
    accident_index VARCHAR(50), 
    accident_date DATE NOT NULL,         
    month VARCHAR(20),                   
    day_of_week VARCHAR(20),             
    year INTEGER,                        
    junction_control VARCHAR(100),       
    junction_detail VARCHAR(100),        
    accident_severity VARCHAR(20),       
    latitude NUMERIC(9,6),               
    light_conditions VARCHAR(100),       
    local_authority_district VARCHAR(100), 
    carriageway_hazards VARCHAR(100),    
    longitude NUMERIC(9,6),              
    number_of_casualties INTEGER,        
    number_of_vehicles INTEGER,          
    police_force VARCHAR(100),           
    road_surface_conditions VARCHAR(100), 
    road_type VARCHAR(50),               
    speed_limit INTEGER,                 
    accident_time TIME,                  
    urban_or_rural_area VARCHAR(20),     
    weather_conditions VARCHAR(100),     
    vehicle_type VARCHAR(100)            
);
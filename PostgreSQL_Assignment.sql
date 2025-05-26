-- PostgreSQL_Assignment.sql
-- Wildlife Conservation Monitoring Assignment

-- Step 1: Create the database
CREATE DATABASE conservation_db;

-- Connect to the database
\c conservation_db

-- Step 2: Drop existing tables if exist
DROP TABLE IF EXISTS sightings;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS rangers;

-- Step 3: Create the data tables

-- Create rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT NOT NULL
);
-- Create species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name TEXT NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status TEXT NOT NULL CHECK (conservation_status IN ('Endangered', 'Vulnerable', 'Historic'))
);
-- Create sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id) ON DELETE CASCADE,
    ranger_id INT REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL,
    location TEXT NOT NULL,
    notes TEXT
);

-- Step 4: Insert sample data
-- Rangers
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Sofia Rahman', 'Blue Valley'),
(2, 'Amir Khan', 'Silver Hills'),
(3, 'Priya Sharma', 'Golden Plains'),
(4, 'Ravi Patel', 'Emerald Forest'),
(5, 'Nila Das', 'Crystal Ridge');

-- Species
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Clouded Leopard', 'Neofelis nebulosa', '1775-01-01', 'Endangered'),
(2, 'Royal Tiger', 'Panthera tigris regalis', '1758-01-01', 'Endangered'),
(3, 'Himalayan Red Panda', 'Ailurus himalayensis', '1825-01-01', 'Vulnerable'),
(4, 'Indian Rhino', 'Rhinoceros unicornis', '1826-03-12', 'Endangered'),
(5, 'Great Hornbill', 'Buceros bicornis', '1861-11-09', 'Vulnerable'),
(6, 'Siberian Mammoth', 'Mammuthus sibiricus', '1799-06-15', 'Historic'),
(7, 'Mauritian Dodo', 'Raphus mauritianus', '1598-01-01', 'Historic'),
(8, 'Mythical Dragon', 'Draco mythicus', '2024-01-01', 'Endangered');

-- Sightings
INSERT INTO sightings (sighting_id, species_id, ranger_id, sighting_time, location, notes) VALUES
(1, 1, 1, '2024-05-10 07:45:00', 'Misty Pass', 'Camera trap image'),
(2, 2, 2, '2024-05-12 16:20:00', 'River Bend', 'Juvenile observed'),
(3, 3, 3, '2024-05-13 10:00:00', 'Bamboo Valley', 'Feeding activity'),
(4, 4, 4, '2024-05-14 14:15:00', 'Forest Edge', 'Tracks near stream'),
(5, 5, 5, '2024-05-15 08:00:00', 'Open Meadow', 'Flock in flight'),
(6, 6, 1, '2024-05-16 13:00:00', 'Fossil Ground', 'Mammoth remains found'),
(7, 7, 2, '2024-05-17 09:30:00', 'Ancient Site', 'Dodo artifacts observed');

-- Step 5: Solve the problems

-- Problem 1: Register a new ranger
INSERT INTO rangers (name, region)
VALUES ('Zara Ahmed', 'Coastal Plains');

-- Problem 2: Count unique species ever sighted
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3: Find all sightings where the location includes "Pass"
SELECT *
FROM sightings
WHERE location ILIKE '%Pass%';

-- Problem 4: List each ranger's name and their total number of sightings
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY r.name;

-- Problem 5: List species that have never been sighted
SELECT common_name
FROM species
WHERE species_id NOT IN (
    SELECT DISTINCT species_id FROM sightings
);

-- Problem 6: Show the most recent 2 sightings
SELECT sp.common_name, s.sighting_time, r.name
FROM sightings s
JOIN species sp ON s.species_id = sp.species_id
JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';
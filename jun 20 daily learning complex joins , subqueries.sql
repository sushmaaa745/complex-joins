-- Create Database

CREATE DATABASE squirrelDB;
USE squirrelDB;

CREATE TABLE species (
    species_id INT AUTO_INCREMENT PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE habitats (
    habitat_id INT AUTO_INCREMENT PRIMARY KEY,
    habitat_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE characteristics (
    characteristic_id INT AUTO_INCREMENT PRIMARY KEY,
    characteristic_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE species_habitat (
    species_id INT,
    habitat_id INT,
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    FOREIGN KEY (habitat_id) REFERENCES habitats(habitat_id),
    PRIMARY KEY (species_id, habitat_id)
);

CREATE TABLE species_characteristics (
    species_id INT,
    characteristic_id INT,
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    FOREIGN KEY (characteristic_id) REFERENCES characteristics(characteristic_id),
    PRIMARY KEY (species_id, characteristic_id)
);
CREATE TABLE species_characteristics (
    species_id INT,
    characteristic_id INT,
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    FOREIGN KEY (characteristic_id) REFERENCES characteristics(characteristic_id),
    PRIMARY KEY (species_id, characteristic_id)
);
INSERT INTO species (common_name, scientific_name, description) VALUES
('Eastern Gray Squirrel', 'Sciurus carolinensis', 'A tree squirrel found in the eastern and midwestern United States.'),
('American Red Squirrel', 'Tamiasciurus hudsonicus', 'A tree squirrel found primarily in coniferous forests.');

INSERT INTO habitats (habitat_name, location) VALUES
('Urban Parks', 'Various Cities'),
('Coniferous Forests', 'Northern Regions');

INSERT INTO characteristics (characteristic_name, description) VALUES
('Color', 'The color of the squirrel’s fur.'),
('Diet', 'Typical foods consumed by the squirrel.');

INSERT INTO species_habitat (species_id, habitat_id) VALUES
(1, 1),  -- Eastern Gray Squirrel in Urban Parks
(2, 2);  -- American Red Squirrel in Coniferous Forests

INSERT INTO species_characteristics (species_id, characteristic_id) VALUES
(1, 1),  -- Eastern Gray Squirrel with Color characteristic
(2, 2);  -- American Red Squirrel with Diet characteristic

SELECT common_name 
FROM species 
WHERE species_id IN (
    SELECT species_id 
    FROM species_habitat 
    WHERE habitat_id = (SELECT habitat_id FROM habitats WHERE habitat_name = 'Urban Parks')
);


SELECT common_name 
FROM species 
WHERE species_id IN (
    SELECT species_id 
    FROM species_characteristics 
    WHERE characteristic_id = (SELECT characteristic_id FROM characteristics WHERE characteristic_name = 'Color')
);

SELECT s.common_name, h.habitat_name 
FROM species s
JOIN species_habitat sh ON s.species_id = sh.species_id
JOIN habitats h ON sh.habitat_id = h.habitat_id;

SELECT s.common_name, c.characteristic_name 
FROM species s
JOIN species_characteristics sc ON s.species_id = sc.species_id
JOIN characteristics c ON sc.characteristic_id = c.characteristic_id;

-- urban species
SELECT common_name 
FROM species 
WHERE species_id IN (
    SELECT species_id 
    FROM species_habitat 
    WHERE habitat_id = (SELECT habitat_id FROM habitats WHERE habitat_name = 'Urban Parks')
);

-- color
SELECT common_name 
FROM species 
WHERE species_id IN (
    SELECT species_id 
    FROM species_characteristics 
    WHERE characteristic_id = (SELECT characteristic_id FROM characteristics WHERE characteristic_name = 'Color')
);

-- species and their habitats

SELECT s.common_name, h.habitat_name 
FROM species s
JOIN species_habitat sh ON s.species_id = sh.species_id
JOIN habitats h ON sh.habitat_id = h.habitat_id;

-- common examples
-- Example 1: Find the common names of all squirrel species that have been sighted more than 10 times
SELECT s.common_name
FROM species s
JOIN sightings si ON s.species_id = si.species_id
GROUP BY s.common_name
HAVING SUM(si.count) > 10;

-- Example 2: Retrieve the scientific names and the number of habitats where each species has been sighted
SELECT s.scientific_name, COUNT(DISTINCT si.habitat_id) AS num_habitats
FROM species s
JOIN sightings si ON s.species_id = si.species_id
GROUP BY s.scientific_name;

-- Example 3: Find the most recent sighting date for each species
SELECT s.common_name, MAX(si.sighting_date) AS last_sighting_date
FROM species s
JOIN sightings si ON s.species_id = si.species_id
GROUP BY s.common_name;

-- Example 4: List the common names of species and the total number of squirrels sighted for each habitat
SELECT h.habitat_name, s.common_name, SUM(si.count) AS total_sighted
FROM habitats h
JOIN sightings si ON h.habitat_id = si.habitat_id
JOIN species s ON si.species_id = s.species_id
GROUP BY h.habitat_name, s.common_name;

-- Example 5: Find the common names of squirrel species sighted in a specific habitat (e.g., "Forest")
SELECT s.common_name
FROM species s
JOIN sightings si ON s.species_id = si.species_id
JOIN habitats h ON si.habitat_id = h.habitat_id
WHERE h.habitat_name = 'Forest'
GROUP BY s.common_name;

-- Example 6: Retrieve the species that have never been sighted
SELECT s.common_name
FROM species s
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

-- Example 7: Calculate the average number of squirrels sighted per sighting for each species
SELECT s.common_name, AVG(si.count) AS average_sighted
FROM species s
JOIN sightings si ON s.species_id = si.species_id
GROUP BY s.common_name;

-- Example 8: Find the habitats where the total number of squirrels sighted is greater than 20
SELECT h.habitat_name, SUM(si.count) AS total_sighted
FROM habitats h
JOIN sightings si ON h.habitat_id = si.habitat_id
GROUP BY h.habitat_name
HAVING SUM(si.count) > 20;

-- Example 9: List all species and their corresponding habitats
SELECT s.common_name, h.habitat_name
FROM species s
JOIN sightings si ON s.species_id = si.species_id
JOIN habitats h ON si.habitat_id = h.habitat_id
GROUP BY s.common_name, h.habitat_name;

-- Example 10: Find the species sighted in the most different habitats
SELECT s.common_name, COUNT(DISTINCT si.habitat_id) AS num_habitats
FROM species s
JOIN sightings si ON s.species_id = si.species_id
GROUP BY s.common_name
ORDER BY num_habitats DESC
LIMIT 1;
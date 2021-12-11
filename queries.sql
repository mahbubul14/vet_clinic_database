/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE (neutered = true and escape_attempts < 3);
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu' );
SELECT (name, escape_attempts) FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;
    -- update the animals table by setting the species column to unspecified. 
UPDATE animals SET species = 'unspecified';
-- Verify that change was made. Then roll back the change and verify that species columns went back to the state before transaction.
SELECT * FROM public.animals;
ROLLBACK;
SELECT * FROM public.animals;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species is NULL;

SELECT * FROM public.animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01'::DATE;
SAVEPOINT sv1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO sv1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(name) FROM animals;
--  How many animals have never tried to escape?
SELECT COUNT(escape_attempts) FROM animals where escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT max(escape_attempts), neutered FROM animals GROUP BY animals.neutered;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, min(weight_kg), max(weight_kg) FROM animals GROUP BY animals.species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT AVG(escape_attempts) FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000;

-- What animals belong to Melody Pond?
SELECT name FROM animals 
JOIN owners ON animals.owners_id = owners.id 
WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name , species.name AS species_type FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT animals.name AS animal_name, owners.full_name AS owner_name FROM owners
LEFT JOIN animals ON owners.id = animals.owners_id;
-- How many animals are there per species?
SELECT species.name as species_type , COUNT(*) from animals
JOIN species ON species.id = animals.species_id
GROUP BY species_type;
-- List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS owners_name,
        animals.name AS animal_name,
        species.name AS type
FROM animals
JOIN species ON species.id = animals.species_id
JOIN owners ON owners.id = animals.owners_id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name AS animal_name FROM animals
JOIN owners ON owners.id = animals.owners_id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT owners.full_name as owners_name , COUNT(animals.name) as animal_count from owners
LEFT JOIN animals ON owners.id = animals.owners_id
GROUP BY owners_name
 ORDER BY animal_count DESC;
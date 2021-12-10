/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id                INT GENERATED ALWAYS AS IDENTITY,
  name              VARCHAR(100),
  date_of_birth     DATE,
  escape_attempts   INT,
  neutered          BOOLEAN,
  weight_kg         NUMERIC,
  PRIMARY KEY(id)   
);

-- Vet clinic database: query and update animals table

ALTER TABLE animals
ADD COLUMN species VARCHAR;

CREATE TABLE  owners (
  id:               INT GENERATED ALWAYS AS IDENTITY,
  full_name:        VARCHAR(50),
  age:              INT,
  PRIMARY KEY(id)  
);

CREATE TABLE  species (
  id:               INT GENERATED ALWAYS AS IDENTITY,
  name:        VARCHAR(50),
  PRIMARY KEY(id)  
);

------ SUBMITTED BY: KHALID AHMED
------ SUBMITTED TO: SIR USMAN GHANI
------ ROLL NO: S23BDOCS1M01003


--- AFTER IMPORTING university_professors table in PgAdmin database
SELECT * from 
university_professors

-- in this query we can see our schema's tables and their names
-- like university_professors table is in public schema
select table_schema, table_name
FROM information_schema.tables
where table_name = 'pg_config'

select table_name, column_name, data_type
FROM information_schema.columns
where table_name = 'university_professors'

-- AS we can see our current table has Redundancy
SELECT *
FROM university_professors
LIMIT 5;

-- Counting all rows we have 1377 records
SELECT COUNT(*)
FROM university_professors

-- But distinct organizations are only  1287 so there is redundancy
SELECT COUNT(DISTINCT organization)
FROM university_professors

-- NOW WE ARE CREATING OUR TABLES FOR EACH ENTITY
CREATE TABLE organizations(
	organization TEXT,
	organization_sector TEXT
);

CREATE TABLE professors(
	firstname TEXT,
	lastname TEXT,
	university_shortname TEXT
);

CREATE TABLE universities(
	university TEXT,
	university_shortname TEXT,
	university_city TEXT
)

CREATE TABLE affiliations(
	organization TEXT,
	function TEXT,
	firstname TEXT,
	lastname TEXT,
	university_shortname TEXT
);

-- If we have problems regarding spelling mistake so we will ALTER it
ALTER TABLE affiliations
RENAME COLUMN old_name TO new_name;

-- AS we can see firstname and lastname does show 551 records
SELECT DISTINCT firstname, lastname
FROM university_professors;

-- and with firstname and lastname, university_shortname still 551 records
SELECT DISTINCT firstname, lastname, university_shortname
FROM university_professors;

-- AS I noticed that firstname and lastname of profeessor does uniquely
-- identify a professor so there is need of university_shortname 
-- in affiliations table.
ALTER TABLE affiliations
DROP COLUMN university_shortname;

-- ****
ALTER TABLE tablename
ALTER COLUMN columname
TYPE VARCHAR(128);
-- ****

SELECT DISTINCT firstname, lastname, function, organization
FROM university_professors

-- Now we will copy our records in our tables.
INSERT INTO affiliations
SELECT DISTINCT organization, function, firstname, lastname
FROM university_professors

SELECT * 
FROM affiliations

-- INSERT DISTINCT records in organization table
INSERT INTO organizations
SELECT DISTINCT organization, organization_sector
FROM university_professors

SELECT *
FROM organizations;

SELECT DISTINCT firstname, lastname, university_shortname
FROM university_professors

-- INSERTING unique professors records in its table
INSERT INTO professors
SELECT DISTINCT firstname, lastname, university_shortname
FROM university_professors

SELECT DISTINCT firstname, lastname, university_shortname
FROM professors;

SELECT DISTINCT university, university_shortname, university_city
FROM university_professors;

INSERT INTO universities
SELECT DISTINCT university, university_shortname, university_city
FROM university_professors

-- AFTER INSERTING all records in their specific TABLES
-- we are going to drop university_professors TABLE
DROP TABLE university_professors;


-------- **** AFTER ALL THIS THE CONSTRAINTS SECTION **** -----------
SELECT DISTINCT university_shortname 
FROM professors

-- AS we can see the university_shorname is consist of only 3 characters
ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE char(3);

ALTER TABLE professors
ALTER COLUMN firstname
TYPE VARCHAR(64)

-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16);


-- Now we will add UNIQUE constraint to our university_shortname
-- that we make sure there is no duplicate values in univeristy_shortname
ALTER TABLE universities
ADD CONSTRAINT unishortunq UNIQUE(university_shortname)

-- Add NOTNULL constraint to firstname in professors
ALTER TABLE professors
ALTER COLUMN firstname
SET NOT NULL;

ALTER TABLE professors
ALTER COLUMN lastname
SET NOT NULL;

-- Making sure Organizations are unique
ALTER TABLE organizations
ADD CONSTRAINT organization_unique UNIQUE(organization);


-- ********** KEYS AND SUPERKEYS ************ --

SELECT COUNT(*)
FROM organizations

SELECT COUNT(DISTINCT(organization)) -- SUPER KEY in Organizations
FROM organizations;

----------
SELECT COUNT(*)
FROM professors

SELECT COUNT(DISTINCT(firstname, lastname)) -- SUPER KEY in professors
FROM professors;

-------------
SELECT COUNT(*)
FROM universities

SELECT COUNT(DISTINCT(university_city)) -- this is not a SUPER KEY
FROM universities;

SELECT COUNT(DISTINCT(university, university_shortname)) -- SUPER KEY
FROM universities;

SELECT COUNT(DISTINCT(university_shortname)) -- CANDIDATE KEY
FROM universities;

SELECT COUNT(DISTINCT(university)) -- CANDIDATE KEY
FROM universities;

SELECT COUNT(DISTINCT(university_shortname)) -- PRIMARY KEY
FROM universities;

SELECT COUNT(DISTINCT(university)) -- ALTERNATIVE KEY
FROM universities;

-----------------
SELECT COUNT(*)
FROM affiliations

SELECT COUNT(DISTINCT(organization, function, lastname)) -- SUPER KEY
FROM affiliations

-----------------
-- AFTER SPECIFYING primary keys making primary keys
-- organizations PRIMARY KEY
ALTER TABLE organizations
RENAME COLUMN organization TO id;

ALTER TABLE organizations
ADD CONSTRAINT organization_primary_key PRIMARY KEY(id);


------ universiteis PRIMARY KEY
ALTER TABLE universities
RENAME COLUMN university_shortname TO id;

ALTER TABLE universities
ADD CONSTRAINT uni_primary_key PRIMARY KEY (id)


----- ******* SURROGATE KEY ******* ------
-- Surrogate key used for identifying records that there is no primary key
-- We can use surroage key by adding a key and Concatinating it with other columns
-- Also it is used in serial 
-- like in professors table it is possible that there may be professor with firstname and lastname same in a university so we give it ID primary that make it unique with its ID key.
-- in universitites key it is not possible that a university or organization have same name so there no need of surroage key

ALTER TABLE professors
ADD COLUMN id SERIAL;

ALTER TABLE professors
ADD CONSTRAINT professor_primary_key PRIMARY KEY (id);

-- UPDATE professors
-- SET id = CONCAT(firsntame, lastname);

------ ****** FOREIGN KEY ONE TO N RELATIONSHIP ********** ------
-- Now we will reference the professor that each professor should have university
-- Without a university we cant add professors.
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

-- REFERENCING professors with universities with the help of ID
ALTER TABLE professors
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);




-- **** RELATED QUERIES
SELECT professors.lastname, universities.id, universities.university_city
FROM professors
JOIN universities
ON professors.university_id = universities.id
WHERE universities.university_city = 'Zurich';



------ **** FOREIGN KEY N-M RELATIONSHIP **** -------
-- now we have to reference professor_id
ALTER TABLE affiliations
ADD COLUMN professor_id INTEGER REFERENCES professors(id);

ALTER TABLE affiliations
RENAME organization to organization_id;

--Adding foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id);


-- Set professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname 
AND affiliations.lastname = professors.lastname;

SELECT * FROM affiliations
LIMIT 10;

-- AFTER REFERENCES we drop our firstname and lastname to remove deduncy
ALTER TABLE affiliations
DROP COLUMN firstname;

ALTER TABLE affiliations
DROP COLUMN lastname;

-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right foreign key constraint
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_fkey;


-- Add a new foreign key constraint from affiliations to organizations which cascades deletion
ALTER TABLE affiliations
Add CONSTRAINT affiliations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id) 
ON DELETE CASCADE;


-- Delete an organization 
-- DELETE FROM organizations 
-- WHERE id = 'CUREM';

-- Check that no more affiliations with this organization exist
-- SELECT * FROM affiliations
-- WHERE organization_id = 'CUREM';





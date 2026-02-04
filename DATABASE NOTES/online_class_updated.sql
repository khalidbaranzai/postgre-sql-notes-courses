--Referential integrity
CREATE TABLE Cars (
    License_number VARCHAR(20) PRIMARY KEY,
    Make VARCHAR(20),
    Model VARCHAR(20),
    Year INT
);


CREATE TABLE Car_Owners (
    Owner_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    License_number VARCHAR(20),
    FOREIGN KEY (License_number) REFERENCES Cars(License_number)
);

INSERT INTO Cars (License_number, Make, Model, Year)
VALUES
('TX-1234', 'Ford', 'Mustang', 2020),
('CA-5678', 'Toyota', 'Camry', 2021),
('NY-9101', 'Honda', 'Civic', 2019);

INSERT INTO Car_Owners (Owner_ID, Name, License_number)
VALUES
(1, 'Alice', 'TX-1234'),
(2, 'Bob', 'CA-5678'),
(3, 'Charlie', 'NY-9101');

SELECT * FROM Cars
SELECT * FROM Car_Owners

DELETE FROM Cars WHERE License_number = 'TX-1234';

--ALTER TABLE Cars
--ALTER COLUMN License_number
--DROP FOREIGN KEY License_number
--solution????

--FOREIGN KEY (License_number) REFERENCES Cars(License_number) ON DELETE CASCADE
--How to update car table to fullfill 
--the criteria

-- I WANT TO SEE CONSTRAINT NAME
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid='Car_Owners'::regclass AND contype='f'


--Deleting constraint
ALTER TABLE Car_Owners
DROP CONSTRAINT car_owners_license_number_fkey

ALTER TABLE Car_Owners
ADD CONSTRAINT fk_license FOREIGN KEY(License_number) REFERENCES Cars(License_number) ON DELETE CASCADE

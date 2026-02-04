--what movies 
SELECT language, certification, COUNT(title) AS title_count
FROM films
GROUP BY certification, language;

SELECT certification 
FROM films

CREATE TABLE students(
rollnumber INT PRIMARY KEY, 
name varchar(20),
dept varchar(5),
district varchar(10));


INSERT INTO students 
VALUES(2,'zohaib','IT','bwp'),
(3,'zohaib','CS','RYK'),
(4,'Farhan','DS','RYK'),
(5,'usman','AI','BWP'),
(6,'mustafa','IT','RYK'),
(7,'mustafa','IT','BWP');
SELECT *FROM students

UPDATE students SET district='BWP'
WHERE district='bwp'

UPDATE students SET dept='CS'
WHERE dept='cs'

--show me district wise student enrollment

SELECT district ,COUNT(rollnumber) as student_strength
FROM students
GROUP BY district


--show in decending order
SELECT district ,COUNT(rollnumber) as student_strength
FROM students
GROUP BY district 
ORDER BY student_strength 


--GROUP WITH MULTIPLE FIELD
--deparment and student wise grouping, i want to see how many students
--from different areas belong to different department

SELECT district,dept ,COUNT(rollnumber) as student_strength
FROM students
GROUP BY district, dept 
ORDER BY student_strength 

-- Load data

DROP TABLE IF EXISTS STUDENTS, GRADES;

CREATE TABLE STUDENTS (
    ID INT,
    Name VARCHAR(255),
    Marks INT
);

CREATE TABLE GRADES (
    Grade INT,
    Min_Mark INT,
    Max_Mark INT
);

INSERT INTO STUDENTS
    (ID, Name, Marks)
VALUES
    (19, "Samantha", 87),
    (21, "Julia", 96),
    (11, "Britney", 95),
    (32, "Kristeen", 100),
    (12, "Dyana", 55),
    (13, "Jenny", 66),
    (14, "Christene", 88),
    (15, "Meera", 24),
    (16, "Priya", 76),
    (17, "Priyanka", 77),
    (18, "Paige", 74),
    (19, "Jane", 64),
    (21, "Belvet", 78),
    (31, "Scarlet", 80),
    (41, "Salma", 81),
    (51, "Amanda", 34),
    (61, "Heraldo", 94),
    (71, "Stuart", 99),
    (81, "Aamina", 77),
    (76, "Amina", 89),
    (91, "Vivek", 84);

INSERT INTO GRADES
    (Grade, Min_Mark, Max_Mark)
VALUES
    (1, 0, 9),
    (2, 10, 19),
    (3, 20, 29),
    (4, 30, 39),
    (5, 40, 49),
    (6, 50, 59),
    (7, 60, 69),
    (8, 70, 79),
    (9, 80, 89),
    (10, 90, 100);

SELECT * FROM STUDENTS;

SELECT * FROM GRADES;


-- Question

/*
Ketty gives Eve a task to generate a report containing three columns: Name,
Grade and Mark. Ketty doesn't want the NAMES of those students who received a
grade lower than 8. The report must be in descending order by grade -- i.e.
higher grades are entered first. If there is more than one student with the
same grade (8-10) assigned to them, order those particular students by their
name alphabetically. Finally, if the grade is lower than 8, use "NULL" as
their name and list them by their grades in descending order. If there is
more than one student with the same grade (1-7) assigned to them, order
those particular students by their marks in ascending order.

Write a query to help Eve.
*/

-- Solution

/*
    Do range based join
    Replace name with NULL when Grade < 8
    Order by descending grade
    Order by ascending name
    Order by descending marks
*/

SELECT
    CASE WHEN g.Grade < 8 THEN 'NULL' else s.Name END name,
    Grade,
    Marks
FROM
    STUDENTS s
LEFT JOIN
    GRADES g
ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC, s.Name ASC, s.Marks ASC;
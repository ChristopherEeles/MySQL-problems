-- Create the sample data
DROP TABLE Occupations;

CREATE TABLE Occupations (
    Name VARCHAR(255),
    Occupation VARCHAR(255)
);


INSERT INTO Occupations
    (Name, Occupation)
VALUES
    ("Ashley", "Professor"),
    ("Samantha", "Actor"),
    ("Julia", "Doctor"),
    ("Britney", "Professor"),
    ("Maria", "Professor"),
    ("Meera", "Professor"),
    ("Priya", "Doctor"),
    ("Priyanka", "Professor"),
    ("Jennifer", "Actor"),
    ("Ketty", "Actor"),
    ("Belvet", "Professor"),
    ("Naomi", "Professor"),
    ("Jane", "Singer"),
    ("Jenny", "Singer"),
    ("Kristeen", "Singer"),
    ("Christeen", "Singer"),
    ("Eve", "Actor"),
    ("Aamina", "Doctor");

SELECT * FROM Occupations;

-- Vanilla solution
WITH rn AS
    (SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name ASC) AS "row_num"
    FROM Occupations o)
SELECT
    MAX(CASE WHEN Occupation = "Doctor" THEN Name ELSE NULL END) AS Doctor,
    MAX(CASE WHEN Occupation = "Professor" THEN Name ELSE NULL END) AS Professor,
    MAX(CASE WHEN Occupation = "Singer" THEN Name ELSE NULL END) AS Singer,
    MAX(CASE WHEN Occupation = "Actor" THEN Name ELSE NULL END) AS Actor
FROM rn
GROUP BY row_num
ORDER BY row_num;
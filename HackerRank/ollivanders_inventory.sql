-- Load data

DROP IF TABLE EXISTS Wands, Wands_Property;

CREATE TABLE Wands (
    id INT,
    code INT,
    coins_needed INT,
    `power` INT
);

CREATE TABLE Wands_Property (
    code INT,
    age INT,
    is_evil INT
);

LOAD DATA INFILE
    "wands.csv"
INTO TABLE
    Wands
FIELDS TERMINATED BY ",";

LOAD DATA INFILE
    "wands_property.csv"
INTO TABLE
    Wands_Property
FIELDS TERMINATED BY ",";

-- Question

/*
Harry Potter and his friends are at Ollivander's with Ron, finally replacing
Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum number
of gold galleons needed to buy each non-evil wand of high power and age. Write
a query to print the id, age, coins_needed, and power of the wands that Ron's
interested in, sorted in order of descending power. If more than one wand has
same power, sort the result in order of descending age.
*/

-- Solution

/*
    - Join Wands and Wands_Property
    - Filter to minimum coins needed by power and age
    - Select id, age, coins_needed, power
    - Sort descending power and age
    - Filter non-evil
*/

/* This works locally but errors on HackerRank.

Maybe SQL version issue?
- Yes, HackerRank version is 5.7 but CTEs added in >= 8.0
 */
SELECT
    ne.id,
    ne.age,
    ne.coins_needed,
    ne.power
FROM
    (SELECT
        w.id,
        wp.age,
        w.coins_needed,
        w.`power`,
        MIN(w.coins_needed) OVER(
            PARTITION BY w.`power`, wp.age
            ORDER BY w.`power`, wp.age
        ) as min_coins
    FROM Wands w
    LEFT JOIN Wands_Property wp ON
        w.code = wp.code
    WHERE NOT wp.is_evil) AS ne
WHERE ne.coins_needed = ne.min_coins
ORDER BY ne.power DESC, ne.age DESC;

/* Non-window function solution

Still doesn't work?!

Maybe SQL version issue?
- Yes, HackerRank version is 5.7 but CTEs added in >= 8.0
 */

WITH non_evil_wands AS
    (SELECT w.id, wp.age, w.coins_needed, w.power
    FROM Wands w
    LEFT JOIN Wands_Property wp ON
        w.code = wp.code
    WHERE NOT wp.is_evil)
SELECT ne.id, ne.age, ne.coins_needed, ne.power
FROM non_evil_wands ne
LEFT JOIN
    (SELECT ne.age, ne.power, MIN(ne.coins_needed) min_coins
    FROM non_evil_wands ne
    GROUP BY ne.age, ne.power
    ) nc
ON
    ne.age = nc.age and
    ne.power = nc.power
WHERE ne.coins_needed = nc.min_coins
ORDER BY ne.power DESC, ne.age DESC;

/* Non-window functions and no CTEs, Works!*/

SELECT ne.id, ne.age, ne.coins_needed, ne.power
FROM
    (SELECT w.id, wp.age, w.coins_needed, w.power
    FROM Wands w
    LEFT JOIN Wands_Property wp ON
        w.code = wp.code
    WHERE NOT wp.is_evil) ne
LEFT JOIN
    (SELECT wp.age, w.power, MIN(w.coins_needed) as min_coins
    FROM Wands w
    LEFT JOIN Wands_Property wp ON
        w.code = wp.code
    WHERE NOT wp.is_evil
    GROUP BY wp.age, w.power) mc
USING (age, power)
WHERE ne.coins_needed = mc.min_coins
ORDER BY ne.power DESC, ne.age DESC;
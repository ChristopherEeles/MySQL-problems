-- Load data

DROP TABLE IF EXISTS Hackers, Challenges;

CREATE TABLE Hackers (
    hacker_id INT,
    `name` VARCHAR(255)
);

CREATE TABLE Challenges (
    challenge_id INT,
    hacker_id INT
);

LOAD DATA INFILE "Hackers.csv"
INTO TABLE Hackers
FIELDS TERMINATED BY ",";

LOAD DATA INFILE "Challenges.csv"
INTO TABLE Challenges
FIELDS TERMINATED BY ",";


-- Question

/*
Julia asked her students to create some coding challenges. Write a query to
print the hacker_id, name, and the total number of challenges created by each
student. Sort your results by the total number of challenges in descending
order. If more than one student created the same number of challenges, then
sort the result by hacker_id. If more than one student created the same number
of challenges and the count is less than the maximum number of challenges
created, then exclude those students from the result.


Hackers:
    hacker_id: INT
    name: VARCHAR

Challenges:
    challenge_id: INT
    hacker_id: INT
*/

-- Solution

/*
    - Join Hackers and Challenges
    - Select hacker_id, name, total number of challanges created per student
    - Sort by number of challenges descending, hacker_id ascending
    - Filter duplicated challenge numbers if not the maximum
*/


-- Using CTEs (not available on HackerRank)

-- 1. Join the tables and aggregate to get counts per hacker
WITH challenge_counts AS
    (SELECT
        h.hacker_id,
        h.name,
        COUNT(DISTINCT(c.challenge_id)) as nchallenge
    FROM
        Hackers h
    JOIN
        Challenges c
    USING (hacker_id)
    GROUP BY h.hacker_id, h.name)
-- 2. Select columns of interest from the temporary count table
SELECT
    cc.hacker_id,
    cc.name,
    cc.nchallenge
FROM challenge_counts cc
-- 3. Filter to results with no duplicates or the maximum count
WHERE cc.nchallenge IN
    (SELECT DISTINCT(cc1.nchallenge)
    FROM challenge_counts cc1
    -- get number of hackers per challenge count via group by
    GROUP BY cc1.nchallenge
    HAVING
        -- filter no duplicates within group
        COUNT(*) = 1 OR
        -- except for duplicates of maximum count
        cc1.nchallenge = (SELECT MAX(nchallenge) FROM challenge_counts)
    )
-- 4. Sort the table as outlined above
ORDER BY cc.nchallenge DESC, cc.hacker_id;

-- Using subqueries

SELECT
    cc.hacker_id,
    cc.name,
    cc.nchallenge
FROM
    (SELECT -- challenge_count table
        h.hacker_id,
        h.name,
        COUNT(DISTINCT(c.challenge_id)) as nchallenge
    FROM
        Hackers h
    JOIN
        Challenges c
    USING (hacker_id)
    GROUP BY h.hacker_id, h.name) cc
WHERE cc.nchallenge IN
    (SELECT DISTINCT(cc1.nchallenge)
    FROM
        (SELECT -- challenge_count table again!
            h.hacker_id,
            h.name,
            COUNT(DISTINCT(c.challenge_id)) as nchallenge
        FROM
            Hackers h
        JOIN
            Challenges c
        USING (hacker_id)
        GROUP BY h.hacker_id, h.name) cc1
    GROUP BY cc1.nchallenge
    HAVING COUNT(*) = 1 OR cc1.nchallenge =
        (SELECT MAX(cc2.nchallenge) FROM
            (SELECT -- challenge_count table one more time!
                h.hacker_id,
                h.name,
                COUNT(DISTINCT(c.challenge_id)) as nchallenge
            FROM
                Hackers h
            JOIN
                Challenges c
            USING (hacker_id)
            GROUP BY h.hacker_id, h.name) cc2
        )
    )
ORDER BY cc.nchallenge DESC, cc.hacker_id;
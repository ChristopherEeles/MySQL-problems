-- Load data

DROP TABLE IF EXISTS Hackers, Submissions;

CREATE TABLE Hackers (
    hacker_id INT,
    `name` VARCHAR(255)
);

CREATE TABLE Submissions (
    submission_id INT,
    hacker_id INT,
    challenge_id INT,
    score INT
);

LOAD DATA INFILE "Hackers.contest_leaderboard.csv"
INTO TABLE Hackers
FIELDS TERMINATED BY ",";

LOAD DATA INFILE "Submissions.contest_leaderboard.csv"
INTO TABLE Submissions
FIELDS TERMINATED BY ",";

-- Question

/*
You did such a great job helping Julia with her last coding contest challenge
that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all of the
challenges. Write a query to print the hacker_id, name, and total score of the
hackers ordered by the descending score. If more than one hacker achieved the
same total score, then sort the result by ascending hacker_id. Exclude all
hackers with a total score of 0 from your result.
*/

-- Solution

/*
    - Sum maximum scores for all challenges
    - Select hacker_id, name, total score
    - Order by total score descending
    - Order by hacker_id ascending
    - Exclude hackers with total score of zero
*/

-- 0.0 Check for duplicated scores per hacker per challenge


-- 1.0 Join the tables and select best score for each hacker per challenge
SELECT
    h.hacker_id,
    h.name,
    s.challenge_id,
    MAX(s.score) as best_score
FROM
    Hackers h
JOIN
    Submissions s
USING (hacker_id)
GROUP BY
    h.hacker_id, h.name, s.challenge_id

# -- 2.0 Sum the best scores
SELECT
    bs.hacker_id,
    bs.name,
    SUM(bs.best_score) AS total_score
FROM
    (SELECT
        h.hacker_id,
        h.name,
        s.challenge_id,
        MAX(s.score) as best_score
    FROM
        Hackers h
    JOIN
        Submissions s
    USING (hacker_id)
    GROUP BY
        h.hacker_id, h.name, s.challenge_id) bs
GROUP BY
    bs.hacker_id,
    bs.name
HAVING
    total_score > 0
ORDER BY
    total_score DESC,
    hacker_id ASC;

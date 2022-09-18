-- Question

/*
Julia just finished conducting a coding contest, and she needs your help
assembling the leaderboard!

Write a query to print the respective hacker_id and name of hackers who
achieved full scores for more than one challenge.

Order your output in descending order by the total number of challenges in
which the hacker earned a full score.

If more than one hacker received full scores in same number of challenges,
then sort them by ascending hacker_id.
*/

-- Solution

/*
    Join all the tables to Submissions
    Select hacker_id and name
    Count number of top scores by hacker_id
    Order by numer of perfect scores then hacker_id
*/

SELECT
    s.hacker_id,
    h.name
FROM
    Submissions s
LEFT JOIN Challenges c ON
    s.challenge_id = c.challenge_id
LEFT JOIN Hackers h ON
    s.hacker_id = h.hacker_id
LEFT JOIN Difficulty d ON
    c.difficulty_level = d.difficulty_level
WHERE s.score = d.score
GROUP BY s.hacker_id, h.name
HAVING COUNT(s.hacker_id) > 1
ORDER BY COUNT(s.hacker_id) DESC, s.hacker_id;
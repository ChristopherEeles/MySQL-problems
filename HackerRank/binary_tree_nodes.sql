-- Create data
DROP TABLE IF EXISTS BST;

CREATE TABLE BST (
    N INT,
    P INT
);

INSERT INTO BST
    (N, P)
VALUES
    (1, 2),
    (3, 2),
    (5, 6),
    (7, 6),
    (2, 4),
    (6, 4),
    (4, 15),
    (8, 9),
    (10, 9),
    (12, 13),
    (14, 13),
    (9, 11),
    (13, 11),
    (11, 15),
    (15, NULL);

SELECT * FROM BST;

-- Question

/*
You are given a table, BST, containing two columns: N and P, where N
represents the value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the value of
the node. Output one of the following for each node:
    Root: If node is root node.
    Leaf: If node is leaf node.
    Inner: If node is neither root nor leaf node.
*/

-- Solution

/*
Root node has no parent
Inner node has and is parent
Leaf nodes is not parent
*/

SELECT
    N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N IN (SELECT P FROM BST) THEN 'Inner'
        ELSE 'Leaf'
    END
FROM
    BST
ORDER BY N;
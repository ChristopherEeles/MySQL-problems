-- Load data

DROP TABLE IF EXISTS STATION;

CREATE TABLE STATION (
    ID INT,
    CITY VARCHAR(21),
    STATE VARCHAR(4),
    LAT_N DECIMAL,
    LONG_W DECIMAL
);

LOAD DATA INFILE
    "weather_observation_station_19.csv"
INTO TABLE
    STATION
FIELDS TERMINATED BY ",";

SELECT * FROM STATION LIMIT 10;

-- Question

/*
A median is defined as a number separating the higher half of a data set from
the lower half. Query the median of the Northern Latitudes (LAT_N) from
STATION and round your answer to decimal places.
*/

-- Solution

/*
    Use row number to find the middle
*/
WITH station_i
AS (SELECT
        *,
        ROW_NUMBER() OVER() as row_num
    FROM
        STATION
    ORDER BY
        LAT_N
    )
SELECT
    ROUND(AVG(LAT_N), 4)
FROM station_i
WHERE row_num BETWEEN
    (SELECT FLOOR((MAX(row_num) + 1) / 2) FROM station_i) AND
    (SELECT FLOOR((MAX(row_num) + 2) / 2) FROM station_i);

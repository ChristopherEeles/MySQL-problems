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
Consider and to be two points on a 2D plane where are the respective minimum
and maximum values of Northern Latitude (LAT_N) and

are the respective minimum and maximum values of Western Longitude (LONG_W)
in STATION.

Query the Euclidean Distance between points and and format your answer to
display decimal digits.

d(p,q) = sqrt(sum((pi - qi))
*/

-- Solution

/*
    Select the minimum and maximum of latitude and longitude
*/
SELECT
    ROUND(SQRT(
        POWER(MIN(LAT_N) - MAX(LAT_N), 2) +
        POWER(MIN(LONG_W) - MAX(LONG_W), 2)
    ), 4) euclidean
FROM
    STATION;

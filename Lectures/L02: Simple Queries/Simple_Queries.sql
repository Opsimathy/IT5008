SELECT first_name, last_name
FROM customers
WHERE country = 'Singapore';

SELECT first_name, last_name,
       email, dob, since,
       customerid, country
FROM customers;

SELECT *
FROM customers;

SELECT name, version
FROM downloads;

SELECT name, version
FROM downloads
ORDER BY name, version;

SELECT name, version
FROM downloads
ORDER BY name ASC;

SELECT name, version
FROM games
ORDER BY price ASC;

SELECT DISTINCT name, version
FROM downloads

SELECT DISTINCT name
FROM games
ORDER BY name ASC;

SELECT DISTINCT name, version
FROM games
ORDER BY price ASC;

SELECT first_name, last_name
FROM customers
WHERE country IN ('Singapore', 'Indonesia')
  AND (dob BETWEEN '2000-01-01' AND '2000-12-01' OR since >= '2016-12-01')
  AND last_name LIKE 'B%';

SELECT DISTINCT price * 1.09 AS gst   -- add GST of 9%
FROM games
ORDER BY gst ASC;

SELECT
  name || ' ' || version AS game,
  ROUND(price * 1.09, 2) AS price
FROM games
WHERE price * 0.09 >= 0.3;

SELECT
  name || ' ' || version AS game,
  price
FROM games
WHERE price * 0.09 < 0.3;

SELECT name || ' ' || version,
  CASE
    WHEN price * 0.09 >= 0.3 THEN ROUND(price * 1.09, 2)
    ELSE price
  END AS price
FROM games;

-------------------------

SELECT first_name, last_name FROM customers
WHERE (country = 'Singapore' OR country = 'Indonesia')
AND ((dob >= '2000-01-01' AND dob <= '2000-12-01') OR since >= '2016-12-01')
AND last_name LIKE 'B%';

SELECT first_name, last_name FROM customers
WHERE country IN ('Indonesia', 'Singapore')
AND last_name LIKE 'B%'
AND (since >= '2016-12-01' OR NOT (dob < '2000-01-01' OR dob > '2000-12-01'));

SELECT first_name, last_name FROM customers
WHERE (country = 'Singapore' OR country = 'Indonesia')
AND (dob BETWEEN '2000-01-01' AND '2000-12-01' OR since >= '2016-12-01')
AND last_name LIKE 'B%';

-------------------------

SELECT name FROM games
WHERE (version = '1.0' OR version = '1.1');

SELECT name FROM games
WHERE version IN ('1.0', '1.1');

SELECT name FROM games
WHERE NOT (version <> '1.0' AND version <> '1.1');

-------------------------
CREATE TABLE example (
  column1 VARCHAR(32),
  column2 NUMERIC
);

INSERT INTO example VALUES
  ('abc', 1),
  ('def', NULL),
  ('ghi', NULL);

SELECT *
FROM example;

SELECT column1, column2
FROM example
WHERE column2 > 0;

SELECT column1, column2
FROM example
WHERE column2 <= 0;

SELECT column1,
  column2 * 0 AS newcolumn2
FROM example;

SELECT column1, column2
FROM example
WHERE column2 <> NULL;

SELECT column1, column2,
  COALESCE(column2, 0) AS col2
FROM example
WHERE column2 = NULL;

SELECT column1, column2,
  COALESCE(column2, 0) AS col2
FROM example
WHERE column2 IS NULL;

SELECT column1, column2,
  (
    CASE WHEN column2 is NULL THEN 0
    ELSE column2 END
  ) AS col2
FROM example;

SELECT COUNT(*) AS ctx
FROM example;

SELECT COUNT(column2) AS ctx
FROM example;

-------------------------

SELECT *
FROM customers, downloads, games;

SELECT *
FROM customers
  CROSS JOIN downloads
  CROSS JOIN games;

SELECT *
FROM customers c, downloads d, games g
WHERE d.customerid = c.customerid
  AND d.name = g.name
  AND d.version = g.version;

SELECT *
FROM customers, downloads, games
WHERE customerid = customerid
  AND name = name
  AND version = version;

SELECT c.email, g.version
FROM customers c, downloads d, games g
WHERE c.customerid = d.customerid
  AND g.name = d.name
  AND g.version = d.version
  AND c.country = 'Indonesia'
  AND g.name = 'Fixflex';

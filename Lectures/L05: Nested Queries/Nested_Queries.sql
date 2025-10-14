-------------------------

CREATE TABLE singapore_customer AS
  SELECT *
  FROM customers c
  WHERE c.country = 'Singapore';

SELECT cs.last_name, d.name
FROM singapore_customer cs, downloads d
WHERE cs.customerid = d.customerid;

-------------------------

CREATE TEMPORARY TABLE singapore_customer AS
  SELECT *
  FROM customers c
  WHERE c.country = 'Singapore';

SELECT c.last_name, d.name
FROM customers c, downloads d
WHERE c.country = 'Singapore'
  AND c.customerid = d.customerid;

-------------------------

CREATE VIEW singapore_customer AS
  SELECT *
  FROM customers c
  WHERE c.country = 'Singapore';

-------------------------

WITH singapore_customer AS
  ( SELECT *
    FROM customers c
    WHERE c.country = 'Singapore' )
SELECT cs.last_name, d.name
FROM singapore_customer cs, downloads d
WHERE cs.customerid = d.customerid;

-------------------------

SELECT cs.last_name, d.name
FROM ( SELECT *
       FROM customers c
       WHERE c.country = 'Singapore' ) AS cs, downloads d
WHERE cs.customerid = d.customerid;

-------------------------

SELECT (
  SELECT COUNT(*) FROM customers c
  WHERE c.country = 'Singapore' );

SELECT COUNT(*)
FROM customers c
WHERE c.country = 'Singapore';

-------------------------

SELECT d.name
FROM downloads d
WHERE d.customerid IN (
    SELECT c.customerid
    FROM customers c
    WHERE c.country = 'Singapore'
);

SELECT d.name
FROM downloads d
WHERE d.customerid = ANY (
    SELECT c.customerid
    FROM customers c
    WHERE c.country = 'Singapore'
);

SELECT g1.name, g1.version, g1.price
FROM games g1
WHERE g1.price >= ALL (
    SELECT g2.price
    FROM games g2
);

-------------------------
SELECT g.name, g.version, g.price
FROM games g WHERE g.price = MAX(g.price)

SELECT g1.name, g1.version, g1.price
FROM games g1
WHERE g1.price = MAX(
  SELECT g2.price FROM games g2
);
-------------------------

SELECT g1.name, g1.version, g1.price
FROM games g1
WHERE g1.price = ALL(
  SELECT MAX(g2.price)
  FROM games g2
);

SELECT d.name
FROM downloads d
WHERE EXISTS (
  SELECT c.customerid
  FROM customers c
  WHERE d.customerid = c.customerid
    AND c.country = 'Singapore'
);

SELECT g1.name, g1.version, g1.price
FROM games g1
WHERE g1.price >= ALL (
    SELECT g2.price
    FROM games g2
    WHERE g1.name = g2.name
);

SELECT c.customerid, d.name
FROM downloads d
WHERE d.customerid IN (
    SELECT c.customerid
    FROM customers c
    WHERE c.country = 'Singapore'
);

SELECT (
    SELECT c.last_name
    FROM customers c
    WHERE c.country = 'Singapore'
      AND d.customerid = c.customerid
  ), d.name
FROM downloads d;

SELECT c.customerid
FROM customers c
WHERE c.customerid NOT IN (
  SELECT d.customerid
  FROM downloads d
);

SELECT c.customerid
FROM customers c
WHERE c.customerid <> ALL (
  SELECT d.customerid
  FROM downloads d
);

SELECT c.customerid
FROM customers c
WHERE NOT EXISTS (
  SELECT d.customer id
  FROM downloads d
  WHERE c.customerid =
        d.customerid
);

SELECT c1.country
FROM customers c1
GROUP BY c1.country
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM customers c2
    GROUP BY c2.country
);

-------------------------

SELECT c.customerid, c.country, SUM(g.price) AS total  -- find total spent by a customer id
FROM customers c, downloads d, games g                 --   need these 3 relations
WHERE c.customerid = d.customerid                      --   to connect c and d
  AND g.name = d.name AND g.version = d.version        --   to connect g and d
GROUP BY c.customerid, c.country                       --   needed to compute sum
HAVING SUM(g.price) >= ALL (                           -- such that the total spent by customer
 SELECT SUM(g2.price) AS total                         --   is greater than all other customer
 FROM customers c2, downloads d2, games g2
 WHERE c2.customerid = d2.customerid
   AND g2.name = d2.name AND g2.version = d2.version
   AND c2.country = c.country                          -- from the same country
 GROUP BY c2.customerid
);

-------------------------

SELECT c.first_name, c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT *
    FROM games g
    WHERE g.name = 'Aerified'
      AND NOT EXISTS (
        SELECT *
        FROM downloads d
        WHERE d.customerid = c.customerid
          AND d.name = g.name
          AND d.version = g.version ));

-------------------------
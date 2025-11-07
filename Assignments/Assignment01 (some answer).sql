/* Matric Number: A0123456S */
/* Q01 */
SELECT t.season, COUNT(r.race)
FROM results r RIGHT JOIN races t
    ON r.race = t.date
    AND r.position_text = 'W'
GROUP BY t.season
HAVING COUNT(r.race) <= ALL
  ( SELECT COUNT(r1.race) cnt
    FROM results r1 RIGHT JOIN races t1
        ON r1.race = t1.date
        AND r1.position_text = 'W'
    GROUP BY t1.season )
ORDER BY t.season ASC


/* Q02 */
SELECT c.name AS constructor,
      (SELECT MIN(rc.season) FROM races rc, results r
      WHERE r.constructor = c.name
        AND rc.date = r.race) AS first,
      (SELECT MAX(rc.season) FROM races rc, results r
      WHERE r.constructor = c.name
        AND rc.date = r.race) AS last
FROM constructors c
WHERE c.name IN (
    SELECT r.constructor
    FROM results r
)
  AND c.name NOT IN (
    SELECT r.constructor
    FROM results r
    WHERE r.position <= 3
)
ORDER BY c.name ASC;


/* Q03 */
SELECT d.forename, d.surname, COALESCE(COUNT(q.position), 0) AS count
FROM drivers d LEFT JOIN qualifyings q
   ON d.forename = q.driver_forename
  AND d.surname = q.driver_surname
  AND q.position = 1
GROUP BY d.forename, d.surname
ORDER BY count DESC, d.surname ASC, d.forename ASC;


/* Q04 */
SELECT r.race, r.driver_forename AS forename,
       r.driver_surname AS surname, q.position AS position
       -- renamed the last column to "position"
       -- as pole actually meant the first position
FROM results r, qualifyings q
WHERE r.race = q.race
  AND r.driver_forename = q.driver_forename
  AND r.driver_surname = q.driver_surname
  AND q.position > 1
  AND r.position = 1
ORDER BY r.race ASC;


/* Q05 */
SELECT rc1.season, r1.driver_forename, r1.driver_surname,
  (SELECT COUNT(*)
   FROM results r3, races rc3
   WHERE r3.race = rc3.date
     AND rc1.season = rc3.season
     AND r1.driver_forename = r3.driver_forename
     AND r1.driver_surname = r3.driver_surname
     AND r3.position = 1) AS wins
FROM results r1, races rc1
WHERE r1.race = rc1.date
GROUP BY rc1.season, r1.driver_forename, r1.driver_surname
HAVING SUM(r1.points) >= ALL (
  SELECT SUM(r2.points) AS points
  FROM results r2, races rc2
  WHERE r2.race = rc2.date AND rc1.season = rc2.season
  GROUP BY rc2.season, r2.driver_forename, r2.driver_surname
)
ORDER BY season ASC;


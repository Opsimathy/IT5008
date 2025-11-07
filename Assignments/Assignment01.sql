/* Matric Number: A0332008U */
/* Q01 */
WITH per_season AS (
    SELECT r.season AS season, COUNT(*) FILTER (WHERE res.position_text = 'W') AS withdrawals
    FROM races r
    LEFT JOIN results res ON res.race = r.date
    GROUP BY r.season
),
min_w AS (
    SELECT MIN(withdrawals) AS m FROM per_season
)
SELECT season, withdrawals AS "count"
FROM per_season
WHERE withdrawals = (SELECT m FROM min_w)
ORDER BY season;

/* Q02 */
SELECT res.constructor AS constructor, MIN(r.season) AS first, MAX(r.season) AS last
FROM results res
JOIN races r ON r.date = res.race
GROUP BY res.constructor
HAVING COUNT(*) FILTER (WHERE res.position BETWEEN 1 AND 3) = 0
ORDER BY constructor;

/* Q03 */
SELECT q.driver_forename AS forename, q.driver_surname AS surname, COUNT(*) FILTER (WHERE q.position = 1) AS "count"
FROM qualifyings AS q
GROUP BY q.driver_forename, q.driver_surname
ORDER BY 3 DESC, 2 ASC, 1 ASC;

/* Q04 */
WITH winners AS (
    SELECT race, driver_forename, driver_surname
    FROM results
    WHERE position = 1
)
SELECT w.race AS race, w.driver_forename AS forename, w.driver_surname AS surname, q.position AS pole
FROM winners w
JOIN qualifyings q ON q.race = w.race AND q.driver_forename = w.driver_forename AND q.driver_surname = w.driver_surname
WHERE q.position <> 1
ORDER BY race;

/* Q05 */
WITH per_driver AS (
    SELECT r.season, res.driver_forename AS forename, res.driver_surname AS surname,
           SUM(res.points) AS points, COUNT(*) FILTER (WHERE res.position = 1) AS wins
    FROM results res
    JOIN races r ON r.date = res.race
    GROUP BY r.season, res.driver_forename, res.driver_surname
),
per_season_max AS (
    SELECT season, MAX(points) AS max_points
    FROM per_driver
    GROUP BY season
)
SELECT pd.season, pd.forename, pd.surname, pd.wins
FROM per_driver pd
JOIN per_season_max m ON m.season = pd.season AND m.max_points = pd.points
ORDER BY pd.season;

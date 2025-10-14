SELECT c.customerid
FROM customers c
WHERE EXTRACT(year FROM AGE(dob)) < 21;

SELECT DISTINCT c.customerid,
  EXTRACT(year FROM AGE(dob)) AS age
FROM customers c
  NATURAL JOIN downloads d
WHERE d.name = 'Domainer';


-- From slide
SELECT DISTINCT c.customerid
FROM customers c NATURAL JOIN downloads d
WHERE d.name = 'Domainer'
  AND EXTRACT(year FROM AGE(dob)) < 21;

-- Alternative
SELECT c.customerid
FROM customers c
WHERE EXTRACT(year FROM AGE(dob)) < 21
INTERSECT
SELECT DISTINCT c.customerid
FROM customers c
  NATURAL JOIN downloads d
WHERE d.name = 'Domainer';


-- Does NOT Work
CREATE TABLE downloads (
  customerid  VARCHAR(16) REFERENCES customers(customerid)
    ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
    CHECK (customerid NOT IN (
      SELECT c.customerid FROM customers c NATURAL JOIN downloads d
      WHERE c.customerid = d.customerid AND d.name = 'Domainer'
      AND EXTRACT(year FROM AGE(dob)) < 21)),
  name        VARCHAR(32),
  version     CHAR(3),
  PRIMARY KEY (customerid, name, version),
  FOREIGN KEY (name, version) REFERENCES games(name, version)
    ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED);

-- Does NOT Work
CREATE ASSERTION r21 CHECK (
  NOT EXISTS (
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = 'Domainer'
      AND EXTRACT(year FROM AGE(dob)) < 21
  ))


CREATE OR REPLACE FUNCTION calculate_age(dob DATE)
RETURNS INTEGER AS $$
DECLARE
  years INTEGER;
BEGIN
  years := EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM dob);
  IF (EXTRACT(month FROM CURRENT_DATE) < EXTRACT(month FROM dob)) OR
     (EXTRACT(month FROM CURRENT_DATE) = EXTRACT(month FROM dob) AND
      EXTRACT(day FROM CURRENT_DATE) < EXTRACT(day FROM dob)) THEN
    years := years - 1;
  END IF;
  RETURN years;
END;
$$ LANGUAGE plpgsql;

SELECT c.customerid,
       calculate_age(c.dob) AS age
FROM customers c
ORDER BY age;

SELECT c.customerid,
       EXTRACT(year FROM AGE(c.dob)) AS age
FROM customers c
ORDER BY age;


CREATE OR REPLACE FUNCTION is_prime(n INT)
RETURNS BOOLEAN AS $$
DECLARE
  k INT;
BEGIN
  IF n < 2 THEN
    RETURN false;
  END IF;
  k := 2;
  WHILE k < n LOOP
    IF n % k = 0 THEN
      RETURN false;
    END IF;
    k := k + 1;
  END LOOP;
  RETURN true;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION is_r21()
RETURNS BOOLEAN AS $$
BEGIN
  IF EXISTS (SELECT * FROM customers c NATURAL JOIN downloads d
             WHERE name = 'Domainer' AND EXTRACT(year FROM AGE(c.dob)) < 21)
  THEN RETURN FALSE;
  ELSE RETURN TRUE;
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT is_r21();


CREATE OR REPLACE PROCEDURE clean_r21()
AS $$  -- no 'RETURNS' keyword
BEGIN
  IF NOT is_r21() THEN
    DELETE FROM downloads d WHERE d.customerid IN (
      SELECT c.customerid FROM customers c NATURAL JOIN downloads d1
      WHERE name = 'Domainer' AND EXTRACT(year FROM AGE(c.dob)) < 21
    );
  END IF;
END;
$$ LANGUAGE plpgsql;

CALL clean_r21();
SELECT is_r21();


CREATE OR REPLACE PROCEDURE download_game(cid VARCHAR(16), gname VARCHAR(32), gver CHAR(3))
AS $$
BEGIN
  INSERT INTO downloads VALUES (cid, gname, gver);
  CALL clean_r21();
END;
$$ LANGUAGE plpgsql;

CALL download_game('Tammy1998', 'Domainer', '2.0');
CALL download_game('JohnnyG89', 'Domainer', '2.0');
SELECT is_r21();

INSERT INTO downloads VALUES ('Tammy1998', 'Domainer', '2.0');
SELECT is_r21();


CREATE OR REPLACE FUNCTION avg1(gname VARCHAR(32))
  RETURNS NUMERIC AS $$
DECLARE cur SCROLL CURSOR (vname VARCHAR(32)) FOR
        SELECT g.price FROM games g WHERE g.name = vname;
  price NUMERIC;  sumprice NUMERIC;  count NUMERIC;
BEGIN
  OPEN cur(vname := gname);
  price := 0;  sumprice := 0;  count := 0;
  LOOP
    FETCH cur INTO price;
    EXIT WHEN NOT FOUND;
    sumprice := sumprice + price;  count := count + 1;
  END LOOP;
  CLOSE cur;
  IF count < 1 THEN RETURN null;
  ELSE RETURN ROUND(sumprice / count, 2);
  END IF;
END; $$ LANGUAGE plpgsql;

SELECT avg1('Aerified');

SELECT ROUND(AVG(g.price), 2) FROM games g
WHERE g.name = 'Aerified';


ALTER TABLE downloads
ADD CONSTRAINT is_r21 CHECK (is_r21());

CALL clean_r21();

ALTER TABLE downloads
ADD CONSTRAINT is_r21 CHECK (is_r21());


SELECT EXTRACT(year FROM AGE(dob)) AS age
FROM customers WHERE customerid = 'Jonathan2000';

INSERT INTO downloads VALUES ('Jonathan2000', 'Domainer', '1.0');

INSERT INTO downloads VALUES ('Jonathan2000', 'Aerified', '1.0');


CALL clean_r21();

ALTER TABLE downloads
DROP CONSTRAINT is_r21;


CREATE OR REPLACE FUNCTION fr21()
RETURNS TRIGGER AS $$ BEGIN
  IF EXISTS (
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = 'Domainer'
      AND EXTRACT (year FROM AGE(c.dob)) < 21
  )
  THEN
    RAISE EXCEPTION 'Underaged!';    -- STOP!
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER tr21
AFTER INSERT OR UPDATE ON downloads
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE PROCEDURE fr21();

CREATE CONSTRAINT TRIGGER tr21
AFTER INSERT OR UPDATE ON customers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE PROCEDURE fr21();

INSERT INTO downloads
VALUES ('Deborah84', 'Domainer', '1.0');

INSERT INTO downloads
VALUES ('Jonathan2000', 'Domainer', '1.0');

UPDATE customers SET dob = '2010-08-01'
WHERE customerid = 'Deborah84';


CREATE OR REPLACE FUNCTION fr21a()
RETURNS TRIGGER AS $$ BEGIN
  IF                       AND EXISTS (
    SELECT c.customerid
    FROM customers c
    WHERE c.customerid = NEW.customerid
      AND EXTRACT (year FROM AGE(c.dob)) < 21
  )
  THEN
    RETURN NULL;  -- Stop! for Before trigger
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER tr21a
BEFORE INSERT OR UPDATE ON downloads
FOR EACH ROW
WHEN NEW.name = 'Domainer'
EXECUTE PROCEDURE fr21a();

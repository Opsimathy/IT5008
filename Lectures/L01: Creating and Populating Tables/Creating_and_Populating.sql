-------------------------

CREATE TABLE downloads (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64),
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16),
  country     VARCHAR(16),
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC
);

-------------------------

CREATE TABLE customers (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64),
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16),
  country     VARCHAR(16)
);

CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC
);

CREATE TABLE downloads (
  customerid  VARCHAR(16),
  name        VARCHAR(32),
  version     CHAR(3)
);

-------------------------

DELETE FROM customers;

DROP TABLE customers;

-------------------------

CREATE TABLE customers (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64),
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16)
    PRIMARY KEY, -- applies to the row
  country     VARCHAR(16)
);

CREATE TABLE customers (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64),
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16),
  country     VARCHAR(16),
  PRIMARY KEY (customerid) -- after row
);

INSERT INTO customers VALUES (
  'Carole',
  'Yoga',
  'cyoga@glarge.org',
  '2002-08-01',
  '2024-08-09',
  'Carole89',
  'France'
);
-- INSERT INTO tries to insert a row

-------------------------

CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC,
  PRIMARY KEY (name, version)
);

INSERT INTO games VALUES
  ('Aerified', '1.0', 5),
  ('Aerified', '1.0', 6);

INSERT INTO games VALUES
  ('Aerified', '1.0', 5),
  ('Aerified', '2.0', 6),
  ('Verified', '1.0', 7);

-------------------------

CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC NOT NULL,
  PRIMARY KEY (name, version)
);

INSERT INTO games (name, version)
  VALUES ('Aerified2', '1.0');

INSERT INTO games VALUES
  ('Aerified2', '1.0', NULL);

-------------------------

CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC NOT NULL
    DEFAULT 1.00,
  PRIMARY KEY (name, version)
);

INSERT INTO games (name, version)
  VALUES ('Aerified2', '1.0');

INSERT INTO games VALUES
  ('Aerified2', '1.0', NULL);

-------------------------

CREATE TABLE customers (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64) UNIQUE,
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16),
  country     VARCHAR(16),
  UNIQUE (first_name, last_name)
);

-------------------------

CREATE TABLE customers (
  first_name  VARCHAR(64),
  last_name   VARCHAR(64),
  email       VARCHAR(64),
  dob         DATE,
  since       DATE,
  customerid  VARCHAR(16) PRIMARY KEY,
  country     VARCHAR(16)
);
CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC,
  PRIMARY KEY (name, version)
);

CREATE TABLE downloads (
  customerid  VARCHAR(16)
    REFERENCES customers (customerid),
  name        VARCHAR(32),
  version     CHAR(3),
  FOREIGN KEY (name, version)
    REFERENCES games (name, version)
);

INSERT INTO downloads VALUES
  ('Adam1983', 'Aerified', '1.0');
-- ('Adam1983') is not in customers

INSERT INTO downloads VALUES
  ('Carole89', 'Aerified', '1.1');
-- ('Aerified', '1.1') is not in games

INSERT INTO downloads VALUES
  (NULL, 'Aerified', '1.0');
-- Allow (NULL) for (customerid)

INSERT INTO downloads VALUES
  ('Carole89', NULL, '1.1');
-- Allow (NULL, '1.1') for (name, version)

INSERT INTO downloads VALUES
  (NULL, 'Aerified', '1.1');
-- Check BOTH

INSERT INTO downloads VALUES
  ('Adam1983', NULL, '1.1');
-- Check BOTH

DELETE FROM customers
  WHERE country='France';

-------------------------

CREATE TABLE games (
  name        VARCHAR(32),
  version     CHAR(3),
  price       NUMERIC NOT NULL
    CHECK (price > 0),
  PRIMARY KEY (name, version)
);

UPDATE games
  SET price = price - 5.5;

-------------------------

CREATE TABLE downloads (
  customerid  VARCHAR(16)
    REFERENCES customers (customerid),
  name        VARCHAR(32),
  version     CHAR(3),
  FOREIGN KEY (name, version)
    REFERENCES games (name, version)
);

-------------------------

CREATE TABLE downloads (
  customerid  VARCHAR(16)
    REFERENCES customers (customerid)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  name        VARCHAR(32),
  version     CHAR(3),
  FOREIGN KEY (name, version)
    REFERENCES games (name, version)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-------------------------

SELECT *
FROM customers;

SELECT *
FROM games;

SELECT *
FROM downloads;


/*
  Uncorrelated
*/

-- CASE 1

CREATE TABLE customers (
  customerid	VARCHAR(16) PRIMARY KEY,
  country		VARCHAR(16) NOT NULL
);

INSERT INTO customers VALUES ('Deborah84', 'Singapore');
INSERT INTO customers VALUES ('JohnnyG89', 'Malaysia');
INSERT INTO customers VALUES ('Tammy1998', 'Singapore');
INSERT INTO customers VALUES ('RebeccaG84', 'Malaysia');
INSERT INTO customers VALUES ('StephenS86', 'Vietnam');


CREATE TABLE downloads (
  customerid VARCHAR(16) REFERENCES customers(customerid) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  name VARCHAR(32),
  version CHAR(3),
  PRIMARY KEY (customerid, name, version)
);

INSERT INTO downloads VALUES ('Deborah84', 'Cookley', '1.1');
INSERT INTO downloads VALUES ('Deborah84', 'Fintone', '1.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Aerified', '2.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Flexidy', '1.1');
INSERT INTO downloads VALUES ('StephenS86', 'Span', '2.0');
INSERT INTO downloads VALUES ('Tammy1998', 'Hatity', '2.1');

-- CODE
SELECT d.name
FROM downloads d
WHERE d.customerid IN (
    SELECT c.customerid FROM customers c
    WHERE c.country = 'Singapore'
);



-- CASE 2

CREATE TABLE customers (
  customerid	VARCHAR(16) PRIMARY KEY,
  country		VARCHAR(16) NOT NULL
);

INSERT INTO customers VALUES ('Deborah84', 'Singapore');
INSERT INTO customers VALUES ('JohnnyG89', 'Malaysia');
INSERT INTO customers VALUES ('Tammy1998', 'Singapore');
INSERT INTO customers VALUES ('RebeccaG84', 'Malaysia');
INSERT INTO customers VALUES ('StephenS86', 'Vietnam');


CREATE TABLE downloads (
  customerid VARCHAR(16) REFERENCES customers(customerid) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  name VARCHAR(32),
  version CHAR(3),
  PRIMARY KEY (customerid, name, version)
);

INSERT INTO downloads VALUES ('Deborah84', 'Cookley', '1.1');
INSERT INTO downloads VALUES ('Deborah84', 'Fintone', '1.0');
INSERT INTO downloads VALUES ('Deborah84', 'Cookley', '1.2');
INSERT INTO downloads VALUES ('RebeccaG84', 'Aerified', '2.0');
INSERT INTO downloads VALUES ('StephenS86', 'Span', '2.0');
INSERT INTO downloads VALUES ('Tammy1998', 'Hatity', '2.1');

-- CODE
SELECT d.name
FROM downloads d
WHERE d.customerid IN (
    SELECT c.customerid FROM customers c
    WHERE c.country = 'Singapore'
);



/*
  Correlated
*/

-- CASE 1

CREATE TABLE customers (
  customerid	VARCHAR(16) PRIMARY KEY,
  country		VARCHAR(16) NOT NULL
);

INSERT INTO customers VALUES ('Deborah84', 'Singapore');
INSERT INTO customers VALUES ('JohnnyG89', 'Malaysia');
INSERT INTO customers VALUES ('Tammy1998', 'Singapore');
INSERT INTO customers VALUES ('RebeccaG84', 'Malaysia');
INSERT INTO customers VALUES ('StephenS86', 'Vietnam');


CREATE TABLE downloads (
  customerid VARCHAR(16) REFERENCES customers(customerid) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  name VARCHAR(32),
  version CHAR(3),
  PRIMARY KEY (customerid, name, version)
);

INSERT INTO downloads VALUES ('Deborah84', 'Cookley', '1.1');
INSERT INTO downloads VALUES ('Deborah84', 'Fintone', '1.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Aerified', '2.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Flexidy', '1.1');
INSERT INTO downloads VALUES ('StephenS86', 'Span', '2.0');
INSERT INTO downloads VALUES ('Tammy1998', 'Hatity', '2.1');

-- CODE
SELECT d.name
FROM downloads d
WHERE EXISTS (
  SELECT c.customerid
  FROM customers c
  WHERE d.customerid = c.customerid
    AND c.country = 'Singapore'
);



/*
  Universal
*/

-- CASE 1

CREATE TABLE customers (
  customerid	VARCHAR(16) PRIMARY KEY,
  country		VARCHAR(16) NOT NULL
);

INSERT INTO customers VALUES ('Deborah84', 'Singapore');
INSERT INTO customers VALUES ('JohnnyG89', 'Malaysia');
INSERT INTO customers VALUES ('Tammy1998', 'Singapore');

CREATE TABLE games (
  name VARCHAR(32),
  version CHAR(3),
  PRIMARY KEY (customerid, name, version)
);

INSERT INTO games VALUES ('Aerified', '1.0');
INSERT INTO games VALUES ('Flexidy', '1.0');
INSERT INTO games VALUES ('Aerified', '2.0');
INSERT INTO games VALUES ('Flexidy', '2.0');


CREATE TABLE downloads (
  customerid VARCHAR(16) REFERENCES customers(customerid) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  name VARCHAR(32),
  version CHAR(3),
  PRIMARY KEY (customerid, name, version)
);

INSERT INTO downloads VALUES ('Deborah84', 'Cookley', '1.1');
INSERT INTO downloads VALUES ('Deborah84', 'Fintone', '1.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Aerified', '2.0');
INSERT INTO downloads VALUES ('RebeccaG84', 'Flexidy', '1.1');
INSERT INTO downloads VALUES ('StephenS86', 'Span', '2.0');
INSERT INTO downloads VALUES ('Tammy1998', 'Hatity', '2.1');
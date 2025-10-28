/*******************

  Create the schema.

********************/

CREATE TABLE IF NOT EXISTS beans (
  name VARCHAR(16) PRIMARY KEY,
  cultivar VARCHAR(128) NOT NULL,
  region VARCHAR(256) NOT NULL,
  UNIQUE (cultivar, region)
);

CREATE TABLE IF NOT EXISTS drink (
  name VARCHAR(32)
  bean VARCHAR(16) REFERENCES beans(name),
  price NUMERIC NOT NULL CHECK (price > 0),
  PRIMARY KEY (name, bean)
);

CREATE TABLE IF NOT EXISTS branch (
  name VARCHAR(64) PRIMARY KEY,
  address VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS sells (
  drink VARCHAR(32)
  bean VARCHAR(16)
  branch VARCHAR(64) REFERENCES branch(name),
  FOREIGN KEY (drink, bean) REFERENCES drink(name, bean),
  PRIMARY KEY (drink, bean, branch)
);
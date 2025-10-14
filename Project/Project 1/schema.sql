CREATE TABLE IF NOT EXISTS cuisines (
	cuisine VARCHAR(20) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS menu (
	item    VARCHAR(20) PRIMARY KEY,
	price   NUMERIC(10,2) NOT NULL
		CHECK (price > 0),
	cuisine VARCHAR(20)
		REFERENCES cuisines(cuisine)
);

CREATE TABLE IF NOT EXISTS registration (
	date      DATE        NOT NULL,
	time      TIME        NOT NULL,
	phone     CHAR(8)     PRIMARY KEY,
	firstname VARCHAR(20) NOT NULL,
	lastname  VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff (
	staff_id   VARCHAR(20) PRIMARY KEY,
	staff_name VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff_cuisines (
	staff_id VARCHAR(20)
		REFERENCES staff(staff_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	cuisine  VARCHAR(20)
		REFERENCES cuisines(cuisine)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	PRIMARY KEY (staff_id, cuisine)
);

CREATE TABLE IF NOT EXISTS orders (
	date        DATE NOT NULL,
	time        TIME NOT NULL,
	order_id    CHAR(11) NOT NULL,
	payment     VARCHAR(4) NOT NULL
		CHECK (payment = 'card' OR payment = 'cash'),
	card        CHAR(19),
	cardtype    VARCHAR(20),
	item        VARCHAR(20)
		REFERENCES menu(item)
		ON UPDATE CASCADE,
	total_price NUMERIC(10,2) NOT NULL
		CHECK (total_price > 0),
	phone       CHAR(8),
	firstname   VARCHAR(64),
	lastname    VARCHAR(64),
	staff_id    VARCHAR(20)
		REFERENCES staff(staff_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT payment_method CHECK ((payment = 'card' AND card != '' AND cardtype != '')
		OR (payment = 'cash' AND card = '' AND cardtype = ''))
);

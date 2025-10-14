CREATE TABLE IF NOT EXISTS cuisine (
	cuisine     VARCHAR(32) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS menu (
	item        VARCHAR(32) PRIMARY KEY
		CHECK (item <> ''),
	price       NUMERIC     NOT NULL DEFAULT 0
		CHECK (price >= 0),
	cuisine     VARCHAR(32) REFERENCES cuisine (cuisine)
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS staff (
	staff       VARCHAR(32) PRIMARY KEY
		CHECK (staff <> ''),
	staff_name  VARCHAR(32) NOT NULL
		CHECK (staff_name <> '')
);

CREATE TABLE IF NOT EXISTS make (
	staff       VARCHAR(32) REFERENCES staff (staff)
		ON UPDATE CASCADE ON DELETE CASCADE,
	cuisine     VARCHAR(32)  REFERENCES cuisine (cuisine)
		ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (staff, cuisine)
);

CREATE TABLE IF NOT EXISTS registration (
	date        DATE        NOT NULL,
	time        TIME        NOT NULL,
	phone       VARCHAR(20) PRIMARY KEY,
	firstname   VARCHAR(32) NOT NULL,
	lastname    VARCHAR(32) NOT NULL
);


CREATE TABLE IF NOT EXISTS orders (
	date        DATE        NOT NULL,
	time        TIME        NOT NULL,
	order_id    VARCHAR(32) PRIMARY KEY
		CHECK (order_id <> ''),
	payment     VARCHAR(4)  
		CHECK (payment = 'card' OR payment = 'cash'),
	card        VARCHAR(32),     
	cardtype    VARCHAR(32),
	total_price NUMERIC     NOT NULL
		CHECK (total_price >= 0),
	phone       VARCHAR(20),  
	firstname   VARCHAR(64), 
	lastname    VARCHAR(64), 
	FOREIGN KEY	(phone) REFERENCES registration (phone)
		ON UPDATE CASCADE,
	CONSTRAINT payment_method
		CHECK ((payment = 'card' AND card != '' AND cardtype != '') OR
			   (payment = 'cash' AND card = ''  AND cardtype = ''))
);

CREATE TABLE IF NOT EXISTS prepares (
	order_id VARCHAR(32) REFERENCES orders (order_id),
	staff    VARCHAR(32) REFERENCES staff (staff)
		ON UPDATE CASCADE ON DELETE CASCADE,
	item     VARCHAR(32) REFERENCES menu (item)
		ON UPDATE CASCADE,
	qty      NUMERIC
		CHECK (qty >= 1),
	PRIMARY KEY (order_id, staff, item)
);

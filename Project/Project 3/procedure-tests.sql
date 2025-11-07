CREATE TABLE IF NOT EXISTS temp_order (
  date       DATE,
  time       TIME,
  order_id   VARCHAR(256),
  payment    VARCHAR(10),
  card       VARCHAR(256),
  card_type  VARCHAR(256),
  item       VARCHAR(256),
  total_price NUMERIC,
  phone      INTEGER,
  firstname  VARCHAR(256),
  lastname   VARCHAR(256),
  staff      VARCHAR(256)
);
-- \copy temp_order FROM '/Users/opsimath/Downloads/IT5008/Project/csv/order.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
DO $$
DECLARE
  cur CURSOR FOR 
    SELECT * FROM temp_order LIMIT 100;
  rec RECORD;
BEGIN
  OPEN cur;
  LOOP
    FETCH cur INTO rec;
    EXIT WHEN NOT FOUND;
    CALL insert_order_item(
      rec.order_id,
      rec.date,
      rec.time,
      rec.payment,
      rec.card,
      rec.card_type,
      rec.phone,
      rec.item,
      rec.staff
    );
  END LOOP;
  CLOSE cur;
END;
$$ LANGUAGE plpgsql;
DROP TABLE IF EXISTS temp_order;
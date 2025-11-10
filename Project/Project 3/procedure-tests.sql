CREATE TABLE IF NOT EXISTS temp_order (
  date        DATE,
  time        TIME,
  order_id    VARCHAR(256),
  payment     VARCHAR(10),
  card        VARCHAR(256),
  card_type   VARCHAR(256),
  item        VARCHAR(256),
  total_price NUMERIC,
  phone       INTEGER,
  firstname   VARCHAR(256),
  lastname    VARCHAR(256),
  staff       VARCHAR(256)
);
-- \copy temp_order FROM 'order.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
-- Note: replace order.csv with its actual file path and run the command above in PSQL Tool Workspace in pgAdmin
DO $$
DECLARE
  rec RECORD;
  counter INT := 0;
BEGIN
  FOR rec IN
    SELECT * FROM temp_order ORDER BY ctid LIMIT 100
  LOOP
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
    counter := counter + 1;
    RAISE NOTICE 'Processed: order_id = %', rec.order_id;
  END LOOP;
  RAISE NOTICE 'Complete: % rows in total', counter;
END;
$$ LANGUAGE plpgsql;

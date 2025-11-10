CREATE OR REPLACE PROCEDURE insert_order_item(
  p_order_id       VARCHAR(256),
  p_order_date     DATE,
  p_order_time     TIME,
  p_payment_method VARCHAR(10),
  p_card_number    VARCHAR(256),
  p_card_type      VARCHAR(256),
  p_member_phone   INTEGER,
  p_item_name      VARCHAR(256),
  p_staff_id       VARCHAR(256)
) LANGUAGE plpgsql AS $$
DECLARE
  v_sum   NUMERIC;
  v_items INT;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM Food_Order WHERE id = p_order_id) THEN
    INSERT INTO Food_Order(id, date, time, payment_method, card, card_type)
    VALUES (
      p_order_id, p_order_date, p_order_time, p_payment_method,
      CASE WHEN p_payment_method = 'card' THEN p_card_number ELSE NULL END,
      CASE WHEN p_payment_method = 'card' THEN p_card_type   ELSE NULL END
    );
  END IF;
  IF p_member_phone IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Ordered_By WHERE order_id = p_order_id) THEN
    INSERT INTO Ordered_By(order_id, member)
    VALUES (p_order_id, p_member_phone);
  END IF;
  UPDATE Prepare
  SET qty = qty + 1
  WHERE order_id = p_order_id AND item = p_item_name AND staff = p_staff_id;
  IF NOT FOUND THEN
    INSERT INTO Prepare(order_id, item, staff, qty)
    VALUES (p_order_id, p_item_name, p_staff_id, 1);
  END IF;
  SELECT COALESCE(SUM(p.qty * i.price), 0), COALESCE(SUM(p.qty), 0)
  INTO v_sum, v_items
  FROM Prepare p JOIN Item i ON i.name = p.item
  WHERE p.order_id = p_order_id;
  IF EXISTS (SELECT 1 FROM Ordered_By WHERE order_id = p_order_id) AND v_items >= 4 THEN
    v_sum := GREATEST(v_sum - 2, 0);
  END IF;
  UPDATE Food_Order SET total_price = v_sum WHERE id = p_order_id;
END;
$$;

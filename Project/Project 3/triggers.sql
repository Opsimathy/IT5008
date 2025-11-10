CREATE OR REPLACE FUNCTION check_order_item_qty()
RETURNS TRIGGER AS $$
DECLARE

BEGIN
-- Check whether the item in prepare is null (not yet returned)

	IF NEW.item is null OR NEW.qty = 0
	THEN
		RAISE EXCEPTION 'Order % should have at least one item',NEW.order_id;
	ELSE
		RETURN NEW; -- allow insert
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_staff_can_cook()
RETURNS TRIGGER AS $$
DECLARE
	can_cook INT;
BEGIN
-- Check whether the staff can cook that item (not yet returned)
	SELECT COUNT(*) INTO can_cook 
	FROM item i, cook c
	WHERE i.name = NEW.item 
	AND c.staff = NEW.staff 
	AND i.cuisine = c.cuisine;
	
	IF can_cook = 0
	THEN
		RAISE EXCEPTION 'Staff % can not cook %',NEW.staff,NEW.item;
	ELSE
		RETURN NEW; -- allow insert
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION check_order_time()
RETURNS TRIGGER
AS $$
DECLARE
	v_reg_time time;
	v_reg_date date;
	v_order_date date;
	v_order_time time;
BEGIN
	SELECT fo.date, fo.time
	INTO v_order_date, v_order_time
	FROM Food_Order fo
	WHERE fo.id = NEW.order_id;

	SELECT m.reg_date, m.reg_time
	INTO v_reg_date, v_reg_time
	FROM Member m
	WHERE m.phone = NEW.member;

	IF (v_order_date < v_reg_date) OR (v_order_date = v_reg_date AND v_order_time < v_reg_time) 
	THEN
      	RAISE EXCEPTION
        	'Invalid order: order % (% %) was placed before member % registration (% %)',
        	NEW.order_id, v_order_date, v_order_time,
        	NEW.member, v_reg_date, v_reg_time;
  	END IF;

  	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_total_price()
RETURNS TRIGGER AS $$
DECLARE
	total NUMERIC;
	now_total NUMERIC;
	qty INT;
	ismember Boolean := FALSE;
BEGIN
	SELECT SUM(i.price * p.qty),SUM(p.qty) INTO total, qty
	FROM item i JOIN prepare p ON i.name = p.item
	WHERE p.order_id = NEW.order_id;

	SELECT TRUE into ismember
	FROM Ordered_By ob
	WHERE ob.order_id = NEW.order_id;

	IF ismember and qty >= 4
	THEN total := total - 2;
	END IF; 

	SELECT total_price INTO now_total
	FROM Food_Order fo
	WHERE fo.id = NEW.order_id;
	
	IF total IS DISTINCT FROM now_total
	THEN 
		RAISE EXCEPTION
			'Incorrect total price for order % expected total price % now price %',
			NEW.order_id, total, now_total;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER enforce_check_order_item_qty_insert
BEFORE INSERT ON prepare
FOR EACH ROW EXECUTE FUNCTION check_order_item_qty();

CREATE TRIGGER enforce_check_staff_can_cook_insert
BEFORE INSERT ON prepare
FOR EACH ROW EXECUTE FUNCTION check_staff_can_cook();


CREATE TRIGGER enforce_check_order_time_date_insert
BEFORE INSERT OR UPDATE OF order_id, member
ON Ordered_By
FOR EACH ROW EXECUTE FUNCTION check_order_time();

CREATE TRIGGER enforce_check_total_price
AFTER INSERT OR UPDATE OR DELETE
ON Prepare
FOR EACH ROW EXECUTE FUNCTION check_total_price();

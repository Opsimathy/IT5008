SELECT *
FROM restaurant r
WHERE r.area = 'London';

/*
σ[area = 'London'](restaurant)
*/


SELECT *
FROM sells s
WHERE (s.pizza = 'Veggie' AND s.price < 14)
   OR (s.rname = 'Sizzle Grill');

/*
σ[(pizza = 'Veggie' ∧ price < 14) ∨ (rname = 'Sizzle Grill')](sells)
*/


SELECT DISTINCT l.cname
FROM likes l;

/*
π[cname](likes)
*/


SELECT DISTINCT s.rname
FROM sells s
WHERE (s.pizza = 'Veggie' AND s.price < 14)
   OR (s.rname = 'Sizzle Grill');

/*
π[rname](
  σ[(pizza = 'Veggie' ∧ price < 14)
    ∨ (rname = 'Sizzle Grill')](sells))
*/


SELECT s.pizza FROM sells s
WHERE s.rname = 'Bella Italia'
INTERSECT
SELECT s.pizza FROM sells s
WHERE s.rname = 'Desert Diner';

/*
Q1 := π[pizza](σ[rname = 'Bella Italia'](sells))
Q2 := π[pizza](σ[rname = 'Desert Diner'](sells))
Q1 ∩ Q2
*/


SELECT s.pizza FROM sells s
WHERE s.rname = 'Bella Italia'
EXCEPT
SELECT s.pizza FROM sells s
WHERE s.rname = 'Desert Diner';

/*
Q1 := π[pizza](σ[rname = 'Bella Italia'](sells))
Q2 := π[pizza](σ[rname = 'Desert Diner'](sells))
Q1 - Q2
*/


SELECT c.cname, r.rname
FROM customer c, restaurant r
WHERE c.area = r.area;

/*
The online evaluater we developed has no concept
of "dot notation".  This necessitates the renaming
operation as a relation in relational algebra can
not have two different columns with the same name.

π[cname, rname](
  σ[area = rarea](
    customer × restaurant
  )
)
*/

/*
π[cname, rname](
  σ[area = rarea](
    customer ×
      ρ[rarea <- area](restaurant)
  )

-- WITH DOT NOTATION
-- NOT SUPPORTED ONLINE
π[c.cname, r.rname](
  σ[c.area = r.area](
    ρ(customer, c) × ρ(restaurant, r)
  )
)
*/

SELECT r.rname, s.pizza, s.price
FROM restaurant r, sells s
WHERE r.rname = s.rname
  AND r.area = 'London';

SELECT r.rname, s.pizza, s.price
FROM restaurant r, sells s
WHERE r.rname = s.rname
  AND r.area = 'London';

/*
π[rname, pizza, price](
  σ[sname = rname ∧ area = 'London'](
    restaurant × ρ[sname <- rname](sells)
  )
)

-- WITH DOT NOTATION
-- NOT SUPPORTED ONLINE
π[r.rname, s.pizza, s.price](
  σ[s.rname = r.rname ∧ r.area = 'London'](
    ρ(restaurant, r) × ρ(sells, s)
  )
)
*/

/*
π[cname, rname](
  customer ⋈[area = rarea]
    ρ[rarea <- area](restaurant)
)

-- WITH DOT NOTATION
-- NOT SUPPORTED ONLINE
π[c.cname, r.rname](
  ρ(customer, c) ⋈[c.area = r.area]
    ρ(restaurant, r)
)
*/

/*
π[rname, pizza, price](
  restaurant ⋈[sname = rname ∧ area = 'London'] ρ[sname <- rname](sells)
)

-- WITH DOT NOTATION
-- NOT SUPPORTED ONLINE
π[r.rname, s.pizza, s.price](
  ρ(restaurant, r) ⋈[s.rname = r.rname ∧ r.area = 'London'] ρ(sells, s)
)
*/
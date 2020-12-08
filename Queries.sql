select * from customer
join repair_service using (customer_id);
-- Customers who had their gears adjusted but did not have their wheel rubbing fixed (a – b)
create or replace view a as
select customer_name from customer
join repair_service using(customer_id)
where service_description like 'Gear adjustment';

create or replace view b as
select customer_name from customer
join repair_service using(customer_id)
where service_description like 'Wheel rubbing';

select * from a
minus
select * from b;

-- Customers who had their bike's wheel rubbing fixed but did not have their gears adjusted (b – a)
select * from b
minus
select * from a;

-- Customers had their gears adjusted and their bike's wheel rubbing fixed (a ? b)
select * from b
intersect
select * from a;

-- Customers whohad their gears adjusted or their bike's wheel rubbing fixed (a U b)
select * from b
union
select * from a;

-- Customers who had either their gears adjusted or bike's wheel rubbing fixed, but not both
-- A xor B (A U B) - (A ? B)
(
select * from b
union
select * from a
)
minus
(
select * from b
intersect
select * from a
);

-- Customers who only had their gears adjusted (a - ¬a)
create or replace view a_complement as
select customer_name from customer
join repair_service using(customer_id)
where service_description not like 'Gear adjustment';

select * from a
minus
select * from a_complement;

-- Customer who had a service which used all parts from stock (relational divide)
select * from customer
join repair_service using(customer_id)
join part_replaced using(repair_number);

select customer_name, service_description from customer c
join repair_service r using(customer_id)
where not exists
(select * from stock s 
where not exists
(select * from part_replaced p
where s.stock_code = p.stock_code
and r.repair_number = p.repair_number));

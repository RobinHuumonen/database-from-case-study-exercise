create sequence increment_id start with 1 increment by 1 nomaxvalue; 

drop table customer cascade constraints purge;

create table customer(
    customer_id int NOT NULL,
    customer_name varchar(26),
    contact_number varchar(26),
    PRIMARY KEY (customer_id)
);

create trigger customer_trigger
before insert on customer
for each row
   begin
     select increment_id.nextval into :new.customer_id from dual;
   end;
   
INSERT INTO customer (customer_name, contact_number)
select distinct CNAME, CONTACTNO from unnormalized;

INSERT INTO customer (customer_name, contact_number)
VALUES ('Lilly Browne', '33344551');
INSERT INTO customer (customer_name, contact_number)
VALUES ('Matti Paani', '33344552');
INSERT INTO customer (customer_name, contact_number)
VALUES ('Pekka Pankka', '33344553');
INSERT INTO customer (customer_name, contact_number)
VALUES ('Risto Makkonen', '33344554');
INSERT INTO customer (customer_name, contact_number)
VALUES ('Paula Sievinen', '33344554');

INSERT INTO customer
VALUES (555, 'Paula Sievinen', '33344554');

select * from customer;
select * from customer;
ALTER TABLE customer
  MODIFY (customer_name varchar(26) NOT NULL,
          contact_number varchar(26) NOT NULL); 
          
update customer set contact_number = trim(contact_number);        
--------------------------------------------------------------------  
drop table staff cascade constraints purge;

create table staff(
    staff_id int NOT NULL,
    staff_name varchar(26),
    staff_role varchar(26),
    PRIMARY KEY (staff_id)
);

create trigger staff_trigger
before insert on staff
for each row
   begin
     select increment_id.nextval into :new.staff_id from dual;
   end;
   
insert into staff(staff_name, staff_role) values ('Mikko', 'Mechanic');
insert into staff(staff_name, staff_role) values ('Moona', 'Receptionist');
insert into staff(staff_name, staff_role) values ('Aimo', 'Shop assistant');

desc staff;
select * from staff;
ALTER TABLE staff
  MODIFY (staff_name varchar(26) NOT NULL,
          staff_role varchar(26) NOT NULL);   
--------------------------------------------------------------------
 drop table repair_service;
 create table repair_service(
    repair_number int NOT NULL,
    repair_date date,
    status varchar(26),
    service_description varchar(26),
    repair_description varchar(26),
    labour_cost number(38,0),
    hours_total number(38,0),
    PRIMARY KEY (repair_number)
);

create trigger repair_trigger
before insert on repair_service
for each row
   begin
     select increment_id.nextval into :new.repair_number from dual;
   end;
   
INSERT INTO repair_service (repair_date, status, service_description, repair_description, labour_cost)
select distinct REPAIRDATE, STATUS, SERVICEDESC, REPAIRDESC, LABOURCOST from unnormalized; 

select * from repair_service;

ALTER TABLE repair_service
    ADD(
    receptionist int,
    shop_assistant int,
    mechanic int
    );
select * from staff;
UPDATE repair_service
SET receptionist = 4;
UPDATE repair_service
SET shop_assistant = 5;
UPDATE repair_service
SET mechanic = 3;

alter table repair_service add( 
    constraint receptionist FOREIGN KEY (receptionist) REFERENCES staff(staff_id),
    constraint shop_assistant FOREIGN KEY (shop_assistant) REFERENCES staff(staff_id),
    constraint mechanic FOREIGN KEY (mechanic) REFERENCES staff(staff_id)
);

select * from repair_service;
ALTER TABLE repair_service
  MODIFY (receptionist int NOT NULL,
          shop_assistant int NOT NULL,
          mechanic int NOT NULL,
          repair_date DATE NOT NULL,
          status varchar(26) NOT NULL,
          service_description varchar(26) NOT NULL);         

desc repair_service;

ALTER TABLE repair_service
    ADD(
    receptionist int,
    shop_assistant int,
    mechanic int
    );

ALTER TABLE repair_service
    ADD(
    serial_number int,
    model_code varchar(26)
    );
    
select * from repair_service;
select * from customer;

UPDATE repair_service
SET serial_number = 44,
    model_code = 'FL200U'
WHERE repair_number = 10;

alter table repair_service add( 
    constraint serial_number FOREIGN KEY (serial_number) REFERENCES bike(serial_number)
);

ALTER TABLE repair_service
  MODIFY (serial_number int NOT NULL,
          model_code varchar(26) NOT NULL);
desc repair_service;

select * from repair_service;

ALTER TABLE repair_service ADD (customer_id int);

select * from repair_service;
UPDATE repair_service
SET customer_id = 84
WHERE repair_number = 10;

alter table repair_service add( 
    constraint customer_id FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
alter table repair_service modify customer_id int NOT NULL;
alter table repair_service modify mechanic int;
insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Chain tensioning', 4, 5, 3, 46, 'TL200U', 85);

select * from customer
join repair_service using (customer_id);

insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Mended wheel', 4, 5, 3, 44, 'FL200U', 84);

insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Gear adjustment', 4, 5, 3, 43, 'FG200U', 87);

insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Gear adjustment', 4, 5, 3, 49, 'TL200U', 84);

insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Wheel rubbing', 4, 5, 3, 43, 'FG200U', 87);

delete from repair_service where repair_number = 9;

select * from customer;
insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Gear adjustment', 4, 5, 3, 93, 'PL200U', 90);

insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant, mechanic, serial_number, model_code, customer_id)
values ('11-NOV-20', 'R', 'Mega maintance service', 4, 5, 3, 49, 'TL200U', 84);

 --------------------------------------------------------------------
drop table part_replaced cascade constraints purge;
create table part_replaced(
    quantity_required int NOT NULL,
    repair_number int NOT NULL,
    stock_code int NOT NULL,
    
    foreign key (repair_number) references repair_service(repair_number),
    foreign key (stock_code) references stock(stock_code),
    primary key(repair_number, stock_code)
);
select * from stock;
insert into part_replaced values (1, 6, 77);
insert into part_replaced values (1, 6, 83);
insert into part_replaced values (1, 8, 81);
insert into part_replaced values (1, 7, 78);
insert into part_replaced values (1, 10, 82);
select * from stock;
select * from part;
select * from repair_service;
insert into part_replaced values (1, 101, 82);

insert into part_replaced values (1, 104, 77);
insert into part_replaced values (1, 104, 78);
insert into part_replaced values (1, 104, 79);
insert into part_replaced values (1, 104, 80);
insert into part_replaced values (1, 104, 81);
insert into part_replaced values (1, 104, 82);
insert into part_replaced values (1, 104, 83);
commit;
--------------------------------------------------------------------
drop table supplier cascade constraints purge;

create table supplier(
    supplier_id int NOT NULL,
    supplier_name varchar(26)
);

create trigger supplier_trigger
before insert on supplier
for each row
   begin
     select increment_id.nextval into :new.supplier_id from dual;
   end;
   
ALTER TABLE supplier
  MODIFY (supplier_name varchar(26) NOT NULL);   
  
INSERT INTO supplier (supplier_name)
VALUES ('Mega Supplier');

INSERT INTO supplier (supplier_name)
VALUES ('Vapari');

INSERT INTO supplier (supplier_name)
VALUES ('Tukku');

select * from supplier;

alter table supplier add( 
    constraint supplier_id PRIMARY KEY (supplier_id));
desc supplier;    
--------------------------------------------------------------------
drop table part cascade constraints purge;

create table part(
    part_number int,
    is_part_of int,
    part_name varchar(26),
    model_code varchar(26),
    supplier_id int
);

INSERT INTO part (part_number, is_part_of, part_name, model_code)
select distinct PARTNO, ISPARTOF, PARTNAME, MODELNO from unnormalized;

select * from part;

UPDATE part
SET supplier_id = 67;


alter table part add( 
    constraint part_number PRIMARY KEY (part_number));
alter table part add(    
    constraint part_supplier_id FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id));
    
desc part;

ALTER TABLE part
  MODIFY (model_code varchar(26) NOT NULL,
          supplier_id int NOT NULL);
delete from part where part_name like 'Carrier';          
insert into part values (3, null, 'Carrier', 'FL200U', 67);
alter table part 
    modify (part_number int NOT NULL);
    
insert into part values (4, null, 'Reflector', 'TL200U', 74);    
--------------------------------------------------------------------
drop table stock cascade constraints purge;
 create table stock(
    stock_code int not null,
    quantity int,
    part_number int,
    UNIQUE(part_number),
    PRIMARY KEY (stock_code)
);
create trigger stock_trigger
before insert on stock
for each row
   begin
     select increment_id.nextval into :new.stock_code from dual;
   end;
   
INSERT INTO stock (quantity, part_number)
select distinct QTYINSTOCK, PARTNO from unnormalized;

select * from stock;

alter table stock add(    
    constraint stock_part_number FOREIGN KEY (part_number) REFERENCES part(part_number));
    
ALTER TABLE stock
  MODIFY (part_number int NOT NULL);    
  
select * from stock;
commit;
insert into stock (quantity, part_number)  values (10, 3);
insert into stock (quantity, part_number)  values (10, 4);
--------------------------------------------------------------------
drop table bike cascade constraints purge;
create table bike(
    serial_number int NOT NULL,
    model_code varchar(26),
    model_name varchar(26),
    frame_type varchar(26),
    number_of_gears varchar(26),
    gear_type varchar(26),
    wheel_size varchar(26),
    brand varchar(26),
    PRIMARY KEY (serial_number)
);

create trigger bike_trigger
before insert on bike
for each row
   begin
     select increment_id.nextval into :new.serial_number from dual;
   end;

INSERT INTO bike ( model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand)
select distinct MODELNO, MODELNAME, FRAMETYPE, NOGEARS, GEARTYPE, WHEELSIZE, BRAND from unnormalized;

select * from bike;
 
DELETE FROM bike where serial_number > 49;

ALTER TABLE bike
  MODIFY (model_code varchar(26) NOT NULL,
          model_name varchar(26) NOT NULL,
          brand varchar(26) NOT NULL); 
          
ALTER TABLE bike
    ADD(
    supplier_id int
    );       
select * from bike;    
UPDATE bike
SET supplier_id = 67;

UPDATE bike 
set supplier_id = 74
where serial_number > 47;

UPDATE bike 
set supplier_id = 75
where serial_number = 44;

alter table bike add(    
    constraint bike_supplier_id FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id));
    
ALTER TABLE bike
  MODIFY (supplier_id int NOT null); 
  
select * from bike;  

ALTER TABLE bike
  MODIFY (supplier_id UNIQUE);
  
select * from bike;  
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('BL200U', 'Gents 20cm', 'offroad', '3x5', 'synch', '20in', 'Helkama', 75);
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('PL200U', 'Gents 20cm', 'city', '1x1', null, '20in', 'Helkama', 75);
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('KL200U', 'Ladies 20cm', 'city', '1x1', null, '20in', 'Helkama', 75);
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('KL200U', 'Ladies 20cm', 'offroad', '1x1', null, '20in', 'Tunturi', 75);
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('KL200U', 'Ladies 20cm', 'hybrid', '3x5', null, '20in', 'Tunturi', 75);
insert into bike (model_code, model_name, frame_type, number_of_gears, gear_type, wheel_size, brand, supplier_id)
values ('KL200U', 'Gents 20cm', 'road', '3x5', null, '20in', 'Tunturi', 75);
 
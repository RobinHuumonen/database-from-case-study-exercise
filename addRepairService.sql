create or replace function addRepairService(
    p_customer_name customer.customer_name%type,
    p_contact_number customer.contact_number%type,
    p_repair_date repair_service.repair_date%type,
    p_service_description repair_service.service_description%type,
    p_receptionist repair_service.receptionist%type,
    p_shop_assistant repair_service.shop_assistant%type,
    p_serial_number repair_service.serial_number%type,
    p_model_code repair_service.model_code%type
    )
    RETURN VARCHAR2 AS
    v_response VARCHAR2(56);
    v_count_customer integer;
    v_customer_id customer.customer_id%type;
    v_count_bike integer;
    v_status repair_service.status%type:='R';

BEGIN
    SELECT count(*) INTO v_count_customer FROM customer 
    where customer_name = p_customer_name and contact_number = p_contact_number;
    
    SELECT count(*) INTO v_count_bike FROM bike
    where serial_number = p_serial_number;
    
    if v_count_bike = 0 then
        v_response:='Provided serial number does not exist in the bike table';
        return v_response;    
    elsif v_count_customer = 0 then
        insert into customer (customer_name, contact_number) values (p_customer_name, p_contact_number)
        returning customer_id into v_customer_id;
        insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant,
        serial_number, model_code, customer_id) values (p_repair_date, v_status, p_service_description, p_receptionist,
        p_shop_assistant, p_serial_number, p_model_code, v_customer_id);
        commit;
        v_response:='New customer and repair service added';
        return v_response;
    else
        select customer_id into v_customer_id from customer
        where customer_name = p_customer_name
        and contact_number = p_contact_number;
        insert into repair_service (repair_date, status, service_description, receptionist, shop_assistant,
        serial_number, model_code, customer_id) values (p_repair_date, v_status, p_service_description, p_receptionist,
        p_shop_assistant, p_serial_number, p_model_code, v_customer_id);
        commit;
        v_response:='New repair service addded to an existing customer';
        return v_response;    
    end if; 
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END addRepairService;


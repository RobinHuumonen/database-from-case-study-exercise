set serveroutput on
/*
# Paul Browne
# 33386855
# 01-NOV-01
# Test service
# 4
# 5
# 49
# TL200U
*/
declare
    v_customer_name customer.customer_name%type:='&Customer_name';
    v_contact_number customer.contact_number%type:='&Customer_contact_number';
    v_repair_date repair_service.repair_date%type:='&Repair_date';
    v_service_description repair_service.service_description%type:='&Service_description';
    v_receptionist repair_service.receptionist%type:='&Receptionist_id';
    v_shop_assistant repair_service.shop_assistant%type:='&Shop_assistant_id';
    v_serial_number repair_service.serial_number%type:='&Serial_number';
    v_model_code repair_service.model_code%type:='&Model_code';

    v_response varchar2(56);
begin 
    v_response :=addRepairService(v_customer_name, v_contact_number, v_repair_date, 
    v_service_description, v_receptionist, v_shop_assistant, v_serial_number, v_model_code);
    dbms_output.put_line(v_response);
end;

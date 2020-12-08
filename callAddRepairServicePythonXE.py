import cx_Oracle  # import the Oracle Python library
import getpass
import os
import pandas as pd
print(os.getenv("LD_LIBRARY_PATH"));#check that LD_LIBRARY_PATH is set


p_username = input("Username:")# Accept the Oracle login details
p_password = input("Password:")
dsn_tns = cx_Oracle.makedsn('localhost', 1521, 'xe')

# Take in the student information
customer_name = input("Customer name: ")
contact_number = input("Customer's contact number: ")
repair_date = input("Repair date (e.g. 01-NOV-01): ")
service_description = input("Service description: ")
receptionist = input("Receptionist's id: ")
shop_assistant = input("Shop assistant's id: ")
serial_number = input("Serial number: ")
model_code = input("Model code: ")

arguments = [customer_name, contact_number, repair_date, service_description,
             receptionist, shop_assistant, serial_number, model_code]

# Username and password = bicycle
# Paul Browne
# 33386855
# 01-NOV-01
# Python service
# 4
# 5
# 49
# TL200U
try:
    con = cx_Oracle.connect(p_username, p_password, dsn_tns)
    con.current_schema = p_username #In this case, we're using the local schema.
    print("Database version:", con.version, "Oracle Python version:", cx_Oracle.version)
    cur = con.cursor()
    print(arguments)
    try:
        response = cur.callfunc('addRepairService', str, arguments)
        print(response)
    except cx_Oracle.DatabaseError as e:
        errorObj, = e.args
        print("There was a database error")
        print("Error Code:", errorObj.code)
        print("Error Message:", errorObj.message)
    cur.close()
    con.close()
except (cx_Oracle.OperationalError, cx_Oracle.DatabaseError, cx_Oracle.InterfaceError)as e:
    errorObj, = e.args
    print("There was a database error with code : ", errorObj.code)
    print("Error Message:", errorObj.message)
    print('The database connection failed')
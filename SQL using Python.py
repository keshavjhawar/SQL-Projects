from IPython.display import display
import mysql.connector
from mysql.connector import Error
import pandas as pd


pw = "Leonardo@best"
db = "mysql_python"

def create_server_connection(host_name,user_name,user_password):
    connection = None
    try:
        connection = mysql.connector.connect(
            host = host_name,
            user = user_name,
            password = user_password
        )
        print("MySQL Server connection successful")
    except Error as err:
        print(f"Error: {err}")
    return connection

# server_connection = create_server_connection("localhost","root",pw)

def create_database(connection,query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        print("Database created successfully")
    except Error as err:
        print(f"Error : {err}")

create_database_query = "CREATE DATABASE mysql_python"

# create_database(new_connection,create_database_query)

def create_db_connection(host_name,user_name,user_password,db_name):
    connection = None
    try:
        connection = mysql.connector.connect(host = host_name, user = user_name, password = user_password, database = db_name)
        print("MySQl database connection successful")
    except Error as err:
        print(f"{err}")
    return connection

db_connection = create_db_connection("localhost","root",pw,db)

def execute_query(connection,query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query was successful")
    except Error as err:
        print(f"Error: {err}")
    return connection

create_orders_table = """ create table orders (
order_id int primary key,
customer_name varchar(30) not null,
product_name varchar(20) not null,
date_ordered date,
quantity int,
unit_price float,
phone_number varchar(20)
); """

# q1 = execute_query(db_connection,create_orders_table)

insert_into_orders = """
INSERT INTO orders
VALUES
(101,"Keshav1","Laptop","2023-09-22",50,1000.00,9521674683),
(102,"Keshav2","Laptop1","2022-09-22",500,1500.00,9521674683),
(103,"Kesha3","Laptop2","2021-09-22",600,1200.00,9521674683),
(104,"Keshav4","Laptop3","2020-09-22",10,2000.00,9521674683),
(105,"Keshav5","Laptop4","2019-09-22",120,5000.00,9521674683),
(106,"Keshav6","Laptop5","2018-09-22",900,800.00,9521674683);
"""
# q2 = execute_query(db_connection,insert_into_orders)

def read_query(connection,query):
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as err:
        print(f"Error: {err}")
        return connection

select_column = """
SELECT * FROM orders;
"""

q3 = read_query(db_connection,select_column)
for data in q3:
    print(data)

from_db = []
for data in q3:
    result = list(data)
    from_db.append(result)
column = ["order_id","customer_name","product_name","date_ordered","quantity","unit_price","phone_number"]
df = pd.DataFrame(from_db,columns=column)
# display(df)

delete_data = """
DELETE FROM orders
WHERE order_id = 104;
"""
q4 = execute_query(db_connection,delete_data)

update_data = """
UPDATE orders
SET unit_price = 55
WHERE order_id = 103;
"""
# q5 = execute_query(db_connection,update_data)

q3 = read_query(db_connection,select_column)

from_db = []
for data in q3:
    result = list(data)
    from_db.append(result)
column = ["order_id","customer_name","product_name","date_ordered","quantity","unit_price","phone_number"]
df = pd.DataFrame(from_db,columns=column)
display(df)

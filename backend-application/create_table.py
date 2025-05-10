import mysql.connector
import boto3
import json
import config
from botocore.exceptions import ClientError
from mysql.connector import errorcode

def get_secret(secret_name, region_name):
    client = boto3.client('secretsmanager', region_name=region_name)

    try: 
        response = client.get_secret_value(SecretId=secret_name)

    except ClientError as e:
        raise Exception(f"Failed to retrieve secret: {e}")
    
    if 'SecretString' in response:
        secret = response['SecretString']
        return json.loads(secret)
    else:
        raise Exception("Cannot find secret")


def get_db_connection():
    credentials = get_secret(config.secret_name, config.region_name)
    mysql_user = credentials['username']
    mysql_password = credentials['password']
    return mysql.connector.connect(
        host=config.MYSQL_HOST,
        user=mysql_user,
        password=mysql_password,
        database=config.MYSQL_DB
    )

def create_table():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        create_table_query = """
        CREATE TABLE IF NOT EXISTS orders (
            id INT AUTO_INCREMENT PRIMARY KEY,
            customer_id VARCHAR(50) NOT NULL,
            product_id VARCHAR(50) NOT NULL,
            quantity INT NOT NULL,
            order_date VARCHAR(50),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """
        cursor.execute(create_table_query)
        connection.commit()
        cursor.close()
        connection.close()
        print("Table created successfully")
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Access Denied. Check your username and password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(f"Error: {err}")
    except Exception as e:
        print(f"Error creating table: {e}")


if __name__ == "__main__":
    create_table()


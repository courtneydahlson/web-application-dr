from flask import Flask, request, jsonify
import mysql.connector
import config
import boto3
import json
from botocore.exceptions import ClientError

app = Flask(__name__)

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

@app.route('/')
def home():
    return "Welcome to the order submission backend"

@app.route('/ordersubmission', methods=['POST'])
def handle_order():
    data = request.get_json(silent=True)

    if data:
        print("Received JSON data:", data)
        required_fields = ['customer_id', 'product_id', 'quantity', 'order_date']
        missing_fields = []
        for field in required_fields:
            if field not in data:
                missing_fields.append(field) 
      
        if missing_fields:
            return jsonify({'error': f"Missing fields: {', '.join(missing_fields)}"}), 400
        customer_id = data['customer_id']
        product_id = data['product_id']
        quantity = data['quantity']
        order_date = data['order_date']
        
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute("INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (%s, %s, %s, %s)", (customer_id, product_id, quantity, order_date))
            conn.commit()
            cursor.close()
            conn.close()
            return jsonify({'message': 'Data inserted successfully'}), 201
        except mysql.connector.Error as err:
            return jsonify({'error': str(err)}), 500
    else:
        print("Received raw data:", request.data.decode('utf-8'))
    return 'Data received', 200

# Health check endpoint
@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'message': 'App is running'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)

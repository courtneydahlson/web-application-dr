from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the order submission backend"

@app.route('/ordersubmission', methods=['POST'])
def handle_order():
    data = request.get_json(silent=True)
    if data:
        print("Received JSON data:", data)
    else:
        print("Received raw data:", request.data.decode('utf-8'))
    return 'Data received', 200

# Health check endpoint
@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'message': 'App is running'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)

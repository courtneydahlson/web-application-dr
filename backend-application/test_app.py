import pytest
from unittest.mock import patch, MagicMock
from app import app  # Assuming the app code is saved as `app.py`

@pytest.fixture
def client():
    app.config['TESTING'] = True
    return app.test_client()

def test_home_route(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b"Welcome to the order submission backend" in response.data

def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json == {'status': 'ok', 'message': 'App is running'}

@patch('app.get_secret')
@patch('app.mysql.connector.connect')
def test_order_submission_success(mock_connect, mock_get_secret, client):
    mock_get_secret.return_value = {
        'username': 'test_user',
        'password': 'test_pass'
    }

    mock_cursor = MagicMock()
    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_connect.return_value = mock_conn

    order_data = {
        'customer_id': 1,
        'product_id': 2,
        'quantity': 3,
        'order_date': '2023-01-01'
    }

    response = client.post('/ordersubmission', json=order_data)

    assert response.status_code == 201
    assert response.json == {'message': 'Data inserted successfully'}
    mock_cursor.execute.assert_called_once()

def test_order_submission_missing_fields(client):
    # Missing 'quantity'
    order_data = {
        'customer_id': 1,
        'product_id': 2,
        'order_date': '2023-01-01'
    }

    response = client.post('/ordersubmission', json=order_data)
    assert response.status_code == 400
    assert 'error' in response.json
    assert 'quantity' in response.json['error']

def test_order_submission_invalid_json(client):
    response = client.post('/ordersubmission', data="Not JSON", content_type='application/json')
    assert response.status_code == 200
    assert b'Data received' in response.data

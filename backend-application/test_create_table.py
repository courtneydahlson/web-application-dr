import pytest
from unittest.mock import patch, MagicMock
import mysql.connector
from create_table import get_secret, get_db_connection, create_table
import json

# Mock config variables
import config
config.secret_name = "fake-secret"
config.region_name = "us-east-1"
config.MYSQL_HOST = "localhost"
config.MYSQL_DB = "testdb"

def test_get_secret_success():
    fake_secret = {"username": "test_user", "password": "test_pass"}

    with patch("create_table.boto3.client") as mock_client:
        mock_secrets = MagicMock()
        mock_secrets.get_secret_value.return_value = {
            'SecretString': json.dumps(fake_secret)
        }
        mock_client.return_value = mock_secrets

        result = get_secret("fake-secret", "us-east-1")
        assert result == fake_secret

@patch("create_table.get_secret")
@patch("create_table.mysql.connector.connect")
def test_get_db_connection(mock_connect, mock_get_secret):
    # Mock secrets and MySQL connection
    mock_get_secret.return_value = {
        "username": "user",
        "password": "pass"
    }

    mock_connection = MagicMock()
    mock_connect.return_value = mock_connection

    connection = get_db_connection()
    assert connection == mock_connection
    mock_connect.assert_called_once()

@patch("create_table.get_db_connection")
def test_create_table_success(mock_get_db_conn):
    mock_connection = MagicMock()
    mock_cursor = MagicMock()
    mock_connection.cursor.return_value = mock_cursor
    mock_get_db_conn.return_value = mock_connection

    create_table()

    mock_cursor.execute.assert_called_once()
    mock_connection.commit.assert_called_once()
    mock_cursor.close.assert_called_once()
    mock_connection.close.assert_called_once()

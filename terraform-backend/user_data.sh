#!/bin/bash
yum install python3-pip -y
yum install -y awscli python3 nc
dnf install mariadb105 -y
cd /home/ec2-user
aws s3 cp s3://web-application-dr/backend/ . --recursive

while true; do
    echo "Downloading latest config.py from S3"
    aws s3 cp s3://web-application-dr/backend/config.py .
    MYSQL_HOST=$(grep MYSQL_HOST config.py | cut -d'"' -f2)
    echo "Checking Aurora MySQL connectivity to $MYSQL_HOST:3306"
    nc -z -w10 "$MYSQL_HOST" 3306
    if [ $? -eq 0 ]; then
        echo "Aurora MySQL is reachable: $MYSQL_HOST"
        break
    else
        echo "Aurora MySQL is not reachable. Retrying in 30 seconds..."
        sleep 30
    fi
done 

pip3 install -r requirements.txt
# python3 create_table.py >> create_table.log 2>&1
# nohup python3 app.py > output.log 2>&1 &
python3 create_table.py
nohup python3 app.py &
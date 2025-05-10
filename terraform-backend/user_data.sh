!/bin/bash
yum install python3-pip -y
dnf install mariadb105 -y
cd /home/ec2-user
aws s3 cp s3://web-application-dr/backend/ . --recursive
pip3 install -r requirements.txt
# python3 create_table.py >> create_table.log 2>&1
# nohup python3 app.py > output.log 2>&1 &
python3 create_table.py
nohup python3 app.py &
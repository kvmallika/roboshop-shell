
echo -e "\e[33m ***** NoteJS repo files ***** \e[33m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[33m ***** Install NoteJS ***** \e[33m"
yum install nodejs -y

echo -e "\e[33m ***** adding application user ***** \e[33m"
useradd roboshop

echo -e "\e[33m ***** creating app directory ***** \e[33m"
rm -rf /app
mkdir /app

echo -e "\e[33m ***** downloding application code ***** \e[33m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[33m ***** unzip the app content ***** \e[33m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[33m ***** installing dependencies ***** \e[33m"
npm install

echo -e "\e[33m ***** coping catalogue service files ***** \e[33m"
cp \home\centos\roboshop-shell\catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[33m ***** starting catalogue service ***** \e[33m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[33m ***** coping mongodb repo files ***** \e[33m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m ***** installing mongodb client ***** \e[33m"
yum install mongodb-org-shell -y

echo -e "\e[33m ***** load schema ***** \e[33m"
mongo --host mongodb-dev.vemdevops.online </app/schema/catalogue.js

echo -e "\e[31m ***** NoteJS repo files ***** \e[31m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m ***** Install NoteJS ***** \e[31m"
yum install nodejs -y

echo -e "\e[31m ***** adding application user ***** \e[31m"
useradd roboshop

echo -e "\e[31m ***** creating app directory ***** \e[31m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloding application code ***** \e[31m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m ***** unzip the app content ***** \e[31m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[31m ***** installing dependencies ***** \e[31m"
npm install

echo -e "\e[31m ***** coping catalogue service files ***** \e[31m"
cp //home//centos//roboshop-shell//catalogue.service  //etc//systemd//system//catalogue.service

echo -e "\e[31m ***** starting catalogue service ***** \e[31m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m ***** coping mongodb repo files ***** \e[31m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m ***** installing mongodb client ***** \e[31m"
yum install mongodb-org-shell -y

echo -e "\e[31m ***** load schema ***** \e[31m"
mongo --host mongodb-dev.vemdevops.online </app/schema/catalogue.js
echo -e "\e[31m ***** NodeJS repo files ***** \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m ***** Install NodeJS ***** \e[0m"
yum install nodejs -y

echo -e "\e[31m ***** adding application user ***** \e[0m"
useradd roboshop

echo -e "\e[31m ***** creating app directory ***** \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloading application code ***** \e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[31m ***** unzip the app content ***** \e[0m"
unzip /tmp/user.zip
cd /app

echo -e "\e[31m ***** installing dependencies ***** \e[0m"
npm install

cho -e "\e[31m ***** coping user service files ***** \e[0m"
cp //home//centos//roboshop-shell//user.service /etc/systemd/system/user.service

echo -e "\e[31m ***** starting user service ***** \e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[31m ***** coping mongodb repo files ***** \e[0m"
cp //home//centos//roboshop-shell//mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m ***** installing mongodb client ***** \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m ***** load schema ***** \e[0m"
mongo --host mongodb-dev.vemdevops.online /app/schema/user.js
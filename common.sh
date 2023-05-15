app_user=roboshop

schema_setup() {
  if [ "schema_setup" == "mongo" ]; then

echo -e "\e[31m ***** coping mongodb repo files ***** \e[0m"
cp ${script_path}//mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m ***** installing mongodb client ***** \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m ***** load schema ***** \e[0m"
mongo --host mongodb-dev.vemdevops.online </app/schema/${component}.js
 fi
}
func_nodejs()
{
echo -e "\e[31m ***** NodeJS repo files ***** \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m ***** Install NodeJS ***** \e[0m"
yum install nodejs -y

echo -e "\e[31m ***** adding application user ***** \e[0m"
useradd ${app_user}

echo -e "\e[31m ***** creating app directory ***** \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloading application code ***** \e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

echo -e "\e[31m ***** unzip the app content ***** \e[0m"
unzip /tmp/${component}.zip
cd /app

echo -e "\e[31m ***** installing dependencies ***** \e[0m"
npm install

echo -e "\e[31m ***** coping catalogue service files ***** \e[0m"
cp ${script_path}//${component}.service  /etc/systemd/system/${component}.service

echo -e "\e[31m ***** starting catalogue service ***** \e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}

schema_setup

}
echo -e "\e[31m ***** install maven ***** \e[0m"
yum install maven -y

echo -e "\e[31m ***** adding application user ***** \e[0m"
useradd roboshop

echo -e "\e[31m ***** setting app directory ***** \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloading the app code and unzipping it ***** \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
cd /app

echo -e "\e[31m ***** download the dependencies & build the application ***** \e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m ***** setting up the systemD files ***** \e[0m"
cp //home//centos//roboshop-shell//shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m ***** enable and starting the shipping service  ***** \e[0m"
systemctl daemon-reload

systemctl enable shipping
systemctl start shipping

echo -e "\e[31m ***** install MySQL client ***** \e[0m"
yum install mysql -y
echo -e "\e[31m ***** Load Schema ***** \e[0m"
mysql -h mysql-dev.vemdevops.online -uroot -pRoboShop@1 </app/schema/shipping.sql

systemctl restart shipping
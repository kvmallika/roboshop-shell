script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m ***** Installing Python  ***** \e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[31m ***** adding application user ***** \e[0m"
useradd ${app_user}

echo -e "\e[31m ***** creating the app directory ***** \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloading and unzipping the application code  ***** \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[31m ***** Download the dependencies ***** \e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[31m ***** setup systemD payment service ***** \e[0m"
cp ${script_path}//payment.service /etc/systemd/system/payment.service

echo -e "\e[31m ***** start and enable payment service ***** \e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment

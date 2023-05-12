script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m ***** Installing Python  ***** \e[0m"
yum install golang -y

echo -e "\e[31m ***** adding application user ***** \e[0m"
useradd ${app_user}

echo -e "\e[31m ***** creating the app directory ***** \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m ***** downloading and unzipping the application code  ***** \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

cd /app

echo -e "\e[31m ***** Download the dependencies ***** \e[0m"
go mod init dispatch
go get
go build

echo -e "\e[31m ***** setup systemD dispatch service ***** \e[0m"
cp ${script_path}//dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[31m ***** start and enable dispatch service ***** \e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch

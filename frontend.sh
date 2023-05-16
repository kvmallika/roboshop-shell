script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Install nginx"
yum install nginx -y &>>$log_file
func_stat_check $?

func_print_head "coping the config. file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

func_print_head "Clean old app content"
rm -rf /usr/share/nginx/html/*
func_stat_check $?

func_print_head "Downloading' the app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "Extracting the app content"
cd  /usr/share/nginx/html
func_stat_check $?
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "enable and start the systemd service"
systemctl enable nginx
systemctl restart nginx
func_stat_check $?

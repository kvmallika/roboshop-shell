script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component="dispatch"

func_print_head "Installing Python"
yum install golang -y &>>$log_file

func_app_prereq

cd /app

func_print_head "Download the dependencies"
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file

func_systemd_setup

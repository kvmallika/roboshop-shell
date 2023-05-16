script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component="dispatch"

func_print_head "Installing Python"
yum install golang -y &>>$log_file
func_stat_check $?

func_app_prereq

cd /app

func_print_head "Download the dependencies"
go mod init dispatch &>>$log_file
func_stat_check $?
go get &>>$log_file
func_stat_check $?
go build &>>$log_file
func_stat_check $?

func_systemd_setup

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "downloading the repo files"
cp ${script_path}//mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "Install mongodb"
yum install mongodb-org -y &>>$log_file
func_stat_check $?

func_print_head "changing the listen address of mongodb"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_stat_check $?

func_print_head "enable and start mongodb service"
systemctl enable mongod
systemctl restart mongod
func_stat_check $?



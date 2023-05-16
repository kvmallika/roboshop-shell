script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if[ -z "$mysql_root_password" ]; then
  echo "input MysQL root password is missing"
  exit
fi

func_print_head "disablling MySQL"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "setup MySQL repo files"
cp ${script_path}//mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "install MySQL server"
yum install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "enable and start MySQL service"
systemctl enable mysqld
systemctl restart mysqld
func_stat_check $?

func_print_head "setting the root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
func_stat_check $?



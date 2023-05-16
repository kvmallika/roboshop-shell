script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install redis repo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_stat_check $?

func_print_head "enable the packages"
dnf module enable redis:remi-6.2 -y &>>$log_file
func_stat_check $?

func_print_head "Install redis"
yum install redis -y &>>$log_file
func_stat_check $?

func_print_head "updating the listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_stat_check $?

func_print_head "start and enable redis service"
systemctl enable redis
systemctl restart redis
func_stat_check $?
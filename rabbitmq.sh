script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input RabbitMQ appuser password is missing
  exit 1
fi

func_print_head "config. YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "Install Erlang"
yum install erlang -y &>>$log_file
func_stat_check $?

func_print_head "Configure YUM repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head "start RabbitMQ service"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
func_stat_check $?

func_print_head "Creating user for the application"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?

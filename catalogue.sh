script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=catalogue

func_nodejs

echo -e "\e[31m ***** coping mongodb repo files ***** \e[0m"
cp ${script_path}//mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m ***** installing mongodb client ***** \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m ***** load schema ***** \e[0m"
mongo --host mongodb-dev.vemdevops.online </app/schema/catalogue.js
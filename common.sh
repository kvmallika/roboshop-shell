app_user=roboshop
log_file=/tmp/roboshop.log

func_print_head()
{
  echo -e "\e[34m ***** $1 ***** \e[0m"
  echo -e "\e[34m ***** $1 ***** \e[0m" &>>log_file
}
func_stat_check(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
    else
    echo -e "\e[31m FAILURE \e[0m"
    exit 1
  fi
}
func_schema_setup() {
  if [ "schema_setup" == "mongo" ]; then

    func_print_head "coping mongodb repo files"
    cp ${script_path}//mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_stat_check $?

    func_print_head "installing mongodb client"
    yum install mongodb-org-shell -y &>>$log_file
    func_stat_check $?

    func_print_head "load schema"
    mongo --host mongodb-dev.vemdevops.online </app/schema/${component}.js &>>$log_file
    func_stat_check $?
 fi
 if [ "schema_setup" == "mysql" ]; then
     func_print_head "install MySQL client"
     yum install mysql -y &>>$log_file
     func_stat_check $?

     func_print_head "Load Schema"
     mysql -h mysql-dev.vemdevops.online -uroot -${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
     func_stat_check $?
  fi
 }

func_app_prereq()
{
    func_print_head "adding application user"
    id ${app_user} &>>$log_file

    if [ $? -ne 0 ]; then
      useradd ${app_user}
    fi
    func_stat_check $?

    func_print_head "setting app directory"
    rm -rf /app
    mkdir /app

    func_print_head "downloading the app code and unzipping it"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?
    cd /app
    unzip /tmp/${component}.zip &>>$log_file
    func_stat_check $?

}
func_systemd_setup(){
    func_print_head "coping catalogue service files"
    cp ${script_path}//${component}.service  /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?

    func_print_head "starting catalogue service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}

}
func_nodejs()
{
  func_print_head "NodeJS repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_stat_check $?

  func_print_head "Install NodeJS"
  yum install nodejs -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "installing dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_schema_setup
  func_systemd_setup

}
func_java()
{
  func_print_head "install maven"
  yum install maven -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "download the dependencies & build the application"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_stat_check $?

  func_schema_setup
  func_systemd_setup
}
func_python(){

  func_print_head "Installing Python"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "Download the dependencies"
  cd /app
  pip3.6 install -r requirements.txt &>>$log_file
  func_stat_check $?

  func_print_head "update passwords in systemD service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}//payment.service &>>$log_file
  func_stat_check $?

  func_systemd_setup

}
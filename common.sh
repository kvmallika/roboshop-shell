app_user=roboshop
func_print_head(){
  echo -e "\e[31m ***** $1 ***** \e[0m"
}
func_schema_setup() {
  if [ "schema_setup" == "mongo" ]; then

    func_print_head "coping mongodb repo files"
    cp ${script_path}//mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head "installing mongodb client"
    yum install mongodb-org-shell -y

    func_print_head "load schema"
    mongo --host mongodb-dev.vemdevops.online </app/schema/${component}.js
 fi
 if [ "schema_setup" == "mysql" ]; then
     func_print_head "install MySQL client"
     yum install mysql -y

     func_print_head "Load Schema"
     mysql -h mysql-dev.vemdevops.online -uroot -${mysql_root_password} < /app/schema/${component}.sql
  fi
 }

func_app_prereq()
{
    func_print_head "adding application user"
    useradd ${app_user}

    func_print_head "setting app directory"
    rm -rf /app
    mkdir /app

    func_print_head "downloading the app code and unzipping it"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app
    unzip /tmp/${component}.zip

}
func_systemd_setup(){
    func_print_head "coping catalogue service files"
    cp ${script_path}//${component}.service  /etc/systemd/system/${component}.service

    func_print_head "starting catalogue service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}

}
func_nodejs()
{
  func_print_head "NodeJS repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install NodeJS"
  yum install nodejs -y

  func_app_prereq

  func_print_head "installing dependencies"
  npm install
  func_schema_setup
  func_systemd_setup

}
func_java()
{
  func_print_head "install maven"
  yum install maven -y

  func_app_prereq

  func_print_head "download the dependencies & build the application"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar


  func_schema_setup
  echo setup done
  func_systemd_setup
  echo complete the preocess
}
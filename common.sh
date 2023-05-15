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
}
func_nodejs()
{
  func_print_head "NodeJS repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install NodeJS"
  yum install nodejs -y

  func_print_head "adding application user"
  useradd ${app_user}

  func_print_head "creating app directory"
  rm -rf /app
  mkdir /app

  func_print_head "downloading application code"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head "unzip the app content"
  unzip /tmp/${component}.zip
  cd /app

  func_print_head "installing dependencies"
  npm install

  func_print_head "coping catalogue service files"
  cp ${script_path}//${component}.service  /etc/systemd/system/${component}.service

  func_print_head "starting catalogue service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

func_schema_setup

}
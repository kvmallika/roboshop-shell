script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m ***** install redis repo files ***** \e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

cho -e "\e[31m ***** enable the packages ***** \e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[31m ***** Install redis ***** \e[0m"
yum install redis -y

echo -e "\e[31m ***** updating the listen address ***** \e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[31m ***** start and enable redis service ***** \e[0m"
systemctl enable redis
systemctl restart redis
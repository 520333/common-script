#! /bin/bash
:<<node
1.modify SSH port shell       
2.modify logrotate count
version 1.0 
node
while :
do
        read -p "Please Enter New port number:" port
        case $port in
	#判断是否为数字
                [0-9]*) sed -i "18 i\Port $port" /etc/ssh/sshd_config
                        break
                ;;
                *) echo "please input digit"
                        continue
                ;;
        esac
done
echo "restart sshd.service..." 
systemctl restart sshd.service
check_status=`systemctl  status rsyslog |grep -E 'running|dead'`
b=`echo "$check_status" |grep -oE 'running|dead'`
echo -e "sshd status:            [\033[1;32m$b\033[0m]"

sleep 2

count(){
        check_num=`awk 'NR==6{print $2}'  /etc/logrotate.conf `
}
#检查日志服务状态
e=`systemctl  status rsyslog |grep -E 'running|dead'`
b=`echo "$e" |grep -oE 'running|dead'`
echo -e "current rsyslog status: [\033[1;32m$b\033[0m]"
#检查当前日志数量
count
echo -e "current Logrotate count is: \033[1;32m$check_num\033[0m"
#设置新的日志数
while :
do
        read -p "Please Enter Logrotate count:"  set_num
        case $set_num in
        #判断是否为数字
                [0-9]*) sed -ir "6s/[0-9]\+/$set_num/" /etc/logrotate.conf
                        break
                ;;
                *) echo "please input digit"
                        continue
                ;;
        esac
done
#显示最新的日志数
count
echo -e "New Logrotate count is: \033[1;32m$check_num\033[0m"
#重新加载rsyslog服务
echo "restart rsyslog service"
systemctl  restart rsyslog
e=`systemctl  status rsyslog |grep -E 'running|dead'`
b=`echo "$e" |grep -oE 'running|dead'`
echo -e "rsyslog status :       [\033[1;32m$b\033[0m]"

#read port
#sed -ir "17s/#Port 22/Port $port/" /etc/ssh/sshd_config;
#sed -ir '17s/#//' /etc/ssh/sshd_config;sed -ir '17s/[0-9]\+/5022/' /etc/ssh/sshd_config

#sed -ir '17s/#//' -e '17s/[0-9]\+/5022/' /etc/ssh/sshd_config
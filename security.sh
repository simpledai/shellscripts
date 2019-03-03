#!/bin/bash
ENFORCE_NUM=`grep -c "SELINUX=enforcing" /etc/selinux/config`
if [ $ENFORCE_NUM -eq 1 ];then
{   
   sed -i "s#SELINUX=enforcing#SELINUX=disabled#g" /etc/selinux/config >/dev/null 2>&1 
   setenforce 0 
} && echo "selinux is disabled"

else
  echo "selinux is already changed ,you need not do it again "
fi

#history_size 
HISIZE_NUM=`grep -c "HISTSIZE=1000" /etc/profile`
if [ $HISIZE_NUM -eq 1  ];then
 { 
   sed -i  "s#HISTSIZE=1000#HISTSIZE=6000#g" /etc/profile  
   echo "HISTSIZE is changed to 6000"
 }

else
  echo " HISTSIZE is  already changed to 6000, you need not do it again"
fi 





## onboot shutdown firewalld \NetworkManager
systemctl disable NetworkManager.service  && systemctl disable firewalld 

#kernel about tcp
net_num=`grep -n "^net.ipv4" /etc/sysctl.conf | wc -l` 
#echo $net_num
[ $net_num -eq 0 ] && {
echo 'net.ipv4.tcp_tw_reuse = 1 '    >> /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_recycle = 1 '  >> /etc/sysctl.conf 
echo 'net.ipv4.tcp_fin_timeout = 5'  >> /etc/sysctl.conf
/sbin/sysctl -p > /dev/null 2>&1 
} || echo " the tcp_kernel is already changed ,you need not do it again"




useDNS_num=`grep -n "#UseDNS yes" /etc/ssh/sshd_config | wc -l`
if [ $useDNS_num -eq 0 ];then 
	echo "the ssh configuration UseDNS is already changed ,you need not do it again"
else
	sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config 
fi

systemctl restart sshd.service  >/dev/null 2>&1





GSSNUM=`grep -n "GSSAPIAuthentication no" /etc/ssh/sshd_config | wc -l`
if [ $GSSNUM -eq 0 ];then
        echo "the ssh configuration GSSAPI is already changed ,you need not do it again"
else
        sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
fi




HISFORMAT_line_number=`grep "HISTTIMEFORMAT" /etc/profile | wc -l `
if [ $HISFORMAT_line_number -eq 0 ];then
   echo "HISTTIMEFORMAT='%F %T  '" >> /etc/profile
   source /etc/profile 
   echo "HISTTIMEFORMAT is changed justnow"
else
   echo "HISTTIMEFORMAT is already changed,you need not do it again "
fi


#nofile limits 
num_limits=`grep "soft nofile" /etc/security/limits.conf | wc -l `
#echo $num_limits
[ $num_limits -eq 0 ] && {

echo "* soft nofile 102400"  >> /etc/security/limits.conf
echo "* hard nofile 102400"  >> /etc/security/limits.conf 
echo "* soft core unlimited" >> /etc/security/limits.conf
echo "ulimit -c unlimited"   >> /etc/profile
} || {
echo " limit already finish，you need not do it again"
}





#delete tty 
echo "console" > /etc/securetty
echo "vc/1"   >> /etc/securetty
echo "tty1"   >> /etc/securetty



#kernel about tcp
net_num=`grep -n "^net.ipv4" /etc/sysctl.conf | wc -l` 
#echo $net_num
[ $net_num -eq 0 ] && {
echo 'net.ipv4.tcp_tw_reuse = 1 '    >> /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_recycle = 1 '  >> /etc/sysctl.conf 
echo 'net.ipv4.tcp_fin_timeout = 5'  >> /etc/sysctl.conf
/sbin/sysctl -p > /dev/null 2>&1 
} || echo "the tcp_kernel is already changed，you need not do it again "



# del system useless users 
num=`awk -F ":" '{print $1}' /etc/passwd | egrep "adm|lp|sync|shutdown|halt|news|uucp|operator|games|gopher"  | wc -l`
if [ $num -eq 0 ];then
  printf "the useless number is %s , you need not  to del again \n" $num 
else

  for i in `awk -F ":" '{print $1}' /etc/passwd | egrep "adm|lp|sync|shutdown|halt|news|uucp|operator|games|gopher" `;do
    userdel -r $i >/dev/null 2>&1 
  done
  echo "...................................useless user is deleted....................................................."
fi


# del system useless group 
group_num=`awk -F ":" '{print $1}' /etc/group | egrep "adm|lp|news|uucp|games|dip|pppusers|popusers|slipusers" | wc -l `

if [ $group_num -gt 0 ];then 
  for j in `awk -F ":" '{print $1}' /etc/group | egrep "adm|lp|news|uucp|games|dip|pppusers|popusers|slipusers"`;do
    groupdel $j >/dev/null 2>&1
  done
  echo "..................................uselsess group is deleted...................................................."

else
  printf "the useless group number is %s ,there is no need to del again\n" $group_num

fi



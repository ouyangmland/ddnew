#!/bin/sh

MAINIP=$(ip route get 1 | awk '{print $NF;exit}')
GATEWAYIP=$(ip route | grep default | awk '{print $3}')
SUBNET=$(ip -o -f inet addr show | awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}' | head -1 | awk -F '/' '{print $2}')

value=$(( 0xffffffff ^ ((1 << (32 - $SUBNET)) - 1) ))
NETMASK="$(( (value >> 24) & 0xff )).$(( (value >> 16) & 0xff )).$(( (value >> 8) & 0xff )).$(( value & 0xff ))"

wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh

clear
echo "                                                      "
echo "######################################################"
echo "#                                                     "
echo "#  Auto DD                                            "
echo "#                                                     "
echo "#  Author: hiCasper                                   "
echo "#  Blog: https://blog.hicasper.com                    "
echo "#  Last Modified: 2019-06-24                          "
echo "#                                                     "
echo "#  Supported by MoeClub                               "
echo "#                                                     "
echo "######################################################"
echo "                                                      "
echo "IP: $MAINIP"
echo "Gateway: $GATEWAYIP"
echo "Netmask: $NETMASK"
echo ""
echo "Please select an OS:"
echo "  1) CentOS 7 (DD)"
echo "  2) CentOS 6 (Aliyun mirror)"
echo "  3) CentOS 6"
echo "  4) Debian 9"
echo "  5) Ubuntu 16.04"
echo "  6) Ubuntu 18.04"
echo ""
echo -n "Your option: "
read N
case $N in
  1) echo "Password: Pwd@CentOS" ; read -s -n1 -p "Press any key to continue..." ; bash InstallNET.sh --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $NETMASK -dd 'https://api.moetools.net/get/centos-7-image' ;;
  2) bash InstallNET.sh -c 6.9 -v 64 -a --mirror 'http://mirrors.aliyun.com/centos-vault' --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $SUBNET ;;
  3) bash InstallNET.sh -c 6.9 -v 64 -a --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $NETMASK ;;
  4) bash InstallNET.sh -d 9 -v 64 -a --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $NETMASK ;;
  5) bash InstallNET.sh -u 16.04 -v 64 -a --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $NETMASK ;;
  6) bash InstallNET.sh -u 18.04 -v 64 -a --ip-addr $MAINIP --ip-gate $GATEWAYIP --ip-mask $NETMASK ;;
  *) echo "Wrong input!" ;;
esac

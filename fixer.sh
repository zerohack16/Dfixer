#!/bin/bash
# Descripción: mini script para la instalación de Let's encrypt en directadmin.
#Author: Juan Rangel

#bastionx rainbow
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

echo "++++++++++++++++++++++++++++++++++++"
printf "${RED}"
echo "++++++++++++++++++++++++++++++++++++"
# it will fix Diego's lazy ass VPS image
# Update Server Software
printf "${RED}+++++++++ updating server software +++++++++ "
printf "${NORMAL} "
/usr/local/cpanel/scripts/rpmup
# System Update
printf "${RED}+++++++++ Perfoming system update (this one takes time) +++++++++ "
printf "${NORMAL} "
/usr/local/cpanel/scripts/sysup 
# Upgrade cPanel
printf "${RED}+++++++++ Updating cPanel +++++++++ "
printf "${NORMAL} "
/usr/local/cpanel/scripts/upcp
# Revisa la versión de cPanel
printf "${RED}+++++++++ Checking cPanel version +++++++++ "
printf "${NORMAL} "
/usr/local/cpanel/cpanel -V 
printf "${RED}+++++++++ removing troublesome packages for a clean start +++++++++ "
printf "${NORMAL} "
yum -y remove ea-php-cli-lsphp-1.0.0-11.16.2.cpanel.x86_64 ea-brotli-1.0.9-2.2.2.cpanel.x86_64 ea-php71-runtime-7.1.33-6.6.2.cpanel.x86_64 ea-php56-runtime-5.6.40-7.9.2.cpanel.x86_64 ea-php55-runtime-5.5.38-11.13.2.cpanel.x86_64 ea-php70-runtime-7.0.33-7.9.2.cpanel.x86_64 ea-libtidy-5.4.0-3.3.2.cpanel.x86_64
printf "${RED}+++++++++ perfomning a yum-complete-transaction --cleanup-only +++++++++  "
printf "${NORMAL} "
yum install yum-utils
yum-complete-transaction --cleanup-only
printf "${RED}+++++++++ checking and fixing cpanel rpms +++++++++  "
printf "${NORMAL} "
scripts/check_cpanel_pkgs
printf "${RED}+++++++++ rebuilding php fpm config +++++++++ "
printf "${NORMAL}"
/scripts/php_fpm_config --rebuild
printf "${RED}+++++++++ updating cpanel +++++++++ "
printf "${NORMAL} "
/scripts/upcp 

printf "${RED}+++++++++ overwriting csf config +++++++++ "
printf "${NORMAL} "
echo > /etc/csf/csf.conf
wget https://cucei.com.mx/fixer/csf
cat csf > /etc/csf/csf.conf
printf "${RED}+++++++++ restarting csf +++++++++ "
printf "${NORMAL} "
csf -r

printf "${RED}+++++++++ settin up port 3500 on SSH +++++++++ "
printf "${NORMAL} "
sed -i 's/#Port 22/Port 3500/g' /etc/ssh/sshd_config;
sed -i 's/Port 22/Port 3500/g' /etc/ssh/sshd_config;
printf "${RED}+++++++++ restarting ssh +++++++++ "
printf "${NORMAL} "
service sshd restart
printf "${RED}+++++++++ do not forget to try it out! +++++++++ "
printf "${NORMAL} "


printf "${RED}+++++++++ applying the new ea4 profile +++++++++ "
printf "${NORMAL} "
wget https://cucei.com.mx/fixer/vpsnbx.json
# Crea el nuevo profile de EA4
touch /etc/cpanel/ea4/profiles/custom/vpsnbx.json
cat vpsnbx.json > /etc/cpanel/ea4/profiles/custom/vpsnbx.json
# Revisa el nuevo profile de EA4
#/usr/local/cpanel/3rdparty/perl/530/bin/json_pp -t null < /etc/cpanel/ea4/profiles/custom/vpsnbx.json
printf "${RED}+++++++++ installing! +++++++++ "
printf "${NORMAL} "
# Instala profile en EA4
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/vpsnbx.json

printf "${RED}+++++++++ limpieza de yum +++++++++ "
printf "${NORMAL} "
yum clean all

printf "${RED}+++++++++ upgrade final +++++++++ "
printf "${NORMAL} "
yum upgrade

printf "${RED}+++++++++ Termina el proceso +++++++++ "
printf "${NORMAL} :D"
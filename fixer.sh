#!/bin/bash
# Descripción: mini script para la instalación de Let's encrypt en directadmin.
#Author: Juan Rangel
echo "++++++++++++++++++++++++++++++++++++"
echo "Dfixer script"
echo "++++++++++++++++++++++++++++++++++++"
# it will fix Diego's lazy ass VPS image
# Update Server Software
echo "+++++++++ updating server software +++++++++ "
/usr/local/cpanel/scripts/rpmup
# System Update
echo "+++++++++ Perfoming system update (this one takes time) +++++++++ "
/usr/local/cpanel/scripts/sysup 
# Upgrade cPanel
echo "+++++++++ Updating cPanel +++++++++ "
/usr/local/cpanel/scripts/upcp
# Revisa la versión de cPanel
echo "+++++++++ Checking cPanel version +++++++++ "
/usr/local/cpanel/cpanel -V 
echo "+++++++++ removing troublesome packages for a clean start +++++++++ "
yum -y remove ea-php-cli-lsphp-1.0.0-11.16.2.cpanel.x86_64 ea-brotli-1.0.9-2.2.2.cpanel.x86_64 ea-php71-runtime-7.1.33-6.6.2.cpanel.x86_64 ea-php56-runtime-5.6.40-7.9.2.cpanel.x86_64 ea-php55-runtime-5.5.38-11.13.2.cpanel.x86_64 ea-php70-runtime-7.0.33-7.9.2.cpanel.x86_64 ea-libtidy-5.4.0-3.3.2.cpanel.x86_64
echo "+++++++++ perfomning a yum-complete-transaction --cleanup-only +++++++++  "
yum install yum-utils
yum-complete-transaction --cleanup-only
echo "+++++++++ checking and fixing cpanel rpms +++++++++  "
scripts/check_cpanel_pkgs
echo "+++++++++ rebuilding php fpm config +++++++++ "
/scripts/php_fpm_config --rebuild
echo "+++++++++ updating cpanel +++++++++ "
/scripts/upcp 

echo "+++++++++ overwriting csf config +++++++++ "
echo > /etc/csf/csf.conf
gwet https://cucei.com.mx/fixer/csf
cat csf > /etc/csf/csf.conf
echo "+++++++++ restarting csf +++++++++ "
csf -r

echo "+++++++++ settin up port 3500 on SSH +++++++++ "
sed -i 's/#Port 22/Port 3500/g' /etc/ssh/sshd_config;
sed -i 's/Port 22/Port 3500/g' /etc/ssh/sshd_config;
echo "+++++++++ restarting ssh +++++++++ "
service sshd restart
echo "+++++++++ do not forget to try it out! +++++++++ "


echo "+++++++++ applying the new ea4 profile +++++++++ "
wget https://cucei.com.mx/fixer/vpsnbx.json
# Crea el nuevo profile de EA4
touch /etc/cpanel/ea4/profiles/custom/vpsnbx.json
cat vpsnbx.json > /etc/cpanel/ea4/profiles/custom/vpsnbx.json
# Revisa el nuevo profile de EA4
/usr/local/cpanel/3rdparty/perl/530/bin/json_pp -t null < /etc/cpanel/ea4/profiles/custom/vpsnbx.json
echo "+++++++++ installing! +++++++++ "
# Instala profile en EA4
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/vpsnbx.json

echo "+++++++++ limpieza de yum +++++++++ "
yum clean all

echo "+++++++++ upgrade final +++++++++ "
yum upgrade
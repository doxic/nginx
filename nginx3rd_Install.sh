#!/bin/bash
# Nginx Install Magic

# exit the script if any statement returns a non-true return value
set -e
# exit the script if any uninitialised variable
set -u
# check for root
[ $EUID -ne 0 ] && { echo "You must be a root user"; exit 1; }

#-----------------------------------------
# Install
#-----------------------------------------

# Install compiled files
make install || { echo "Installation failed"; exit 1; }

# create system account if not existent
id -u nginx &>/dev/null && echo "User exists" || useradd -r nginx

# download init.d script and make executable
#curl -o /etc/init.d/nginx https://gist.githubusercontent.com/doxic/4917727d7f9558981646f783c9b5b043/raw/94c24d0f2d69d035e7195564961a19e38535676b/etc-init.d-nginx || { echo "init.d Script ${red}not downloaded${reset}"; }
#chmod +x /etc/init.d/nginx

# Add service and set runlevel
# chkconfig --add nginx
# chkconfig --level 345 nginx on
systemctl enable nginx

# Create folder structure
mkdir -p /etc/nginx/sites-available/ /etc/nginx/sites-enabled/
mkdir -p /etc/nginx/conf.d/
mkdir -p /etc/nginx/ssl/
#!/bin/bash
# usage: installNginx.sh [nginxVersion] [opensslVersion] [pcreVersion] [zlibVersion]

# exit the script if any statement returns a non-true return value
set -e
# exit the script if any uninitialised variable
set -u
# check for root
[ $EUID -ne 0 ] && { echo "You must be a root user"; exit 1; }

# Colorcodes
# http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# save script path
scriptPath=$(dirname $(readlink -f $0))

# create src directory and cd
mkdir -p ~/src && cd ~/src

#-------------------------------------------
# External Modules
#-------------------------------------------

# get nginx-sticky-module-ng

if [ -d "nginx-sticky-module-ng" ]; then 
    cd nginx-sticky-module-ng
    git pull
    cd ..
else 
    git clone https://github.com/pagespeed/ngx_pagespeed 
fi

# get ngx_pagespeed
if [ -d "ngx_pagespeed" ]; then 
    cd ngx_pagespeed
    git pull
    cd ..
else 
    git clone https://github.com/pagespeed/ngx_pagespeed 
fi


cd ~/src

#-------------------------------------------
# Dependencies
#-------------------------------------------
# check var $1, if not set use default
nginxVersion="${1:-1.10.0}"
opensslVersion="${2:-1.0.2h}"
pcreVersion="${3:-8.38}"
zlibVersion="${4:-1.2.8}"

# download and unpack nginx
[ -d nginx-$nginxVersion ] && echo "nginx-$nginxVersion found" || curl http://nginx.org/download/nginx-$nginxVersion.tar.gz | tar xvz

# symlink to nginx
rm -f nginx
ln -sf nginx-$nginxVersion nginx

# download and unpack openssl
[ -d openssl-$opensslVersion ] && echo "openssl-$opensslVersion found" || curl -L --tlsv1.1 https://www.openssl.org/source/openssl-$opensslVersion.tar.gz | tar xvz

# symlink to openssl
rm -f  openssl
ln -sf openssl-$opensslVersion openssl

# download and unpack pcre
[ -d pcre-$pcreVersion ] && echo "pcre-$pcreVersion found" || curl -L https://sourceforge.net/projects/pcre/files/pcre/8.38/pcre-$pcreVersion.tar.gz/download | tar xzv

# symlink to pcre
rm -f pcre
ln -sf pcre-$pcreVersion pcre

# download and upack zlib
[ -d zlib-$zlibVersion ] && echo "zlib-$zlibVersion found" || curl -L http://zlib.net/zlib-1.2.8.tar.gz | tar xvz

# smylink to zlib
rm -f zlib
ln -sf zlib-$zlibVersion zlib


# source build options
source $scriptPath/nginxBuildOptions.sh

#------------------------------------------
# Compiling
#------------------------------------------

# Preparing the nginx source
cd nginx
./configure ${ngxOptions[@]} || { echo "Configure failed"; exit 1; }

make || { echo "make failed"; exit 1;}

#-----------------------------------------
# Install
#-----------------------------------------

# Install compiled files
make install || { echo "Installation failed"; exit 1; }

# create system account if not existent
id -u nginx &>/dev/null && echo "User exists" || useradd -r nginx

# download init.d script and make executable
curl -o /etc/init.d/nginx https://gist.githubusercontent.com/doxic/4917727d7f9558981646f783c9b5b043/raw/94c24d0f2d69d035e7195564961a19e38535676b/etc-init.d-nginx || { echo "init.d Script ${red}not downloaded${reset}"; }
chmod +x /etc/init.d/nginx

# Add service and set runlevel
chkconfig --add nginx
chkconfig --level 345 nginx on

# Create folder structure
mkdir -p /etc/nginx/sites-available/ /etc/nginx/sites-enabled/
mkdir -p /etc/nginx/conf.d/

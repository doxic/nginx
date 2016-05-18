#!/bin/bash

# source build options
source $(dirname $(readlink -f $0))/nginxBuildOptions.sh

# create src directory and cd
mkdir -p ~/src && cd ~/src

# get nginx-sticky-module-ng
if cd nginx-sticky-module-ng; then git pull; else git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng; fi
cd ~/src

#-------------------------------------------
# Dependencies
#-------------------------------------------

nginxVersion=$1
nginxVersion="${nginxVersion:-1.10.0}"
opensslVersion=$2
opensslVersion="${opensslVersion:-1.0.2h}"
pcreVersion=$3
pcreVersion="${pcreVersion:-8.38}"
zlibVersion=$4
zlibVersion="${zlibVersion:-1.2.8}"

# download and unpack nginx
[ -d nginx-$nginxVersion ] && echo "nginx-$nginxVersion found" || curl http://nginx.org/download/nginx-$nginxVersion.tar.gz | tar xvz

# symlink to nginx
ln -sf nginx-$nginxVersion nginx

# download and unpack openssl
[ -d openssl-$opensslVersion ] && echo "openssl-$opensslVersion found" || curl -L --tlsv1.1 https://www.openssl.org/source/openssl-$opensslVersion.tar.gz | tar xvz

# symlink to openssl
ln -sf openssl-$opensslVersion openssl

# download and unpack pcre
[ -d pcre-$pcreVersion ] && echo "pcre-$pcreVersion found" || curl -L https://sourceforge.net/projects/pcre/files/pcre/8.38/pcre-$pcreVersion.tar.gz/download | tar xzv

# symlink to pcre
ln -sf pcre-$pcreVersion pcre

# download and upack zlib
[ -d zlib-$zlibVersion ] && echo "zlib-$zlibVersion found" || curl -L http://zlib.net/zlib-1.2.8.tar.gz | tar xvz

# smylink to zlib
ln -sf zlib-$zlibVersion zlib

# Preparing the nginx source
cd nginx
./configure ${ngxOptions[@]}

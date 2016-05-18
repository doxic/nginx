#!/bin/bash

# source build options
source $(dirname $(readlink -f $0))/nginxBuildOptions.sh

# create src directory and cd
mkdir -p ~/src && cd ~/src

# get nginx-sticky-module-ng
if cd nginx-sticky-module-ng; then git pull; else git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng; fi
cd ~/src

# set nginx version if not preset
nginxVersion=$1
nginxVersion="${nginxVersion:-1.10.0}"

# set openssl version if not preset
opensslVersion=$2
opensslVersion="${opensslVersion:-1.0.2h}"

# download and unpack nginx
[ -d nginx-$nginxVersion ] && echo "nginx-$nginxVersion found" || curl http://nginx.org/download/nginx-$nginxVersion.tar.gz | tar xvz

# symlink to nginx
ln -sf nginx-$nginxVersion nginx

# download and unpack openssl
[ -d openssl-$opensslVersion ] && echo "openssl-$opensslVersion found" || curl -L --tlsv1.1 https://www.openssl.org/source/openssl-$opensslVersion.tar.gz | tar xvz

# symlink to openssl
ln -sf openssl-$opensslVersion openssl

# Preparing the nginx source
cd nginx
./configure ${ngxOptions[@]}

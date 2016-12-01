#!/bin/bash
# Nginx Download Source Magic

nginxVersion="1.10.0"
opensslVersion="1.0.2h"
pcreVersion="8.38"
zlibVersion="1.2.8"

# exit the script if any statement returns a non-true return value
set -e
# exit the script if any uninitialised variable
set -u
# check for root
[ $EUID -ne 0 ] && { echo "You must be a root user"; exit 1; }

# create src directory and cd
mkdir -p /usr/local/src && cd /usr/local/src

#-------------------------------------------
# External Modules
#-------------------------------------------


# get nginx-sticky-module-ng

if [ -d "nginx-sticky-module-ng" ]; then 
    cd nginx-sticky-module-ng
    git pull
    cd ..
else 
    git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng
fi
cd /usr/local/src

# get ngx_pagespeed
if [ -d "ngx_pagespeed" ]; then 
    cd ngx_pagespeed
    git pull
    cd ..
else 
    git clone https://github.com/pagespeed/ngx_pagespeed 
fi
cd /usr/local/src

#-------------------------------------------
# Dependencies
#-------------------------------------------

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
[ -d zlib-$zlibVersion ] && echo "zlib-$zlibVersion found" || curl -L http://zlib.net/zlib-$zlibVersion.tar.gz | tar xvz

# smylink to zlib
rm -f zlib
ln -sf zlib-$zlibVersion zlib
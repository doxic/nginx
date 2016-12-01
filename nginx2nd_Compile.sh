#!/bin/bash
# Nginx Download Source Magic

# exit the script if any statement returns a non-true return value
set -e
# exit the script if any uninitialised variable
set -u
# check for root
[ $EUID -ne 0 ] && { echo "You must be a root user"; exit 1; }

#----------------------------------------------------
# Nginx Build Options
#----------------------------------------------------
ngxOptions=()
# user and group option for nginx worker as non-priviledged user
ngxOptions+=(\
"--user=nginx" \
"--group=nginx" \
)

# use default system paths /etc and /var/log
ngxOptions+=( \
"--prefix=/etc/nginx" \
"--sbin-path=/usr/sbin/nginx" \
"--conf-path=/etc/nginx/nginx.conf" \
"--pid-path=/var/run/nginx.pid" \
"--lock-path=/var/run/nginx.lock" \
"--error-log-path=/var/log/nginx/error.log" \
"--http-log-path=/var/log/nginx/access.log" \
)
# support debugging
# ngxOptions+=( "--with-debug" )

# gzip static module enables use of gzip
ngxOptions+=( \
"--with-http_gzip_static_module" \
"--with-zlib=/usr/local/src/zlib" )

# stub status module is recommended for getting stats
ngxOptions+=( "--with-http_stub_status_module" )

# enables to match routes via Regular Expression Matching when defining routes
ngxOptions+=( "--with-pcre=/usr/local/src/pcre" )

# enables asynchronous I/O
ngxOptions+=( "--with-file-aio" )

# getting the IP of the client when behind a load balancer
ngxOptions+=( "--with-http_realip_module" )

# provides support for HTTP/2
ngxOptions+=( "--with-http_v2_module" )

# use openssl from source
ngxOptions+=( \
"--with-http_ssl_module" \
"--with-openssl=/usr/local/src/openssl" )

# MODULES -------------------------------------------
# use sticky module addon
#ngxOptions+=( "--add-module=$(readlink -f ~/src/nginx-sticky-module-ng/)" )
# use ngx_pagespeed
#ngxOptions+=(" --add-module=$(readlink -f ~/src/ngx_pagespeed/)" )

# Exludes -------------------------------------------
ngxOptions+=( \
"--without-mail_pop3_module" \
"--without-mail_imap_module" \
"--without-mail_smtp_module" \
"--without-http_scgi_module" \
"--without-http_uwsgi_module" \
"--without-http_fastcgi_module" \
"--without-http_split_clients_module" \
"--without-http_map_module" \
"--without-http_geo_module" \
"--without-http_ssi_module" )
#"--without-http_rewrite_module" \

# GCC -----------------------------------------------
# sets additional parameters that will be added to the CFLAGS variable.
#ngxOptions+=( '--with-cc-opt="-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic"' )

#------------------------------------------
# Compiling
#------------------------------------------

# Preparing the nginx source
cd /usr/local/src/nginx
./configure ${ngxOptions[@]} || { echo "Configure failed"; exit 1; }

make || { echo "make failed"; exit 1;}
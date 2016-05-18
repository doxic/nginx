#----------------------------------------------------
# Build Options
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

# gzip static module enables use of gzip
ngxOptions+=( "--with-http_gzip_static_module" )

# stub status module is recommended for getting stats
ngxOptions+=( "--with-http_stub_status_module" )

# use openssl from source
ngxOptions+=( "--with-openssl=~/src/openssl" )

#----------------------------------------------------
# MODULES
#----------------------------------------------------

# use sticky module addon
ngxOptions+=( "--add-module=~/src/nginx-sticky-module-ng" )

#----------------------------------------------------
# WITHOUTS
#----------------------------------------------------
# exclude this modules
ngxOptions+=( \
"--without-http_rewrite_module" \
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

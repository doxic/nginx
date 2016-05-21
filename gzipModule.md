Source: https://www.digitalocean.com/community/tutorials/how-to-add-the-gzip-module-to-nginx-on-centos-7

# Creating Test Files
sudo truncate -s 1k html/test.html
sudo truncate -s 1k html/test.css
sudo truncate -s 1k html/test.js
sudo truncate -s 1k html/test.jpg

# Test Header
curl -H "Accept-Encoding: gzip" -I http://lavoisier.dosys.ch/test.css

# Enable gzip Module

##
# `gzip` Settings
#
#
gzip on;
# unsupported ie6
gzip_disable "msie6";

# propagate gzip to proxies
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;          # compression level
gzip_http_version 1.1;      # limit to http/1.1
gzip_min_length 256;        # do not compress under this limit
# MIME types
gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

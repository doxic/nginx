## README

Install, Docs and Update Nginx from Source.
Sources: digitalocean, samair

## Usage

### Dependencies

Install prerequisites 
    yum -y install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel git patch

### Install

Create src directory
    mkdir -p ~/src && cd ~/src


init.d script
    curl -o /etc/init.d/nginx https://gist.githubusercontent.com/doxic/4917727d7f9558981646f783c9b5b043/raw/94c24d0f2d69d035e7195564961a19e38535676b/etc-init.d-nginx


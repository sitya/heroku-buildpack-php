#!/usr/bin/env bash
#
# Copy this file to your PHP applications /app folder and put the line below into your Procfile:
# web: /app/web.sh
#
# Fail fast
set -o pipefail
set -eu

export PATH="$HOME/.heroku/php/bin:$HOME/.heroku/php/sbin:$PATH"

APP_CONFIG=/app/config
ROOT=/app/.heroku/php

# This is your properly configured shibboleth2.xml
cp ${APP_CONFIG}/shibboleth2.xml ${ROOT}/etc/shibboleth/shibboleth2.xml

# There are the key and cert used by Shibboleth
cp ${APP_CONFIG}/*.pem  ${ROOT}/etc/shibboleth/

# Optionally here you can download the cert your federation's metadata is signed with
# wget -O ${ROOT}/etc/shibboleth/federaton-signer.crt https://federation.example.org/signer.crt

${ROOT}/sbin/shibd -p ${ROOT}/var/run/shibd.pid -w 30

# config/httpd.conf is your configured apache config file in /app/config folder
# web means that your DocumentRoot is /app/web
/app/vendor/bin/heroku-php-apache2 -c config/httpd.conf web

tail -f ${ROOT}/var/log/shibboleth/*.log

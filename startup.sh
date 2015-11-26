#!/bin/sh

exec 2>&1
set -e

sudo -u daemon -EH /usr/local/bin/update-site.sh
nginx -g 'daemon off;'
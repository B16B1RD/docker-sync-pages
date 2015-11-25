#!/bin/sh

sudo -u daemon -EH /usr/local/bin/update-site.sh

nginx -g 'daemon off;'

#!/bin/sh
# /docker-entrypoint.sh

############################
#                          #
# Set up all NAV cron jobs #
#                          #
############################
echo 'PATH="'"${PATH}"'"'>/tmp/nav.cron
cat /etc/nav/cron.d/* >> /tmp/nav.cron
cat /tmp/nav.cron | crontab -u nav -

/usr/bin/supervisord -n
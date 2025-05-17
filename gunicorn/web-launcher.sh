#!/bin/sh
/docker-entrypoint.sh
##########################################
#                                        #
# Verify permissions on writable volumes #
#                                        #
##########################################
chown -R nav /var/lib/nav/uploads/images/rooms

##########################################
#                                        #
#            Start gunicorn              #
#                                        #
##########################################
gunicorn

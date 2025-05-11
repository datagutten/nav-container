#!/bin/sh
/usr/bin/django-admin migrate --run-syncdb
mkdir -p "${GRAPHITE_STORAGE_DIR}" && chown _graphite:_graphite "${GRAPHITE_STORAGE_DIR}"
chown -R _graphite /var/log/graphite

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
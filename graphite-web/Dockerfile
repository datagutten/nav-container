FROM debian:bookworm-slim
LABEL description="A graphite-web instance for NAV"
LABEL maintainer="Morten Brekkevold <morten.brekkevold@sikt.no>"

# Add Tini
RUN apt-get update && apt-get install -y tini
ENTRYPOINT ["/usr/bin/tini", "--"]

ENV GRAPHITE_CONF_DIR=/etc/graphite
ENV GRAPHITE_STORAGE_DIR=/var/lib/graphite/whisper

RUN apt-get -y update && \
    apt-get -y install graphite-web supervisor nginx-light gunicorn

# Copy configuration files
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY local_settings.py ${GRAPHITE_CONF_DIR}/local_settings.py
COPY launcher.sh /launcher.sh
RUN chmod +x /launcher.sh

ENV DJANGO_SETTINGS_MODULE=graphite.settings
ENV GRAPHITE_SETTINGS_MODULE=local_settings

USER root

EXPOSE 80
VOLUME ["/var/lib/graphite/whisper"]
CMD ["/launcher.sh"]
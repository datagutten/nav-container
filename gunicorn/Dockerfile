ARG NAV_VERSION=master

FROM ghcr.io/datagutten/nav-base:${NAV_VERSION}
COPY ./gunicorn.conf.py ./gunicorn.conf.py
RUN pip install gunicorn

COPY web-launcher.sh /
RUN chmod +x /web-launcher.sh

RUN mkdir -p /usr/local/share/nav/var && \
    ln -s /var/lib/nav/uploads /usr/local/share/nav/var/uploads

CMD ["/web-launcher.sh"]
VOLUME ["/var/log/nav", "/var/lib/nav/uploads/images/rooms"]
EXPOSE 8000
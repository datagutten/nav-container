FROM python:3.11-bookworm AS builder

RUN apt-get update \
    && apt-get -y install \
    git libldap2-dev libsasl2-dev libjpeg-dev libgammu-dev

# Build wheels from requirements so they can be re-used in a production image
# without installing all the dev tools there too
RUN pip3 install --upgrade pip
RUN mkdir /.cache && chmod 777 /.cache

RUN mkdir /source
WORKDIR /source
ARG NAV_VERSION=master
RUN git clone https://github.com/Uninett/nav.git nav --branch ${NAV_VERSION} --depth 1
RUN mkdir -p .wheels
RUN --mount=type=cache,target=/root/.cache/pip pip3 wheel -w ./.wheels/ -r nav/requirements.txt -c nav/constraints.txt python-gammu==3.2.4
RUN --mount=type=cache,target=/root/.cache/pip pip3 install --root="/source/.build" ./nav

# Now, build the actual installation stage
FROM python:3.11-slim-bookworm

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
       tini \
       libsnmp40 \
       pwgen \
       nbtscan \
       libpq5 \
       git \
       gpg \
       postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Use tini as our image init process
ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

ARG NAV_VERSION=master
LABEL description="Network Administration Visualized ${NAV_VERSION}"

# Install python module dependencies, assuming they have already been made
# available as wheels
COPY --from=builder /source/nav/requirements/ /requirements
COPY --from=builder /source/nav/requirements.txt /
COPY --from=builder /source/nav/constraints.txt /
COPY --from=builder /source/.wheels/ /wheelhouse
RUN --mount=type=cache,target=/root/.cache/pip pip3 install --no-index --find-links=/wheelhouse -r requirements.txt -c constraints.txt

# Install NAV itself
RUN adduser --system --group --home=/usr/local/nav --shell=/bin/bash nav
COPY --from=builder /source/.build/ /
RUN mkdir /etc/nav &&  chown nav /etc/nav && su nav -c 'nav config install /etc/nav'
RUN mkdir /var/log/nav && chown nav /var/log/nav

# Install our config and entrypoints
COPY docker-entrypoint.sh /
COPY docker-initdb.sh /

RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /docker-initdb.sh

# Final environment
ENV    PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin
ENV    ADMIN_MAIL=root@localhost
ENV    DEFAULT_FROM_EMAIL=nav@localhost
ENV    DOMAIN_SUFFIX=.example.org
ENV    NAV_CONFIG_DIR=/etc/nav

VOLUME ["/var/log/nav", "/var/lib/nav/uploads/images/rooms"]
EXPOSE 8000

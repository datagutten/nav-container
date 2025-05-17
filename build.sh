#!/bin/bash
set -e
NAV_VERSION=$1

echo "Build NAV version ${NAV_VERSION}"

docker build --build-arg NAV_VERSION="${NAV_VERSION}" -t docker.datagutten.net/nav-base:${NAV_VERSION} -t nav-base:${NAV_VERSION} .
docker build --build-arg NAV_VERSION="${NAV_VERSION}" nav-backend -t docker.datagutten.net/nav-backend:${NAV_VERSION}
docker build --build-arg NAV_VERSION="${NAV_VERSION}" carbon-cache -t docker.datagutten.net/nav-carbon-cache
docker build --build-arg NAV_VERSION="${NAV_VERSION}" graphite-web -t docker.datagutten.net/nav-graphite-web
docker build --build-arg NAV_VERSION="${NAV_VERSION}" gunicorn -t docker.datagutten.net/nav-gunicorn:${NAV_VERSION}
docker build --build-arg NAV_VERSION="${NAV_VERSION}" nginx -t docker.datagutten.net/nav-nginx:${NAV_VERSION}

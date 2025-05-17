#!/bin/bash
set -e
NAV_VERSION=$1

echo "Build NAV version ${NAV_VERSION}"

docker build --build-arg NAV_VERSION="${NAV_VERSION}" . -t ghcr.io/datagutten/nav-base:${NAV_VERSION} -t nav-base:${NAV_VERSION}
docker build --build-arg NAV_VERSION="${NAV_VERSION}" nav-backend -t ghcr.io/datagutten/nav-backend:${NAV_VERSION}
docker build --build-arg NAV_VERSION="${NAV_VERSION}" carbon-cache -t ghcr.io/datagutten/nav-carbon-cache
docker build --build-arg NAV_VERSION="${NAV_VERSION}" graphite-web -t ghcr.io/datagutten/nav-graphite-web
docker build --build-arg NAV_VERSION="${NAV_VERSION}" gunicorn -t ghcr.io/datagutten/nav-gunicorn:${NAV_VERSION}
docker build --build-arg NAV_VERSION="${NAV_VERSION}" nginx -t ghcr.io/datagutten/nav-nginx:${NAV_VERSION}

#!/usr/bin/env bash
wget \
  --no-check-certificate -qO - \
  https://api.github.com/repos/Uninett/nav/releases/latest \
  | awk '/tag_name/{print $4;exit}' FS='[""]' \
  > latest_version.txt
export NAV_VERSION=$(cat latest_version.txt)

./build.sh "${NAV_VERSION}"

docker tag docker.datagutten.net/nav-base:${NAV_VERSION} docker.datagutten.net/nav-base:latest
docker tag docker.datagutten.net/nav-backend:${NAV_VERSION} docker.datagutten.net/nav-backend:latest
docker tag docker.datagutten.net/nav-gunicorn:${NAV_VERSION} docker.datagutten.net/nav-gunicorn:latest
docker tag docker.datagutten.net/nav-nginx:${NAV_VERSION} docker.datagutten.net/nav-nginx:latest

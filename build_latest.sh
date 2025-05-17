#!/usr/bin/env bash
wget \
  --no-check-certificate -qO - \
  https://api.github.com/repos/Uninett/nav/releases/latest \
  | awk '/tag_name/{print $4;exit}' FS='[""]' \
  > latest_version.txt
export NAV_VERSION=$(cat latest_version.txt)

./build.sh "${NAV_VERSION}"

docker tag ghcr.io/datagutten/nav-base:${NAV_VERSION} ghcr.io/datagutten/nav-base:latest
docker tag ghcr.io/datagutten/nav-backend:${NAV_VERSION} ghcr.io/datagutten/nav-backend:latest
docker tag ghcr.io/datagutten/nav-gunicorn:${NAV_VERSION} ghcr.io/datagutten/nav-gunicorn:latest
docker tag ghcr.io/datagutten/nav-nginx:${NAV_VERSION} ghcr.io/datagutten/nav-nginx:latest

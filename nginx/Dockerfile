ARG NAV_VERSION=master

FROM nav-base:$NAV_VERSION AS static
RUN mkdir -p /usr/local/share/nav/var/uploads
RUN django-admin collectstatic --noinput --settings=nav.django.settings


FROM node AS css
ARG NAV_VERSION=master

RUN git clone https://github.com/Uninett/nav.git nav --branch $NAV_VERSION --depth 1
WORKDIR /nav
RUN mkdir -p python/nav/web
RUN npm install
RUN npm run build:sass


#FROM python:3.10 AS doc
#COPY --from=css /nav/doc
#RUN sed -i s/sphinx_rtd_theme/sphinx-rtd-theme/ /doc/requirements.txt # Fix typo in doc/requirements.txt


FROM nginx:latest
COPY --from=static /usr/local/share/nav/www/static /home/app/nav/static
COPY --from=css /nav/python/nav/web/static /home/app/nav/static

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

ARG NAV_VERSION=master
FROM nav-base:$NAV_VERSION
RUN apt-get update && apt-get -y install snmptrapd cron supervisor

COPY etc/ /etc

COPY launcher.sh /
RUN chmod +x /launcher.sh

CMD ["/launcher.sh"]
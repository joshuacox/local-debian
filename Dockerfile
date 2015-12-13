FROM local-jessie
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV DOCKER_PROTOTYPE 20151210
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update; \
apt-get -y dist-upgrade; \
apt-get -y install locales; \
echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen; \
locale-gen; \
apt-get -y autoremove; \
apt-get clean; \
rm -rf /var/lib/apt/lists/*
# RUN apt-get -y install python-software-properties curl build-essential libxml2-dev libxslt-dev git ruby ruby-dev ca-certificates sudo net-tools vim wget

ENV LANG en_US.UTF-8
# This block became necessary with the new chef 12
# RUN echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen
# RUN echo 'en_US ISO-8859-1'>>/etc/locale.gen


CMD ["/bin/bash"]

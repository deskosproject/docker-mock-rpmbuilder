FROM centos:centos7
MAINTAINER Ricardo Arguello <rarguello@deskosproject.org>

RUN yum -y update && yum -y install epel-release && yum -y install mock rpmdevtools
RUN useradd -u 1000 builder && usermod -a -G mock builder

VOLUME ["/mock"]
RUN echo "config_opts['cache_topdir'] = '/mock/cache'" >> /etc/mock/site-defaults.cfg

ADD ./build.sh /build.sh
RUN chmod +x /build.sh

USER builder
ENV HOME /home/builder
CMD ["/build.sh"]

FROM centos:7
MAINTAINER Mikko Rauhala <mikko@rauhala.net>

ENV http_proxy http://wwwcache.fmi.fi:8080
ENV https_proxy http://wwwcache.fmi.fi:8080

RUN rpm -ivh https://download.fmi.fi/smartmet-open/rhel/7/x86_64/smartmet-open-release-17.9.28-1.el7.fmi.noarch.rpm \
    	     https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	     https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm

RUN sed -i '/\[smartmet-open\]/a exclude=smartmet-library-*' /etc/yum.repos.d/smartmet-open.repo
RUN cat /etc/yum.repos.d/smartmet-open.repo
RUN yum install -y rpmdevtools gcc-c++ make createrepo yum-utils git sudo wget && \
    yum clean all && \
    rm -r -f /var/cache/*
ADD docker-rpmbuild.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-rpmbuild.sh
ADD local.repo /etc/yum.repos.d/
RUN echo ip_resolve=4 >> /etc/yum.conf 

RUN useradd rpmbuild
RUN echo "rpmbuild ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rpmbuild
USER rpmbuild
RUN rpmdev-setuptree
RUN mkdir /home/rpmbuild/rpmbuild/RPMS/x86_64
USER root
RUN createrepo /home/rpmbuild/rpmbuild/RPMS/x86_64/
USER rpmbuild

ENTRYPOINT ["/usr/local/bin/docker-rpmbuild.sh"]

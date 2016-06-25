FROM centos:7

# Define args and set a default value
ARG maintainer=jay.p.h.johnson@gmail.com
ARG imagename=nginx
ARG registry=docker.io

MAINTAINER $maintainer
LABEL Vendor="Anyone"
LABEL ImageType="nginx"
LABEL ImageName=$imagename
LABEL ImageOS=$basename
LABEL Version=$version

RUN yum -y install epel-release; yum clean all
RUN yum -y install python-pip; yum clean all; pip install --upgrade pip

# Set default environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Allow triggerable events on the first time running
RUN touch /tmp/firsttimerunning

# Add Volumes and Set permissions
RUN mkdir -p -m 777 /root/shared \
    && mkdir -p -m 777 /root \
    && mkdir -p -m 777 /root/containerfiles

# Add the starters and installers:
ADD ./containerfiles/ /root/containerfiles

RUN chmod 777 /root/containerfiles/*.sh

# Add the nginx repository
RUN cp /root/containerfiles/nginx.repo /etc/yum.repos.d/nginx.repo

# Intalling the nginx 
RUN yum -y install nginx

# Adding the default file
RUN cp /root/containerfiles/index.html /usr/share/nginx/html

# Run/Compose ENV Variables:
ENV ENV_BASE_NGINX_CONFIG /root/containerfiles/base_nginx.conf
ENV ENV_DERIVED_NGINX_CONFIG /root/containerfiles/derived_nginx.conf
ENV ENV_DEFAULT_ROOT_VOLUME /usr/share/nginx/html

# Port
EXPOSE 80 443

CMD ["/root/containerfiles/start-container.sh"]

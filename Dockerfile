# Ansible Tower Dockerfie

FROM ubuntu:14.04

MAINTAINER ybaltouski@gmail.com

ENV ANSIBLE_TOWER_VER 3.0.3
ENV PG_DATA /var/lib/postgresql/9.4/main
RUN apt update ; apt-get install -y software-properties-common ssh \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible

ADD https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz /opt/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz
# COPY ansible-tower-setup-3.0.3.tar.gz /opt/ansible-tower-setup-3.0.3.tar.gz

RUN cd /opt && ls -la && tar xvf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \ 
   && rm -rf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
   && mv ansible-tower-setup-${ANSIBLE_TOWER_VER} /opt/tower-setup


#ADD tower_setup_conf.yml /opt/tower-setup/tower_setup_conf.yml
ENV USER=root
ADD inventory /opt/tower-setup/inventory
#UN /etc/init.d/ssh start
#UN apt install vim -y
RUN cd /opt/tower-setup \
    && ./setup.sh

VOLUME ${PG_DATA}
VOLUME /certs

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 443 8080

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["ansible-tower"]

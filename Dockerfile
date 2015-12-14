# Cowrie Dockerfile by AV / MO 
#
# VERSION 16.03.1
FROM ubuntu:14.04.3
MAINTAINER AV

# Setup apt
RUN apt-get update -y && \
    apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get install -y supervisor python git python-twisted python-pycryptopp mysql-server python-mysqldb python-pyasn1 python-zope.interface

# Install cowrie from git
RUN git clone https://github.com/micheloosterhof/cowrie.git /opt/cowrie

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    mkdir -p /var/run/cowrie/
ADD userdb.txt /opt/cowrie/misc/userdb.txt
RUN chown tpot:tpot /var/run/cowrie
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD cowrie.cfg /opt/cowrie/
ADD setup.sql /root/

# Setup mysql
RUN sed -i 's#127.0.0.1#0.0.0.0#' /etc/mysql/my.cnf && \
    service mysql start && /usr/bin/mysqladmin -u root password "gr8p4$w0rd" && /usr/bin/mysql -u root -p"gr8p4$w0rd" < /root/setup.sql

# Setup ewsposter
RUN apt-get install -y python-lxml python-requests && \
    git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && cd /opt/hpfeeds && python setup.py install && \
    git clone https://github.com/armedpot/ewsposter.git /opt/ewsposter && \
    mkdir -p /opt/ewsposter/spool /opt/ewsposter/log

# Clean up 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /root/setup.sql

# Start supervisor
CMD ["/usr/bin/supervisord"]

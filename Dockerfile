# Cowrie Dockerfile by AV 
#
# VERSION 0.43
FROM ubuntu:14.04.3
MAINTAINER AV

# Setup apt
RUN apt-get update -y
RUN apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get install -y supervisor python git python-twisted python-pycryptopp mysql-server python-mysqldb python-pyasn1 python-zope.interfac

# Install cowrie from git
RUN git clone https://github.com/micheloosterhof/cowrie.git /opt/cowrie

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot 
RUN adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
RUN mkdir -p /data/cowrie/log/tty/ /data/cowrie/downloads/ /data/cowrie/keys/ /data/cowrie/misc/ /var/run/cowrie/
#RUN echo "root:0:123456" > /data/cowrie/misc/userdb.txt
ADD userdb.txt /data/cowrie/misc/userdb.txt
RUN chmod 760 -R /data && chown tpot:tpot -R /data && chown tpot:tpot /var/run/cowrie
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD cowrie.cfg /opt/cowrie/
ADD setup.sql /root/

# Setup mysql
RUN sed -i 's#127.0.0.1#0.0.0.0#' /etc/mysql/my.cnf
RUN service mysql start && /usr/bin/mysqladmin -u root password "gr8p4$w0rd" && /usr/bin/mysql -u root -p"gr8p4$w0rd" < /root/setup.sql

# Clean up 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm /root/setup.sql

# Start supervisor
CMD ["/usr/bin/supervisord"]

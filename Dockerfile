# Cowrie Dockerfile by AV / MO 
#
# VERSION 16.10
FROM debian:jessie
MAINTAINER AV / MO

# Include dist
ADD dist/ /root/dist/

# Setup apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    #apt-get upgrade -y && \

# Get and install dependencies & packages
    apt-get install --no-install-recommends -y supervisor python git libmpfr-dev libssl-dev \
        libmpc-dev libffi-dev gcc g++ libpython-dev ca-certificates curl python-pip && \

# Install cowrie from git
    git clone https://github.com/lelonek1/cowrie.git --branch telnetNegotiationErrors --single-branch --depth 1 /opt/cowrie && \
    
# Install Python dependencies
    #pip install -U pip && \
    pip install -r /opt/cowrie/requirements.txt && \
    
# Clean up apt
    apt-get remove git -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# Setup user, groups and configs
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    mkdir -p /var/run/cowrie/ /opt/cowrie/misc/ && \
    mv /root/dist/userdb.txt /opt/cowrie/misc/userdb.txt && \
    chown tpot:tpot /var/run/cowrie && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    mv /root/dist/cowrie.cfg /opt/cowrie/ && \

# Clean up dist
    rm -rf /root/dist

# Start supervisor
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]

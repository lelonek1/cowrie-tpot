# dockerized cowrie


[cowrie](http://www.micheloosterhof.com/cowrie/) is an extended fork of the medium interaction honeypot [kippo](https://github.com/desaster/kippo).

This repository contains the necessary files to create a *dockerized* version of cowrie.

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG.

The `Dockerfile` contains the blueprint for the dockerized cowrie and will be used to setup the docker image.  

The `cowrie.cfg` is tailored to fit the T-Pot environment.

The `setup.sql` is also tailored to fit the T-Pot environment.

The `supervisord.conf` is used to start cowrie under supervision of supervisord.

Using upstart, copy the file `upstart/cowrie.conf` to `/etc/init/cowrie.conf` and start cowrie using

    service cowrie start

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

By default all data will be stored in `/data/cowrie/` until the honeypot service will be restarted which is by default every 24 hours. If you want to keep data persistently simply rename `/data/persistence.off` to `/data/persistence.on`. Be advised to establish some sort of log management if you wish to do so.

# Cowrie Dashboard

![Cowrie Dashboard](https://raw.githubusercontent.com/dtag-dev-sec/cowrie/master/doc/dashboard.png)

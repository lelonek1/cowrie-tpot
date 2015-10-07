# dockerized cowrie


[cowrie](http://www.micheloosterhof.com/cowrie/) is an extended fork of the medium interaction honeypot [kippo](https://github.com/desaster/kippo). 

This repository contains the necessary files to create a *dockerized* version of cowrie. 

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG. 

The `Dockerfile` contains the blueprint for the dockerized cowrie and will be used to setup the docker image.  

The `cowrie.cfg` is tailored to fit the T-Pot environment. All important data is stored in `/data/cowrie/`.

The `setup.sql` is also tailored to fit the T-Pot environment. 

The `supervisord.conf` is used to start cowrie under supervision of supervisord. 

Using upstart, copy the file `upstart/cowrie.conf` to `/etc/init/cowrie.conf` and start cowrie using

    service cowrie start

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

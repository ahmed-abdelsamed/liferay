#!/bin/bash

#cp -p   /etc/my.cnf.d/mariadb-server.cnf  /etc/my.cnf.d/mariadb-server.cnf.org

/etc/my.cnf.d/galera.cnf

## Edit /etc/my.cnf.d/mariadb-server.cnf
# content in content/node-1-galera.cnf


# copy all configuration on other node before run below command
systemctl stop mariadb

galera_new_cluster

systemctl enable mariadb


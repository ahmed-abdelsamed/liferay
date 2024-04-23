#!/bin/bash

/etc/mysql/conf.d/galera.cnf

## Edit /etc/my.cnf.d/mariadb-server.cnf
# content in content/node-2-galera.cnf

systemctl enable --now mariadb


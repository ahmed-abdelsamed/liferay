#!/bin/bash

## on all nodes

sudo dnf update -y

## Install packages in troublshoting file

sudo dnf install mariadb-server -y


#dnf config-manager --set-enabled mariadb

#dnf install mariadb-server-galera --enablerepo=mariadb -y


systemctl start mariadb 

mariadb-secure-installation

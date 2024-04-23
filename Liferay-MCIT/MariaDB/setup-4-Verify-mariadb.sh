#!/bin/bash
#[https://www.server-world.info/en/note?os=CentOS_Stream_9&p=mariadb&f=5]

mysql -u admin -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"

mysql -u admin -p -e "show status like 'wsrep_%';"   # pass:admin


#create user 'lportalusr'@'localhost' identified by 'password123';
#grant all privileges on lportal.* to 'lportalusr'@'localhost' with grant option;
#flush privileges;
mariadb  -u root  -p


CREATE USER 'liferayuser'@'%' IDENTIFIED BY 'liferaypassword';
GRANT ALL PRIVILEGES ON *.* TO 'liferayuser'@'%';
flush privileges;






SELECT user,host FROM mysql.user;

DESC mysql.user

mariadb -u liferayuser -p

create database lportal character set utf8mb4 collate utf8mb4_unicode_ci;

show Databases;


### Check from external db_cluster
mariadb -h 192.168.100.63 -u liferayuser -p lportal;
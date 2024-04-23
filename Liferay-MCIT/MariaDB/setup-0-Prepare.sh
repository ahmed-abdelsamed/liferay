sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl stop firewalld 
sudo systemctl disable firewalld

# Add hosts entries (mocking DNS) - put relevant IPs here
echo "
10.30.61.191 webserver-dev webserver-dev.mcit.local
10.30.61.193 liferaydxp-dev liferaydxp-dev.mcit.local
10.30.61.192 elasticsearch-dev elasticsearch-dev.mcit.local
10.30.62.170 mariadb-dev mariadb-dev.mcit.local

" | sudo tee --append /etc/hosts



curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.6

cat /etc/yum.repos.d/mariadb.repo
#content mariadb.repo





# Add Repo 
#echo "[mariadb]
#name=Mariadb-10.6
#baseurl=https://archive.mariadb.org/mariadb-10.6.16/yum/centos/9/x86_64/
#gpgkey= https://archive.mariadb.org/PublicKey
#gpgcheck=1
#" | sudo tee --append /etc/yum.repos.d/mariadb-10.6.repo

# if Firewalld is running, allow ports
firewall-cmd --add-service=mysql --permanent
firewall-cmd --add-port={3306/tcp,4567/tcp,4568/tcp,4444/tcp,4567/udp} --permanent
#firewall-cmd --runtime-to-permanent
firewall-cmd --reload

# create new data disk and mount /var/lib/mysql
#mkdir /var/lib/mysql/logs/
#touch /var/lib/mysql/logs/mariadb.log

#chown -R mysql:mysql /var/lib/mysql/logs/
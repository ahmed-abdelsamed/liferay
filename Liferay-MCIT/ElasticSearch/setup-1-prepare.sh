#{https://youtu.be/gM90v79k08A}
# {https://qiita.com/mingchun_zhao/items/05dd4ed7197bd2e27d6e}

sudo dnf update
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 	If Firewalld is running, allow service ports on all Nodes. 
firewall-cmd --add-port={9200/tcp,9300/tcp}
firewall-cmd --runtime-to-permanent 
firewall-cmd --reload

echo "
192.168.100.65 els-1 els-1.linkdev.local
" | sudo tee --append /etc/hosts

dnf install  java-11-openjdk-devel  -y
java --version
 which java
/usr/bin/java


cat > /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-7.4.13]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF


## OR
sudo rpm -ivh https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.3-x86_64.rpm


sysctl -w fs.file-max=65536
#fs.file-max = 65536
sysctl -p
cat /proc/sys/fs/file-max
#65536


##  Edit in /etc/profile
export ES_JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-3.el9.x86_64"
export PATH=$ES_JAVA_HOME/bin:$PATH
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-3.el9.x86_64"
export PATH=$JAVA_HOME/bin:$PAT
export ES_JRE_HOME=/usr/lib/jvm/jre-11-openjdk-11.0.18.0.10-3.el9.x86_64
export PATH=$ES_JRE_HOME/bin:$PATH
export JRE_HOME=/usr/lib/jvm/jre-11-openjdk-11.0.18.0.10-3.el9.x86_64
export PATH=$JRE_HOME/bin:$PATH
export ES_HOME="/usr/share/elasticsearch"
export PATH=$ES_HOME/bin:$PATH





















## Edit  in /etc/profile  /opt/liferay-dxp-7.4.13.u80
export ES_JAVA_HOME="/opt/jdk1.8.0_391"
export PATH=$ES_JAVA_HOME/bin:$PATH
export ES_JRE_HOME=/opt/jdk1.8.0_391/jre
export PATH=$ES_JRE_HOME/bin:$PATH
export ES_HOME="/usr/share/elasticsearch"
export PATH=$ES_HOME/bin:$PATH

#################### Comment
/*
## Cerfiticated
./bin/elasticsearch-certutil ca
./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12

## Add lines in elasticsearch.yaml
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate 
xpack.security.transport.ssl.client_authentication: required
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
*/


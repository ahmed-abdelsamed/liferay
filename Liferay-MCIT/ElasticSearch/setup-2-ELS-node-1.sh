update-crypto-policies --set DEFAULT:SHA1 

dnf check-update --enablerepo=elasticsearch-7.4.13
dnf install elasticsearch --enablerepo=elasticsearch-7.4.13 -y
## OR
## OR
sudo rpm -ivh https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.3-x86_64.rpm


# 	On the 1st node, start Elasticsearch and generate an enrollment token for other nodes.
cp -p  /etc/elasticsearch/elasticsearch.yml  /etc/elasticsearch/elasticsearch.yml.org
 vi /etc/elasticsearch/elasticsearch.yml 
 # changed in content/elasticsearch-node1.yml

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
ss -ntlp

#Test Elasticsearch:
 curl -X GET 'http://localhost:9200'

 tail -f /var/log/elasticsearch/LiferayElasticsearchCluster.log

#### Install Plugin 
/usr/share/elasticsearch/bin/elasticsearch-plugin install [plugin-name]

/usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu   #if systemd installed elasticsearch

#Replace [plugin-name] with the Elasticsearch plugin’s name.
analysis-icu
analysis-kuromoji
analysis-smartcn
analysis-stempel

sudo systemctl restart elasticsearch.service

tail -f /var/log/elasticsearch/LiferayElasticsearchCluster.log

## Create user for liferay
/usr/share/elasticsearch/bin/elasticsearch-users useradd elsuser -p password123 -r superuser
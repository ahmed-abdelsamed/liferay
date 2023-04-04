https://learn.liferay.com/w/dxp/installation-and-upgrades/setting-up-liferay/clustering-for-high-availability/example-creating-a-simple-dxp-cluster

Creating a Simple DXP Cluster


Server Type   	Implementation	    Container Name
Database	      MariaDB           	some-mariadb
File Store	    DBStore	            some-mariadb
Search Engine	  Elasticsearch	      elasticsearch
DXP Server    	Tomcat            	dxp-1
DXP Server	    Tomcat	            dxp-2

Create the database server and DXP database:

Start a MariaDB Docker container.

docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:10.2

In a shell on the container, create the DXP database.

Sign in to the database server.

docker exec -it some-mariadb bash -c "/usr/bin/mysql -uroot -pmy-secret-pw"

Create a database for DXP.

create database dxp_db character set utf8;
End your database session.

quit
End your bash session.

exit

--------------------
Start a Search Engine Server
A DXP cluster requires a search engine (running as a separate process) accessible to all of the DXP cluster nodes. Please see Installing a Search Engine for more information.

Create and configure an Elasticsearch server:

Set a local folder for storing an Elasticsearch server’s data volume. For example,

mkdir -p elasticsearch/es_data_volume

Start an Elasticsearch container named elasticsearch.

docker run -it --name elasticsearch -p 9200:9200 -p 9300:9300 -e cluster.name=LiferayElasticsearchCluster -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v $(pwd)/elasticsearch/es_data_volume:/usr/share/elasticsearch/data elasticsearch:6.8.7

NOTE
If the container reports max virtual memory areas vm.max_map_count [xxxxx] is too low, increase to at least [xxxxxx], then set vm.max_map_count to a sufficient value using a command like this one: sudo sysctl -w vm.max_map_count=[xxxxxx]. Then start the container.

Install the required Elasticsearch plugins.

docker exec -it elasticsearch bash -c '/usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu && /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji && /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-smartcn && /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-stempel'

-----------------
Configure the Search Engine Server For Each Node
Use Configuration Files to configure Elasticsearch for each DXP node:

Create the Configuration Files locations.

mkdir -p dxp-1/files/osgi/configs dxp-2/files/osgi/configs

Configure Elasticsearch for the dxp-1 server node.

cat <<EOT >> dxp-1/files/osgi/configs/com.liferay.portal.search.elasticsearch6.configuration.ElasticsearchConfiguration.config
operationMode="REMOTE"
transportAddresses="elasticsearch:9300"
clusterName="LiferayElasticsearchCluster"
EOT

  Configure Elasticsearch for the dxp-2 server node.

cat <<EOT >> dxp-2/files/osgi/configs/com.liferay.portal.search.elasticsearch6.configuration.ElasticsearchConfiguration.config
operationMode="REMOTE"
transportAddresses="elasticsearch:9300"
clusterName="LiferayElasticsearchCluster"
EOT

 ------------------------------
  docker run -it \
  --add-host elasticsearch:[IP address] \
  --add-host some-mariadb:[IP address] \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_JNDI_PERIOD_NAME="" \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_DRIVER_UPPERCASEC_LASS_UPPERCASEN_AME=org.mariadb.jdbc.Driver \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL="jdbc:mariadb://some-mariadb:3306/dxp_db?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false" \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME=root \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=my-secret-pw \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_ENABLED=true \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_CHANNEL_PERIOD_LOGIC_PERIOD_NAME_PERIOD_CONTROL=control-channel-logic-name-1 \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_CHANNEL_PERIOD_LOGIC_PERIOD_NAME_PERIOD_TRANSPORT_PERIOD_NUMBER0=transport-channel-logic-name-1 \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_AUTODETECT_PERIOD_ADDRESS=some-mariadb:3306 \
  -e LIFERAY_WEB_PERIOD_SERVER_PERIOD_DISPLAY_PERIOD_NODE=true \
  -e LIFERAY_DL_PERIOD_STORE_PERIOD_IMPL=com.liferay.portal.store.db.DBStore \
  --name dxp-1 \
  -p 11311:11311 \
  -p 8009:8009 \
  -p 8080:8080 \
  -v $(pwd)/dxp-1:/mnt/liferay \
  liferay/portal:7.3.2-ga3

  docker run -it \
  --add-host elasticsearch:[IP address] \
  --add-host some-mariadb:[IP address] \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_JNDI_PERIOD_NAME="" \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_DRIVER_UPPERCASEC_LASS_UPPERCASEN_AME=org.mariadb.jdbc.Driver \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL="jdbc:mariadb://some-mariadb:3306/dxp_db?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false" \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME=root \
  -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=my-secret-pw \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_ENABLED=true \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_CHANNEL_PERIOD_LOGIC_PERIOD_NAME_PERIOD_CONTROL=control-channel-logic-name-2 \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_CHANNEL_PERIOD_LOGIC_PERIOD_NAME_PERIOD_TRANSPORT_PERIOD_NUMBER0=transport-channel-logic-name-2 \
  -e LIFERAY_CLUSTER_PERIOD_LINK_PERIOD_AUTODETECT_PERIOD_ADDRESS=some-mariadb:3306 \
  -e LIFERAY_WEB_PERIOD_SERVER_PERIOD_DISPLAY_PERIOD_NODE=true \
  -e LIFERAY_DL_PERIOD_STORE_PERIOD_IMPL=com.liferay.portal.store.db.DBStore \
  --name dxp-2 \
  -p 11312:11311 \
  -p 9009:8009 \
  -p 9080:8080 \
  -v $(pwd)/dxp-2:/mnt/liferay \
  liferay/portal:7.3.2-ga3

  
DXP-1: http://localhost:8080
DXP-2: http://localhost:9080

  
  

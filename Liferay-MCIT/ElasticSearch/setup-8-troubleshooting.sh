# through join
ERROR: Skipping security auto configuration because it appears that the node is not starting up for the first time. The node might already be part of a cluster and this auto setup utility is designed to configure Security for new clusters only.

systemctl stop elasticsearch
dnf remove elasticsearch --enablerepo=elasticsearch-8.x -y
rm -rf /var/lib/elasticsearch
rm -rf /etc/elasticsearch
rm -rf /usr/share/elasticsearch

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-8.x]
name=Elasticsearch repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

dnf check-update --enablerepo=elasticsearch-8.x
dnf install elasticsearch --enablerepo=elasticsearch-8.x -y

systemctl enable elasticsearch
#Created symlink /etc/systemd/system/multi-user.target.wants/elasticsearch.service → /usr/lib/systemd/system/elasticsearch.service.

# /usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token eyJ2ZXI...

This node will be reconfigured to join an existing cluster, using the enrollment token that you provided.
This operation will overwrite the existing configuration. Specifically:
  - Security auto configuration will be removed from elasticsearch.yml
  - The [certs] config directory will be removed
  - Security auto configuration related secure settings will be removed from the elasticsearch.keystore
Do you want to continue with the reconfiguration process [y/N]y

#Edit Elasticsearch configuration file
nano /etc/elasticsearch/elasticsearch.yml
cluster.name: els-cluster
# line 56 : uncomment and change (listen all)
network.host: Ip_node
node.name: els-3

#Add automatic index creation settings to the last line
action.auto_create_index: .monitoring*,.watches,.triggered_watches,.watcher-history*,.ml*

systemctl start elasticsearch

# curl -k -u elastic https://els-3:9200
Enter host password for user 'elastic':
{
  "name" : "node2",
  "cluster_name" : "mycluster",
  "cluster_uuid" : "FyfnAcg5TI-OGB6VWfUysg",
  "version" : {
    "number" : "8.3.3",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "801fed82df74dbe537f89b71b098ccaff88d2c56",
    "build_date" : "2022-07-23T19:30:09.227964828Z",
    "build_snapshot" : false,
    "lucene_version" : "9.2.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

## Check the cluster

# curl -k -u elastic https://els-1:9200/_cat/nodes?v
Enter host password for user 'elastic':
ip            heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
172.21.192.12           19          95   0    0.15    0.09     0.07 cdfhilmrstw -      node2
172.21.192.13           40          95   1    0.37    0.19     0.07 cdfhilmrstw -      node3
172.21.192.11           44          91   1    0.00    0.00     0.00 cdfhilmrstw *      node1


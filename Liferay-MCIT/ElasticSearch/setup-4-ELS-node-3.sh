# On other nodes, join in cluster with an enrollment token generated on the 1st node above. 
/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token eyJ2ZXIiOiI4LjExLjMiLCJhZHIiOlsiMTAuNzMuMzQuMzQ6OTIwMCJdLCJmZ3IiOiIzMjZmN2YyOTY2ZDk5YmVkZGIzMDE0NWJkMjNjNmM1NDFhYjZjMDdlNDk1OWU0MWNhNDI0ZjhhN2U0ZDRiNDIxIiwia2V5IjoibVVuaThvd0J5NHZjTUpMZVBmOHY6VUNqVWtVdnFRTmluQmx6dWxPWVlhUSJ9



vi /etc/elasticsearch/elasticsearch.yml 
# edit in content/elasticsearch_node3.yml

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# https://IP_Node1:9200/_cluster/health?pretty


 tail -f /var/log/elasticsearch/els-cluster.log

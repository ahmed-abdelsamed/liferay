dnf -y install kibana 

cp /etc/pki/tls/certs/{server.crt,server.key} /etc/kibana/ 
#OR
cd /etc/kibana
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
chmod 777 cert.pem
chmod 777 key.pem

chown kibana /etc/kibana/{server.crt,server.key} 


# generate an enrollment token for Kibana from master node of ELS
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

eyJ2ZXIiOiI4LjExLjMiLCJhZHIiOlsiMTAuNzMuMzQuMzQ6OTIwMCJdLCJmZ3IiOiIzMjZmN2YyOTY2ZDk5YmVkZGIzMDE0NWJkMjNjNmM1NDFhYjZjMDdlNDk1OWU0MWNhNDI0ZjhhN2U0ZDRiNDIxIiwia2V5IjoibTBrZzg0d0J5NHZjTUpMZUxQOU46SEZ3c1ZJaDZSSW1Hb25ORFRkVmJpdyJ9


# setup Kibana
/usr/share/kibana/bin/kibana-setup --enrollment-token eyJ2ZXIiOiI4LjExLjMiLCJhZHIiOlsiMTAuNzMuMzQuMzQ6OTIwMCJdLCJmZ3IiOiIzMjZmN2YyOTY2ZDk5YmVkZGIzMDE0NWJkMjNjNmM1NDFhYjZjMDdlNDk1OWU0MWNhNDI0ZjhhN2U0ZDRiNDIxIiwia2V5IjoibTBrZzg0d0J5NHZjTUpMZUxQOU46SEZ3c1ZJaDZSSW1Hb25ORFRkVmJpdyJ9

#Kibana configured successfully.

#To start Kibana run:
#  bin/kibana

vi /etc/kibana/kibana.yml 
# edit in content/kibana.yml

# reset password 
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u kibana_system
1llwfEnD4yqgkR8X9STg

systemctl daemon-reload
systemctl enable kibana 
systemctl start kibana 


firewall-cmd --add-port=5601/tcp 
firewall-cmd --runtime-to-permanent 

tail -f /var/log/kibana/kibana.log

# Access to [https://(server's Hostname or IP address):5601/] 


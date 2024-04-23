sudo dnf update
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl stop firewalld
sudo systemctl disable firewalld

echo "
192.168.100.61 liferay-1 liferay-1.linkdev.local
192.168.100.62 liferay-2 liferay-2.linkdev.local
" | sudo tee --append /etc/hosts

## /etc/environment
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-3.el9.x86_64"
JRE_HOME="/usr/lib/jvm/jre-11-openjdk-11.0.18.0.10-3.el9.x86_64"

source /etc/environment


## Download Luferay  liferay-dxp-7.4.13.u80
# Unzip packages 

cd /opt/liferay-dxp-7.4.13.u80

dnf install java-11-openjdk-devel -y


## Add in /etc/profile

#export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-3.el9.x86_64"
#export PATH=$JAVA_HOME/bin:$PATH
#export JRE_HOME=/usr/lib/jvm/jre-11-openjdk-11.0.18.0.10-3.el9.x86_64
#export PATH=$JRE_HOME/bin:$PATH
#export LIFERAY_HOME=/opt/liferay-dxp-7.4.13.u80
#export PATH=$KIFERAY_HOME/:$PATH

ls -l /opt/liferay-dxp/
'
portal-ext.properties
portal-setup-wizard.properties
'

############# ELS  
#in ELS-liferay
###########OR 
## Configure Elasticsearch:
#vi /opt/liferay-dxp-7.4.13.u80/osgi/configs/com.liferay.portal.search.elasticsearch7.configuration.ElasticsearchConfiguration.config
# conent /els.config


#vi /opt/liferay-dxp-7.4.13.u80/portal-ext.properties
# content/portal-ext.properties




## Licese
cp activation-key-dxp-trial-7.4.xml /opt/liferay-dxp-7.4.13.u80/deploy/


Running Configuration check
./liferay-dxp-7.4.13.u80/tomcat-9.0.75/bin/configtest.sh

chmod -R +x /opt/liferay-dxp-7.4.13.u80/tomcat-9.0.75/bin/*.sh

sudo ./liferay-dxp-7.4.13.u80/tomcat-9.0.75/bin/startup.sh


tail -f ./liferay-dxp-7.4.13.u80/tomcat-9.0.75/logs/catalina.out


## Verfiy very important
MariaDB [lportal]> select * from Group_;
#' must be appear all groups'

MariaDB [lportal]> select * from User_;
#' must be contain users'

###################################################################################
{https://liferay.dev/blogs/-/blogs/ssl-configuration-in-liferay-https-#:~:text=For%20SSL%20certificate%20Configuration%20in%20Liferay%206.2&text=First%20we%20need%20to%20download,using%20the%20ssl%20certificates%20downloaded.}

########################################################## Certificate on Liferay
1- #Execute the following command to export Private Key file:

openssl pkcs12 -in [yourfile.pfx] -nocerts -out [keyfile-encrypted.key]

#Then remove the passphrase from the Private Key

openssl rsa -in [keyfile-encrypted.key] -out [keyfile-decrypted.key] 

#Export certificate file:

openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [certificate.crt]


## Export csr from key
openssl req -out .\bot_maan_gov_ae.csr -new -key .\bot_maan_gov_ae-decrypt.key


### 2- Generate keystore
## Install keytool
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-11-amazon-corretto-devel

## To create the p12 file run the following command: 
openssl pkcs12 -export -in bot_maan_gov_ae.crt -inkey bot_maan_gov_ae-decrypt.key -out key.p12

## To verify the alias of the private key run the following: 
keytool -v -list -storetype pkcs12 -keystore key.p12

# Look for alias and its value. It will be used in the next step.

## To convert the p12 file to JKS run the following:
keytool -importkeystore -srckeystore key.p12 -srcstoretype pkcs12 -srcalias 1 -destkeystore bot-maab.jks -deststoretype jks -deststorepass password -destalias liferay-alias

# (1) is alias name in verfiy command, password is password for keystore,  liferay-lais is new alias for keystore

############

## Addtional 
# migrate from jks to PKCS12 
keytool -importkeystore -srckeystore bot-maab.jks -destkeystore bot-maab.jks -deststoretype pkcs12


## 3- Modified server.xml
 <Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
            maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
            keystoreFile="/home/azureuser/liferay-dxp-7.4.13.u80/tomcat-9.0.75/conf/bot-maab.jks" keystorePass="password"
            clientAuth="false" sslProtocol="TLS"
               maxParameterCount="1000"
               
 </Connector>
## 4- In web.xml, add the following tag in the <web-app> tag just before </web-app>

<security-constraint>
        <web-resource-collection>
            <web-resource-name>securedapp</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <user-data-constraint>
            <transport-guarantee>CONFIDENTIAL</transport-guarantee>
        </user-data-constraint>
    </security-constraint>


###  5- Add the following properties in portal-ext.properties or portal-setup-wizard.properties
    company.security.auth.requires.https=true
    session.enable.phishing.protection=false
    web.server.protocol=https

### 6- https://hostname:8443  # record hostname in hosts on windows and linux(liferay VM)
===================================================================================================
====================================================================================================

























#######################################################################################
 
### Configuration
vi  elasticsearch-sidecar/7.17.10/config/jvm.options
-Djava.locale.providers=JRE,COMPAT,CLDR
-Xms2560m
-Xmx2560m


vi tomcat-9.0.75/conf/catalina.properties
#### configure Catalina’s JVM options to support Liferay DXP.
-Dfile.encoding=UTF-8
-Djava.net.preferIPv4Stack=true
-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false
-Duser.timezone=GMT
-Xms2560m
-Xmx2560m


./tomcat-9.0.75/bin/catalina.sh run

##################################

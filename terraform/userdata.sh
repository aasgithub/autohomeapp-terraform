#!/bin/bash
#install postgresql
sudo su
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install postgresql -y
#install aws-cli
sudo su
sudo apt-get install unzip -y
cd /tmp
mkdir aws-cli
cd aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
mv awscliv2.zip /tmp
sudo ./aws/install
aws s3api get-object --bucket autohomeapp-repo --key postgres_setup.sql postgres_setup.sql
aws s3api get-object --bucket autohomeapp-repo --key autohomeapp-0.0.1-SNAPSHOT.war autohomeapp-0.0.1-SNAPSHOT.war
mv autohomeapp-0.0.1-SNAPSHOT.war ROOT.war
mv postgres_setup.sql ROOT.war /tmp
sudo /etc/init.d/postgresql start
sudo -u postgres psql --command "alter user postgres with password 'postgres';"
sudo -u postgres psql --command "create database autohomeapp;"
cd /tmp
PGPASSWORD=postgres psql -U postgres -h localhost -d autohomeapp -f postgres_setup.sql
#install tomcat
sudo apt-get install default-jdk -y
mkdir /opt/tomcat
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz
sudo tar xzvf apache-tomcat-9.0.37.tar.gz -C /opt/tomcat --strip-components=1
mkdir /opt/tomcat/backup
cd /opt/tomcat/webapps
mv ROOT docs examples host-manager manager /opt/tomcat/backup
cp /tmp/ROOT.war /opt/tomcat/webapps
cd ..
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
echo "[Unit]\n\nDescription=Apache Tomcat Web Application Container\nAfter=network.target\n\n[Service]\n\nType=forking\n\nEnvironment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64\nEnvironment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid\nEnvironment=CATALINA_HOME=/opt/tomcat\nEnvironment=CATALINA_BASE=/opt/tomcat\nEnvironment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'\nEnvironment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'\n\nExecStart=/opt/tomcat/bin/startup.sh\nExecStop=/opt/tomcat/bin/shutdown.sh\n\nUser=tomcat\nGroup=tomcat\nUMask=0007\n\nRestartSec=10\nRestart=always\n\n[Install]\n\nWantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
cd bin
sudo sh startup.sh
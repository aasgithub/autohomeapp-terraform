#remove tomcat
sudo sh /opt/tomcat/bin/shutdown.sh
cd /opt
rm -rf tomcat
cd /tmp
rm -rf apache-tomcat-9.0.37.tar.gz
cd /etc/systemd/system
rm -rf tomcat.service
#remove postgresql
sudo apt-get purge postgresql -y
sudo apt-get purge postgresql-12 -y
sudo apt-get purge postgresql-client-12 -y
sudo apt-get purge postgresql-client-common -y
sudo apt-get purge postgresql-common -y
sudo apt-get purge pgdg-keyring -y
rm -rf /etc/apt/sources.list.d/pgdg.list
dpkg-query -l
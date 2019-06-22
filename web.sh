#!/bin/sh
sudo apt-get update
sudo apt-get -y install apache2 libxml2-dev
sudo service apache2 restart
sudo a2enmod proxy
sudo service apache2 restart
sudo a2enmod proxy_html
sudo service apache2 restart
sudo a2enmod proxy_http
sudo service apache2 restart
	 
sudo ufw --force enable   
sudo ufw allow 80/tcp
sudo ufw allow ssh

echo "ServerName localhost" >> /etc/apache2/apache2.conf
sudo service apache2 restart

sudo rm /etc/apache2/sites-available/000-default.conf
sudo touch /etc/apache2/sites-available/000-default.conf
	
cat <<EOF >> /etc/apache2/sites-available/000-default.conf
	<VirtualHost *:80>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html

            <Directory /var/www/html/>
                Options Indexes FollowSymLinks
                AllowOverride All
                Require all granted
            </Directory>

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined

            <IfModule mod_dir.c>
                DirectoryIndex index.php index.pl index.cgi index.html index.xhtml index.htm
            </IfModule>
                        # Allgemeine Proxy Einstellungen
        ProxyRequests Off
        <Proxy *>
            Order deny,allow
            Allow from all
        </Proxy>

        # Weiterleitungen master
        ProxyPass /test http://localhost
        ProxyPassReverse / http://localhost

    </VirtualHost>
EOF
sudo service apache2 reload

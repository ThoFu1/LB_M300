# Modul 300 LB2
## Inhaltsverzeichnis
* 01 - [Linux](#linux)
## Linux
Linux ist nicht meine stärke und wird es auch nie richtig sein. Es wird immer Probleme auftauchen, die nur bei mir passieren und nicht bei anderen, auch wenn ich alles, nach der Dokumentationen, richtig mache. Trotzdem hatte ich schon Erfahrung mit Linux und konnte auch schon Apache installieren, den Reverse-Proxy konfigurieren und die Firewall aktivieren und rules setzen.

## Virtualisierung
Eine VM aufzusetzen war kein Problem. Wir haben eigentlich im jedem Modul und auch ein paar mal in den ÜKs VMs erstellt. Nur benutzten wir in deisem Modul Virtualbox und dieses Tool hab ich noch nie verwendet. Destotrozt kriegte ich es hin ein Shellscript zu kreieren und dafür zu sorgen, das VMs erstellt werden und auch schon die ersten Befehle ausgeführt werden. 

## Vagrant
Vagrant kann man von folgender Seite [herunterladen](https://www.vagrantup.com/).
### Befehel
|Befehl | Erklärung |
|---|---|
|init|Hiermit wird ein Vagrantfile erstellen, wenn noch keins im Ordner ist|
|up|startet eine VM|
|box| Wird benutzt um eine Box hinzuzufügen oder zu löschen|
|status|Zeigt den Status der VMs|
|halt|Fährt die VM runter|
|ssh|Verbindet sich mit der VM via SSH|
|provision|Neue Updates im Vagrantfile werden übernommen|
|destroy|Löscht eine VM|

### Vagrant-Cloud
Die Vagrant-Cloud ist die Webseite von Vagrant selbst, auf dem alle Boxen sind Unter folgendem [Link](https://app.vagrantup.com/boxes/search) findet man die Boxen. Um eine Box herunterzuladen gibt man im Git/Bash
            ```
            vagrant init (Namen der Box)
            ```
ein. Danach muss man nur noch 
            ```
            vagrant up
            ```
eingeben und die VM, mit der gewählten Box, wird gestartet.

## Systemsicherheit
Um eine deutlich sichere Umgebung für meine VMs zuschaffen, aktivierte ich die Firewall und für den Webserver würde noch der Reverse-Proxy installiert und konfiguriert. 
### Firewall und Rerverse-Proxy
Folgendes wurde im .sh file vom Webserver eingefügt, um eine Firewall und Reverse-Proxy einzurichten.

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
            ProxyPass /master http://master
            ProxyPassReverse /master http://master

        </VirtualHost>
    EOF

### User and Groups
Beim Client wurde noch ein User und eine Gruppe erstellt. Der User wurde dann auch  zur Gruppe hinzugefügt. 
    
    sudo useradd -m test01
    sudo addgroup standard_group
    sudo usermod -aG standard_group test01

## Reflexion
Am Anfang war es schwierig, da ich nicht genau wusste was von mir verlangt wurde. Und mit Ubuntu hatte ich auch welche Problem mit dem installieren vom Reverse-Proxy und Apache. Da ich aber immer Probleme mit Ubuntu, oder einfach Linux Distributionen, habe verlor ich einiges an Zeit diese Probleme wieder zu lösen. Schlussendlich kriegte ich es hin ein Vagrantfile zu kreieren, indem mehrere VMs waren und bei dem die richtigen Services installiert und konfiguriert werden. 

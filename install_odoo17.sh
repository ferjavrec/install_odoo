#!/bin/bash
sudo adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo
sudo mkdir /etc/odoo && sudo mkdir /var/log/odoo/
sudo apt update 
sudo apt install  postgresql postgresql-server-dev-14   git python3 python3-pip build-essential python3-dev  libldap2-dev  libsasl2-dev python3-setuptools libjpeg-dev nodejs npm -y
sudo git clone --depth 1 --branch 17.0 https://github.com/odoo/odoo /opt/odoo/odoo
sudo chown odoo:odoo /opt/odoo/ -R && sudo chown odoo:odoo /var/log/odoo/ -R && sudo rm /usr/lib/python3/dist-packages/_cffi_backend.cpython-310-x86_64-linux-gnu.so 
sudo pip3 install cffi && sudo pip3 install -r /opt/odoo/odoo/requirements.txt
sudo apt install fontconfig xfonts-base xfonts-75dpi -y
cd /tmp
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb && sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin/ && sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin/
sudo su - postgres -c "createuser -s odoo"
sudo su - odoo -c "/opt/odoo/odoo/odoo-bin --addons-path=/opt/odoo/odoo/addons -s --stop-after-init"
sudo mv /opt/odoo/.odoorc /etc/odoo/odoo.conf
sudo sed -i "s,^\(logfile = \).*,\1"/var/log/odoo/odoo-server.log"," /etc/odoo/odoo.conf
sudo cp /opt/odoo/odoo/debian/init /etc/init.d/odoo && sudo chmod +x /etc/init.d/odoo
sudo ln -s /opt/odoo/odoo/odoo-bin /usr/bin/odoo
sudo update-rc.d -f odoo start 20 2 3 4 5 .
sudo service odoo start

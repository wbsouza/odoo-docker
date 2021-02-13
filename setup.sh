#!/bin/bash
#set -x

################################################################################
# Script for installing Odoo on Debian
# Author: Wellington Souza
#
# Place this content in it and then make the file executable:
# Execute the script to install Odoo:
# ./setup.sh
################################################################################

ODOO_UID=9100
ODOO_USER="odoo"
ODOO_HOME="/opt/$ODOO_USER"
ODOO_SERVER_HOME="$ODOO_HOME/${ODOO_USER}-server"
ODOO_PORT="8069"

ODOO_VERSION="11.0"


PG_VERSION="${POSTGRES_VERSION:-10}"


export DEBIAN_FRONTEND=noninteractive
echo 'debconf debconf/frontend select Dialog' | debconf-set-selections

#--------------------------------------------------
# Install the minimal tools
#--------------------------------------------------
apt-get -y update
apt-get upgrade -y
apt-get -y install gnupg2 gcc g++ make curl wget git bzr apt-utils locales libmaxminddb0 libmaxminddb-dev libgeoip-dev

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "LANG=en_US.UTF-8" >> /etc/environment
echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
echo "LOCALE=en_US.UTF-8" >> /etc/environment

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8

rm -fR /etc/localtime
ln -s /usr/share/zoneinfo/America/Vancouver  /etc/localtime

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LOCALE="en_US.UTF-8"

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
echo -e "\n---- Install PostgreSQL Server ----"
echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get -y update
apt-get -y install postgresql-${PG_VERSION} postgresql-server-dev-${PG_VERSION}


#--------------------------------------------------
# Install Python and Library Dependencies
#--------------------------------------------------
echo -e "\n--- Installing Python and Libraries --"
apt-get install -y git wget build-essential node-less libjpeg-dev libpq-dev python3-pip python3-dev python3-venv python3-wheel libzip-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev 

#--------------------------------------------------
# Install Node and Dependencies
#--------------------------------------------------
#echo -e "\n--- Installing Node and packages --"
#curl -sL https://deb.nodesource.com/setup_10.x | bash -
#apt-get -y update
#apt-get -y install nodejs
#npm install -g less less-plugin-clean-css

#--------------------------------------------------
# Install Wkhtmltopdf if needed
#--------------------------------------------------
curl -fsSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb > /tmp/wkhtml.deb
apt-get -y install /tmp/wkhtml.deb
ln -s /usr/local/bin/wkhtmltopdf /usr/bin
ln -s /usr/local/bin/wkhtmltoimage /usr/bin


curl -fsSL  https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64 > /usr/local/bin/gosu
chmod 755 /usr/local/bin/gosu


echo -e "\n---- Create ODOO system user ----"
mkdir -p $ODOO_HOME/conf

groupadd -g $ODOO_UID $ODOO_USER
useradd --shell=/bin/bash --home=$ODOO_HOME -u $ODOO_UID -g $ODOO_USER $ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME
chmod 755 $ODOO_HOME

echo -e "\n---- Create Log directory ----"
mkdir /var/log/$ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER /var/log/$ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME
chmod 755 /entrypoint.sh


exit 0


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


PG_VERSION="${POSTGRES_VERSION:-12}"


export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
export DEBIAN_FRONTEND=noninteractive
echo 'debconf debconf/frontend select Dialog' | debconf-set-selections



#--------------------------------------------------
# Install the minimal tools
#--------------------------------------------------
apt-get -y update
apt-get -y install apt-utils gnupg2 curl locales

rm -fR /etc/localtime
ln -s /usr/share/zoneinfo/America/Vancouver  /etc/localtime

echo "LOCALE=en_US.UTF-8" >> /etc/environment
echo "LANG=en_US.UTF-8" >> /etc/environment
echo "LANGUAGE=en_US" >> /etc/environment
source /etc/environment

touch /etc/default/locale
echo "LC_CTYPE=\"en_US.UTF-8\"" >> /etc/default/locale
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
echo "LANG=\"en_US.UTF-8\"" >> /etc/default/locale

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen "en_US.UTF-8"

echo "alias ls='ls --color'" >> /etc/profile
echo "alias ll='ls -la'" >> /etc/profile

# PostgreSQL repository
echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Load the available packages
apt-get -y update

apt-get -y install sudo gcc g++ make build-essential libssl-dev libbz2-dev libreadline-dev  libldap2-dev libsasl2-dev \
                   libsqlite3-dev libmaxminddb0 libmaxminddb-dev libgeoip-dev zlib1g-dev libncurses5-dev \
                   libjpeg-dev libpq-dev libncursesw5-dev libffi-dev liblzma-dev llvm git iputils-ping net-tools node-less \
                   postgresql-$PG_VERSION postgresql-server-dev-$PG_VERSION

#--------------------------------------------------
# Install Wkhtmltopdf
#--------------------------------------------------
curl -fsSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb > /tmp/wkhtml.deb
apt-get -y install /tmp/wkhtml.deb
ln -s /usr/local/bin/wkhtmltopdf /usr/bin
ln -s /usr/local/bin/wkhtmltoimage /usr/bin


curl -fsSL  https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64 > /usr/local/bin/gosu
chmod 755 /usr/local/bin/gosu

mkdir -p $ODOO_HOME/conf
mkdir -p $ODOO_HOME/extra-addons

groupadd -g $ODOO_UID $ODOO_USER
useradd --shell=/bin/bash --home=$ODOO_HOME -u $ODOO_UID -g $ODOO_USER $ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME
chmod 755 $ODOO_HOME

mkdir /var/log/$ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER /var/log/$ODOO_USER
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME
chown -fR $ODOO_USER:$ODOO_USER $ODOO_HOME

chown $ODOO_USER:$ODOO_USER /docker_entrypoint.sh
chmod +x /docker_entrypoint.sh

chown $ODOO_USER:$ODOO_USER '/tmp/setup_odoo.sh'
chmod +x '/tmp/setup_odoo.sh'
su - $ODOO_USER -c  '/tmp/setup_odoo.sh'


exit 0

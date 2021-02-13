#!/bin/bash

ODOO_USER="odoo"
ODOO_HOME="/opt/$ODOO_USER"

#--------------------------------------------------
# Install Odoo and Python libraries dependencies
#--------------------------------------------------
git clone --depth 1 --branch 11.0 https://github.com/odoo/odoo /opt/odoo/odoo-server
pip3 install --user wheel passlib phonenumbers PyPDF2
pip3 install --user -r "${ODOO_HOME}/odoo-server/requirements.txt"

mkdir -p "${ODOO_HOME}/extra-addons"

exit 0

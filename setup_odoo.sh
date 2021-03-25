#!/usr/bin/env bash

#set -x

PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/odoo/.local/bin"

PYTHON_VERSION="${PYTHON_VERSION:-3.7.5}"

echo -e "\n---- Setting up pyenv and Python ${PYTHON_VERSION} ----"
curl -sL https://pyenv.run | bash

export PATH="$HOME/.pyenv/bin:$PATH"
export ODOO_HOME=/opt/odoo

touch ~/.profile
echo 'export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
echo 'export ODOO_HOME=/opt/odoo' >> ~/.profile

source ~/.profile

pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION


git clone --depth 1 --branch 11.0 https://github.com/odoo/odoo /opt/odoo/odoo-server
pip3 install --user wheel passlib phonenumbers PyPDF2
pip3 install --user -r "${ODOO_HOME}/odoo-server/requirements.txt"

exit 0


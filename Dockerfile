FROM debian:buster-slim

WORKDIR /opt/odoo

COPY setup_linux.sh                  /tmp/setup_linux.sh
COPY setup_odoo.sh                   /tmp/setup_odoo.sh

COPY docker_entrypoint.sh            /docker_entrypoint.sh


ENV PG_VERSION="12"

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LOCALE="en_US.UTF-8"
ENV PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/odoo/.local/bin"

RUN chmod +x /tmp/setup_linux.sh && /tmp/setup_linux.sh

RUN apt-get -qq -y clean \   
    && rm -rf /tmp/* /usr/share/man/* /var/lib/{cache,log}/* /var/lib/apt/lists/* \
    && find /var/log -type f -delete

EXPOSE 8069
EXPOSE 8072

ENTRYPOINT ["/docker_entrypoint.sh"]


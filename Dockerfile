FROM debian:buster-slim

COPY setup.sh         /setup.sh
COPY post-install.sh  /post-install.sh
COPY entrypoint.sh    /entrypoint.sh

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LOCALE="en_US.UTF-8"
ENV POSTGRES_VERSION=10
ENV PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/odoo/.local/bin"

RUN chmod +x /setup.sh && /setup.sh

RUN rm /setup.sh

USER odoo

RUN /post-install.sh

USER root

RUN apt-get -qq -y clean \   
    && rm -rf /tmp/* /usr/share/man/* /var/lib/{cache,log}/* /var/lib/apt/lists/* \
    && find /var/log -type f -delete

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]

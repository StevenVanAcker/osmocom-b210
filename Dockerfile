ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

COPY install-openbsc.sh /opt
RUN chmod +x /opt/install-openbsc.sh
RUN /opt/install-openbsc.sh


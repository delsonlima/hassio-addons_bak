#ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.1.0
ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN \
  apk update && apk add \
    synapse \
    yq

WORKDIR /data

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

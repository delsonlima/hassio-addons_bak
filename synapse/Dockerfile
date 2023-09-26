#ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.1.0
ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN \
  apk update \
  && apk add \
    py3-pip \
    py3-cffi \
    py3-setuptools-rust \
    yq \
  && pip install --upgrade pip \
  && pip install --upgrade setuptools \
  && pip install matrix-synapse==1.92.3

WORKDIR /data

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

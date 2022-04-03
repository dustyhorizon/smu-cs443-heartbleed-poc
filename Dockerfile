# syntax=docker/dockerfile:1.3.1
FROM ubuntu:20.04

RUN set -ex \
    \
    && apt-get update \
    && apt-get install --assume-yes \
        wget

# download initc
RUN set -ex \
    \
    && wget \
        -O /usr/local/bin/dumb-init \
        "https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64" \
    && chmod ugo=rx /usr/local/bin/dumb-init

# compile last vulnerable openssl v1.0.1f
RUN set -ex \
    \
    && apt-get install --assume-yes \
        build-essential \
        git \
    \
    && git clone https://github.com/openssl/openssl /opt/openssl \
    && cd /opt/openssl \
    && git reset --hard "0d8776344cd7965fadd870e361503985df9c45bb" \
    \
    && cd /opt/openssl \
    && ./config \
    && make \
    && make install_sw \
    \
    && rm -rf \
        /tmp/*

# self sign poc certificate
RUN set -ex \
    \
    && mkdir -p /tmp/heartbleed_poc \
    \
    && /opt/openssl/apps/openssl \
        req -x509 \
        -newkey rsa:4096 \
        -keyout /tmp/heartbleed_poc/certificate.key \
        -out /tmp/heartbleed_poc/certificate.crt \
        -days 365 \
        -nodes \
        -subj "/C=SG/L=Singapore/O=SMU/OU=CS443/CN=heartbleedpoc.local"

CMD ["/usr/local/bin/dumb-init", \
    "/opt/openssl/apps/openssl", \
    "s_server", \
    "-key", \
    "/tmp/heartbleed_poc/certificate.key", \
    "-cert", \
    "/tmp/heartbleed_poc/certificate.crt", \
    "-accept", \
    "443", \
    "-www"]

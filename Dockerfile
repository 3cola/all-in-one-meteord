FROM ubuntu:14.04
MAINTAINER ecolaitis@gmail.com

RUN \
  apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    lsb-release \
    gpgv2 \
    bzip2 \
    xz-utils \
    build-essential

RUN cd /tmp

RUN set -ex \
  && for key in \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    A352422D1BD4668728916B7957E7E4E08C674E22 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.4.2

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

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
    build-essential &&\
  apt-get autoremove -y &&\
  apt-get clean

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 0.10.43

RUN \
  cd /tmp && \
  set -ex &&\
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 7E37093B DBE9B9C5 D2306D93 4EB7990E 7EDE3FC1 7D83545D 4C206CA9 CC11F4C8 8C674E22 &&\
  curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 &&\
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list &&\
    apt-get update &&\
    apt-get install -y mongodb-org supervisor &&\
    apt-get clean all

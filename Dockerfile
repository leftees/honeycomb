FROM ruby:2.2
MAINTAINER Justin Gondron <jgondron@nd.edu>

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*
#RUN apt-get update && apt-get install -y rabbitmq-server --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Install node. Based on https://github.com/nodejs/docker-node/blob/3622304ad09a84826521e81cb7ddf253c020d89e/5.1/Dockerfile
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.1.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc
# end install node

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install gems
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install

# node packages
ADD package.json /usr/src/app/
RUN npm install

ADD . /usr/src/app

# Configs
ADD config/docker/* /usr/src/app/config/

EXPOSE 3017
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3017"]

#EXPOSE 5672
#CMD ["service", "rabbitmq-server", "start"]

# Rebuild using the Dockerfile
# docker build --rm -t nd/honeycomb:v1 .

# Start a shell
# docker run --rm -t -i nd/honeycomb:v1 /bin/bash

# Start rails daemonized
# docker run -p 3017:3017 -d --name honeycomb nd/honeycomb:v1

# Start daemonized, linked to mysql container
# docker run -p 3017:3017 -d --name honeycomb --link mysql:mysql nd/honeycomb:v1

# Stop the running containter
# docker stop honeycomb

# Remove the container
# docker rm honeycomb

# Remove
# docker ps -aq | xargs docker rm

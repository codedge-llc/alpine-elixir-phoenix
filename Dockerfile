FROM elixir:1.14.0-alpine

MAINTAINER Henry Popp <henry@codedge.io>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2022-01-10

# Install NPM
RUN \
  mkdir -p /opt/app && \
  chmod -R 777 /opt/app && \
  apk update && \
  apk --no-cache --update add \
  make \
  g++ \
  wget \
  curl \
  inotify-tools \
  nodejs \
  npm && \
  npm install npm -g --no-progress && \
  update-ca-certificates --fresh && \
  rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH

# Ensure latest versions of Hex/Rebar are installed on build
ONBUILD RUN mix do local.hex --force, local.rebar --force

WORKDIR /opt/app

CMD ["/bin/sh"]

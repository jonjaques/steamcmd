FROM ubuntu:bionic
LABEL maintainer="jaquers@gmail.com"

# app envs
ENV STEAM_APP_ID 258550
ENV STEAM_USER anonymous
ENV STEAM_APP_DIR /steamcmd/install

# install dependencies
RUN dpkg --add-architecture i386 \
  && apt-get update -y \
  && apt-get install -y software-properties-common lib32gcc1 apt-utils \
  && add-apt-repository multiverse \
  && apt-get update -y

# set deb frontend so we can 'accept' the license
ENV DEBIAN_FRONTEND noninteractive

# install steam, drop privs to steam user
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
  && apt-get install -y steamcmd \
  && ln -s /usr/games/steamcmd /usr/local/bin \
  && useradd -m steam \
  && mkdir -p $STEAM_APP_DIR \
  && chown -R steam:steam $STEAM_APP_DIR

USER steam
WORKDIR $STEAM_APP_DIR

# force an update
RUN steamcmd +quit

ENTRYPOINT steamcmd

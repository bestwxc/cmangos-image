### base image without maps
FROM ubuntu:22.04 as cmangos-without-maps

LABEL MAINTAINER="wangxc wxc252@hotmail.com"
LABEL Description="a base image without maps for cmangos server based on ubuntu(22.04)."

ARG USER_ID=2000
ARG GROUP_ID=2000
ARG DOCKER_USER=cmangos
ARG DOCKER_GROUP=cmangos

RUN groupadd -g $GROUP_ID $DOCKER_GROUP \
  && useradd -g $DOCKER_GROUP -m -s /bin/bash -u $USER_ID $DOCKER_USER

### base image with classic maps
FROM ubuntu:22.04 as cmangos-with-classic-maps

LABEL MAINTAINER="wangxc wxc252@hotmail.com"
LABEL Description="a base image with classic maps for cmangos server based on ubuntu(22.04)."

ARG USER_ID=2000
ARG GROUP_ID=2000
ARG DOCKER_USER=cmangos
ARG DOCKER_GROUP=cmangos

RUN groupadd -g $GROUP_ID $DOCKER_GROUP \
  && useradd -g $DOCKER_GROUP -m -s /bin/bash -u $USER_ID $DOCKER_USER

COPY --chown=$USER_ID:$GROUP_ID data /home/$DOCKER_USER/cmangos-server/data

### base image with tbc maps
FROM ubuntu:22.04 as cmangos-with-tbc-maps

LABEL MAINTAINER="wangxc wxc252@hotmail.com"
LABEL Description="a base image with tbc maps for cmangos server based on ubuntu(22.04)."

ARG USER_ID=2000
ARG GROUP_ID=2000
ARG DOCKER_USER=cmangos
ARG DOCKER_GROUP=cmangos

RUN groupadd -g $GROUP_ID $DOCKER_GROUP \
  && useradd -g $DOCKER_GROUP -m -s /bin/bash -u $USER_ID $DOCKER_USER

COPY --chown=$USER_ID:$GROUP_ID data /home/$DOCKER_USER/cmangos-server/data

### base image with wotlk maps
FROM ubuntu:22.04 as cmangos-with-wotlk-maps

LABEL MAINTAINER="wangxc wxc252@hotmail.com"
LABEL Description="a base image with wotlk maps for cmangos server based on ubuntu(22.04)."

ARG USER_ID=2000
ARG GROUP_ID=2000
ARG DOCKER_USER=cmangos
ARG DOCKER_GROUP=cmangos

RUN groupadd -g $GROUP_ID $DOCKER_GROUP \
  && useradd -g $DOCKER_GROUP -m -s /bin/bash -u $USER_ID $DOCKER_USER

COPY --chown=$USER_ID:$GROUP_ID data /home/$DOCKER_USER/cmangos-server/data



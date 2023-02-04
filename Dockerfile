ARG WOW_VER=tbc
ARG BASE_IMAGE_VER=1.0.1
### builder
FROM wxc252/base4cmangos:$BASE_IMAGE_VER-without-maps as builder

ARG APT_MIRROR=mirrors.ustc.edu.cn
ARG DOCKER_USER=cmangos

RUN /bin/sh -c set -eux \
  && cp /etc/apt/sources.list /etc/apt/sources.list.bak \
  && sed -i s@/archive.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && sed -i s@/security.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && apt update \
  && apt upgrade \
  && apt-get install -y --no-install-recommends iputils-ping telnet net-tools curl wget tcpdump \
  && apt install -y --no-install-recommends  build-essential gcc g++ automake git-core autoconf make patch libmysql++-dev mysql-server libtool libssl-dev grep binutils zlib1g-dev libbz2-dev cmake libboost-all-dev \
  && apt install -y --no-install-recommends gcc-12 g++-12 \
  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12 --slave /usr/bin/g++ g++ /usr/bin/g++-12 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list \
  && mv /etc/apt/sources.list.bak /etc/apt/sources.list

ENV GIT_SSL_NO_VERIFY=1

ARG WOW_VER=tbc

# clone the core
RUN cd ~ && mkdir cmangos && cd ~/cmangos \
  && git clone https://github.com/cmangos/mangos-$WOW_VER.git mangos
# clone the db
RUN cd ~/cmangos \
  && git clone https://github.com/cmangos/$WOW_VER-db.git
# build
RUN cd ~/cmangos \
  && rm -rf build \
  && mkdir build \
  && cd build \
  && cmake ../mangos -DCMAKE_INSTALL_PREFIX=/home/$DOCKER_USER/cmangos-server \
      -DBUILD_AHBOT=ON -DBUILD_METRICS=ON -DPCH=1 -DDEBUG=0 \
      -DBUILD_PLAYERBOT=ON \
      -DBUILD_GIT_ID=ON \
  && make -j $(nproc) \
  && make install
# pare the etc files
RUN cd /home/$DOCKER_USER/cmangos-server/etc \
  && rm -rf *.conf \
  && cp ahbot.conf.dist ahbot.conf \
  && cp anticheat.conf.dist anticheat.conf \
  && cp mangosd.conf.dist mangosd.conf \
  && cp playerbot.conf.dist playerbot.conf \
  && cp realmd.conf.dist realmd.conf

### db
FROM wxc252/base4cmangos:$BASE_IMAGE_VER-without-maps as cmangos-db

ARG APT_MIRROR=mirrors.ustc.edu.cn
RUN /bin/sh -c set -eux \
  && cp /etc/apt/sources.list /etc/apt/sources.list.bak \
  && sed -i s@/archive.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && sed -i s@/security.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && apt update \
  && apt upgrade \
  && apt-get install -y --no-install-recommends mysql-client vim vim telnet net-tools bind9-utils zip unzip \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list \
  && mv /etc/apt/sources.list.bak /etc/apt/sources.list

ARG WOW_VER=tbc
ARG DOCKER_USER=cmangos
ARG USER_ID=2000
ARG GROUP_ID=2000

COPY --from=builder /root/cmangos/$WOW_VER-db /home/$DOCKER_USER/cmangos/$WOW_VER-db
COPY --from=builder /root/cmangos/mangos /home/$DOCKER_USER/cmangos/mangos

### realm
FROM wxc252/base4cmangos:$BASE_IMAGE_VER-without-maps as cmangos-without-maps

ARG APT_MIRROR=mirrors.ustc.edu.cn

RUN /bin/sh -c set -eux \
  && cp /etc/apt/sources.list /etc/apt/sources.list.bak \
  && sed -i s@/archive.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && sed -i s@/security.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && apt update \
  && apt upgrade \
  && apt-get install -y --no-install-recommends libmysqlclient21 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list \
  && mv /etc/apt/sources.list.bak /etc/apt/sources.list

ARG DOCKER_USER=cmangos
ARG USER_ID=2000
ARG GROUP_ID=2000

COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$DOCKER_USER/cmangos-server /home/$DOCKER_USER/cmangos-server
USER $DOCKER_USER
#realmd
EXPOSE 3724/tcp
WORKDIR /home/$DOCKER_USER
ENTRYPOINT ["cmangos-server/bin/realmd"]

### mangos
FROM wxc252/base4cmangos:$BASE_IMAGE_VER-with-$WOW_VER-maps as cmangos-with-maps

ARG APT_MIRROR=mirrors.ustc.edu.cn

RUN /bin/sh -c set -eux \
  && cp /etc/apt/sources.list /etc/apt/sources.list.bak \
  && sed -i s@/archive.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && sed -i s@/security.ubuntu.com/@/$APT_MIRROR/@g /etc/apt/sources.list \
  && apt update \
  && apt upgrade \
  && apt-get install -y --no-install-recommends libmysqlclient21 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list \
  && mv /etc/apt/sources.list.bak /etc/apt/sources.list


ARG DOCKER_USER=cmangos
ARG USER_ID=2000
ARG GROUP_ID=2000

COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$DOCKER_USER/cmangos-server /home/$DOCKER_USER/cmangos-server
USER $DOCKER_USER
#mangosd
EXPOSE 8085/tcp
#remote console
EXPOSE 3443/tcp
#soap
EXPOSE 7878/tcp
#metrics
EXPOSE 8086/tcp

WORKDIR /home/$DOCKER_USER
ENTRYPOINT ["cmangos-server/bin/mangosd"]

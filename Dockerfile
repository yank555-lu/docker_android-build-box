# Android Build Box based on Ubuntu 20.04 LTS
#
# 2020-04-27 by Yank555.lu

FROM ubuntu:focal
USER root

# Build Arguments
ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ARG GIT_NAME
ARG GIT_EMAIL

# Setup user and folders
RUN addgroup --gid $GROUP_ID $USER_NAME
RUN adduser --home /home/$USER_NAME --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_NAME

RUN rm /home/$USER_NAME/.bashrc
COPY bashrc /home/$USER_NAME/.bashrc
RUN chown $USER_NAME:$USER_NAME /home/$USER_NAME/.bashrc
RUN chmod 644 /home/$USER_NAME/.bashrc

RUN mkdir /home/$USER_NAME/bin
RUN chown $USER_NAME:$USER_NAME /home/$USER_NAME/bin
RUN chmod 755 /home/$USER_NAME/bin

RUN mkdir /home/$USER_NAME/bin.local
RUN chown $USER_NAME:$USER_NAME /home/$USER_NAME/bin.local
RUN chmod 755 /home/$USER_NAME/bin.local

COPY android-environment /home/$USER_NAME/bin.local/android-environment
RUN chmod 755 /home/$USER_NAME/bin.local/android-environment

RUN mkdir /home/source
RUN chown $USER_NAME:$USER_NAME /home/source
RUN chmod 755 /home/source

RUN mkdir /home/out
RUN chown $USER_NAME:$USER_NAME /home/out
RUN chmod 755 /home/out

RUN mkdir /home/ccache
RUN chown $USER_NAME:$USER_NAME /home/ccache
RUN chmod 755 /home/ccache

RUN mkdir /home/$USER_NAME/.ssh
RUN chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
RUN chmod 700 /home/$USER_NAME/.ssh

COPY ssh-config /home/$USER_NAME/.ssh/config
RUN chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh/config
RUN chmod 600 /home/$USER_NAME/.ssh/config

# Install dependencies
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    build-essential \
    file \
    apt-utils \
    net-tools \
    traceroute \
    ccache \
    flex \
    bison \
    gperf \
    zip \
    curl \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    x11proto-core-dev \
    libx11-dev \
    lib32z-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    lib32ncurses5-dev \
    uuid \
    uuid-dev \
    zlib1g-dev \
    liblz-dev \
    liblzo2-2 \
    liblzo2-dev \
    lzop \
    u-boot-tools \
    mtd-utils \
    openjdk-8-jdk \
    device-tree-compiler \
    gdisk \
    m4 \
    libz-dev \
    bc \
    rsync \
    git-core \
    gnupg \
    git \
    schedtool \
    libxml2-utils \
    libssl-dev \
    libtinfo-dev \
    libtinfo5 \
    libncurses5 \
    libncurses5-dev \
    python \
    python3 \
    ssh \
    && apt-get purge -y --auto-remove \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Download latest repo command
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /home/$USER_NAME/bin/repo
RUN chmod 755 /home/$USER_NAME/bin/repo

# Change user and working directory
USER $USER_NAME
WORKDIR /home/source

# Configure git identity
RUN git config --global user.email "$GIT_EMAIL"
RUN git config --global user.name "$GIT_NAME"

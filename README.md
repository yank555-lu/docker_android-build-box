## Create Image ##

The following Dockerfile will build an Android Build System image based on Ubuntu 20.04 LTS.

It will include a container user that matches the user and group IDs and names of the host user. This ensures correct file system permissions if you bind mount local filesystems for sources and out when running the image.

Additionally, it will also preconfigure your git identity.

    docker build -t android-build-box \
        --build-arg USER_NAME=$USER \
        --build-arg USER_ID=$(id -u) \
        --build-arg GROUP_ID=$(id -g) \
        --build-arg GIT_NAME="<your name>" \
        --build-arg GIT_EMAIL="<your email-address>" \
        .

This image will expect the following locations to contain :

    /home/sources : sources to compile
    /home/ccache  : ccache
    /home/out     : out folder

## Run Image ##

Use following command to simply run the image :

    docker run --rm -it \
        -h android-build-box \
        android-build-box \
        bash

Use the following command if you want to bind-mount your local sources, ccache and out folders, as well as your local ssh credentials (read-only) :

    docker run --rm -it \
        -v ~/.ssh:/home/$USER/.ssh:ro \
        -v <local sources folder>:/home/source \
        -v <local ccache folder>:/home/ccache \
        -v <local out folder>:/home/out \
        -h android-build-box \
        android-build-box \
        bash

* Note : In both cases, the container will be autoremoved on exit, if you want to keep the container, omit "--rm".

## Inspiration and Thanks ##

    https://developer.toradex.com/knowledge-base/how-to-setup-android-build-environment-using-docker

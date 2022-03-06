#!/bin/bash

GIT=`which git`

if [ "x" == "x{$GIT}" ]; then
    echo "You don't have git installed?"
    exit 1
fi

USER_EMAIL=`${GIT} config --get user.email`
USER_NAME=`${GIT} config --get user.name`
GID=`getent group ${USER} | awk '{split($0,a,":"); print a[3]}'`


echo "User:  ${USER}"
echo "Name:  ${USER_NAME}"
echo "Email: ${USER_EMAIL}"
echo "UID:   ${UID}"
echo "GID:   ${GID}"

docker build \
    --build-arg USER=${USER} \
    --build-arg USER_NAME="${USER_NAME}" \
    --build-arg USER_EMAIL="${USER_EMAIL}" \
    --build-arg UID="${UID}" \
    --build-arg GID="${GID}" \
    --tag rpi-os-builder .

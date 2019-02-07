#!/usr/bin/env bash

me=$(readlink -f ${BASH_SOURCE})
keyfile=${1:?'expecting a keyfile name, typically ${USER}_${host}_rsa; this is the private key filename'}
if [[ -z "$(dirname ${keyfile})" ]] ; then
    pathname=$(readlink -f ${KEY_D:-~/.ssh/keys.d}/${keyfile})
else
    pathname=$(readlink -f ${keyfile})
fi

# set -x
ssh-keygen -N '' -t rsa -b 4096 -o -C "'${HOSTNAME}:${pathname}' created by '${me}' on $(date +%F\ %T)" -f ${pathname}

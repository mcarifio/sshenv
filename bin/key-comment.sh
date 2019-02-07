#!/usr/bin/env bash

me=$(readlink -f ${BASH_SOURCE})
keyfile=${1:?'expecting a keyfile name, typically ${USER}_${host}_rsa; this is the private key filename'}

if [[ -z "$(dirname ${keyfile})" ]] ; then
    pathname=$(readlink -f ${KEY_D:-~/.ssh/keys.d}/${keyfile})
else
    pathname=$(readlink -f ${keyfile})
fi

# Extract the comment in the key file (the -C argument)
ssh-keygen -l -f ${pathname} | cut -f3- -d' '|sed s/\(RSA\)//g 2>&1


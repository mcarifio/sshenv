#!/usr/bin/env bash
# usage: rsa2pub.sh ${name} [/dev/stdout] # a private keyfile in ~/.keys.d

me=$(readlink -f ${BASH_SOURCE})
here=$(dirname ${me})

keyfile=${1:?'expecting a keyfile name, typically ${USER}_${host}_rsa; this is the private key filename'}
if [[ -z "$(dirname ${keyfile})" ]] ; then
    pathname=$(readlink -f ${KEY_D:-~/.ssh/keys.d}/${keyfile})
else
    pathname=$(readlink -f ${keyfile})
fi

#set -x
if [[ -z "$2" ]] ; then
    pub=${pathname}.pub
    [ -r ${pub} ] && gzip ${pub}
else
    pub=$2
fi


set -o noclobber
( ssh-keygen -y -f ${pathname} ; echo -n ' '; ${here}/key-comment.sh ${pathname} ) | tr -d '\n' > ${pub}

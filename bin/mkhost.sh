#!/usr/bin/env bash

host=${1?'expecting a host'}

here=$(dirname -f ${BASH_SOURCE})
there=$(readlink -f ${here}/../hosts.d)
identity=~/keys.d/${host}_rsa
identity_file="IdentityFile ${identity}"
[[ -r ${identity} ]] || identity_file="# ${identity_file} # to be supplied"
    

cat << EOF
Host ${host}
  RequestTTY=force
  # HostName %r # can be useful here
  HostName ${host}
  # RemoteCommand=reset;exec /bin/bash -i
  ${identity_file}
EOF | tee ${there}/${host}.host.conf



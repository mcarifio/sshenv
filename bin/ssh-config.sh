#!/usr/bin/env bash
cat << EOF
RequestTTY force
Host target
  HostName ${1:-104.236.99.3}
  RemoteCommand reset;exec /bin/bash -i
  # IdentityFile ~/keys.d/mike.carif.io-digitalocean_rsa
EOF

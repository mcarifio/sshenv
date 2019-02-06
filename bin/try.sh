#!/usr/bin/env bash

cat << EOF |
# !Fuc70ff!
Host target
  # User root
  HostName 104.236.99.3
  # IdentityFile ~/keys.d/mike.carif.io-digitalocean_rsa
EOF
mosh -tt -F /dev/stdin target





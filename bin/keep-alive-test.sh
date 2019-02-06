#!/usr/bin/env bash

set -x
ssh -o KeepAlive=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=20 atlantis.local


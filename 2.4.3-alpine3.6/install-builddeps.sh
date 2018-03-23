#!/bin/sh

set -eux

mkdir -p /var/cache/apk
ln -s /var/cache/apk /etc/apk/cache

apk add --no-cache \
  autoconf=2.69-r0 \
  curl=7.59.0-r0 \
  libcurl=7.59.0-r0 \
  bison=3.0.4-r0 \
  coreutils=8.27-r0 \
  readline-dev=6.3.008-r5 \
  linux-headers=4.4.6-r2 \
  patch=2.7.5-r3 \
  libffi-dev=3.2.1-r3 \
  gdbm=1.12-r0 \
  openssl=1.0.2n-r0

rm /etc/apk/cache

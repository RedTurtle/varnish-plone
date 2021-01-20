#!/bin/bash
set -e

# Initializing from environment variables
gosu varnish python /docker-initialize.py

if [ -e "custom.cfg" ]; then
  if [ ! -e ".custom_built" ]; then
    buildout -c custom.cfg
    find /opt/varnish -not -user varnish -exec chown varnish:varnish {} \+
    #gosu varnish python /docker-initialize.py
    touch .custom_built
  fi
fi

exec "$@"

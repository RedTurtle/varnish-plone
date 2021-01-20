#!/bin/bash
set -e

# Initializing from environment variables
gosu varnish python docker-initialize.py

if [ -e "custom.cfg" ]; then
  if [ ! -e ".custom_built" ]; then
    rm -f .installed.cfg
    buildout -c custom.cfg install varnish-configuration varnish-script
    find /opt/varnish -not -user varnish -exec chown varnish:varnish {} \+
    #gosu varnish python docker-initialize.py
    touch .custom_built
  fi
fi

exec "$@"

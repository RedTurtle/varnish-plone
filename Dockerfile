FROM python:3.9-slim-buster

RUN useradd --system -m -d /varnish -U -u 500 varnish && \
    mkdir -p /opt/varnish /data/filestorage /data/blobstorage
WORKDIR /opt/varnish
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY scripts templates buildout_base.cfg ./

RUN buildDeps="automake dpkg-dev gcc git libc6-dev libpcre++-dev libreadline-dev libtool pkg-config python-docutils" && \
    runDeps="gcc git gosu libc6-dev" && \
    apt-get update && \
    apt-get install -y --no-install-recommends $buildDeps && \
    ln -s buildout_base.cfg buildout.cfg && \
    buildout && \
    find /opt/varnish -not -user varnish -exec chown varnish:varnish {} \+ && \
    apt-get purge -y --auto-remove $buildDeps && \
    apt-get install -y --no-install-recommends $runDeps && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /opt/varnish/buildout-cache/downloads/*

COPY docker-initialize.py entrypoint.sh ./

EXPOSE 6081

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s \
  CMD nc -z -w5 127.0.0.1 6081 || exit 1

ENTRYPOINT [ "./entrypoint.sh" ]

CMD [ "gosu", "varnish", "./bin/varnish-script", "-F" ]


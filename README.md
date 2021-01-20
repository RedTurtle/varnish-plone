# A varnish Docker image for Plone #

Everything below here is obsolete and needs update.

## FAQ ##
### Q: How can I change the backend port? ####
__A:__ In the file `buildout.cfg`, section `varnish`,
modify the `backend-port` option,
which defaults to:
```config
[varnish]
...
bind = 127.0.0.1:8099
```

### Q: How can I change varnish port? ####
__A:__ In the file `buildout.cfg`, section `varnish`,
modify the `bind` option,
which defaults to:
```config
[varnish]
...
bind = 127.0.0.1:8099
```

### Q: How can I change varnish telnet interface port? ####
```config
[varnish]
...
telnet = 127.0.0.1:8098
```

### Q: How can I change the cache size? ####
__A:__ In the file `buildout.cfg`, section `varnish`,
modify the `cache-size` option,
which defaults to:
```config
[varnish]
...
cache-size = 512M
```

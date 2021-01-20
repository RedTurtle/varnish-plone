#!/usr/local/bin/python

import re
import os

class Environment(object):
    """ Configure container via environment variables
    """
    def __init__(self, env=os.environ,
                 custom_conf="/opt/varnish/custom.cfg",
                 ):
        self.env = env
        self.custom_conf = custom_conf

    def buildout(self):
        """ Buildout from environment variables
        """
        # Already configured
        if os.path.exists(self.custom_conf):
            return

        findlinks = self.env.get("FIND_LINKS", "").strip().split()

        varnishconf = self.env.get("VARNISH_CONFIGURATION",
                                   "").strip().split(",")

        varnishscript = self.env.get("VARNISH_SCRIPT", "").strip().split(",")

        versions = self.env.get("VERSIONS", "").strip().split()

        sources = self.env.get("SOURCES", "").strip().split(",")

        if not (findlinks or varnishconf or varnishscript or versions or sources):
            return

        buildout = BUILDOUT_TEMPLATE.format(
            findlinks="\n\t".join(findlinks),
            varnishconf="\n".join(varnishconf),
            varnishscript="\n".join(varnishscript),
            versions="\n".join(versions),
            sources="\n".join(sources),
        )

        with open(self.custom_conf, 'w') as cfile:
            cfile.write(buildout)

    def setup(self, **kwargs):
        self.buildout()

    __call__ = setup

BUILDOUT_TEMPLATE = """
[buildout]
extends = buildout_base.cfg
find-links += {findlinks}

[varnish-configuration]
{varnishconf}

[varnish-script]
{varnishscript}

[versions]
{versions}

[sources]
{sources}
"""

def initialize():
    """ Configure Plone instance as ZEO Client
    """
    environment = Environment()
    environment.setup()

if __name__ == "__main__":
    initialize()

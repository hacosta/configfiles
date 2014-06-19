#!/usr/bin/python2

import os
import os.path
import sys

def ln_s(source, name):
    sys.stderr.write('%s => %s', name, source)
    os.symlink(source, name)


WHITELIST = [sys.argv[0], 'install.rb']

configs = [x for x in os.listdir('.') if not x in WHITELIST]

for i in configs:
    ln_s(i, os.path.expanduser('~'))

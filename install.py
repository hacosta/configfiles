#!/usr/bin/python2

import os
import os.path
import shutil
import sys

def rm_rf(path):
    assert(os.path.exists(path))
    if os.path.isdir(path):
        shutil.rmtree(path)
    else:
        os.remove(path)

def ln_s(source, name, overwrite=False, dryrun=False):
    if not os.path.exists(name) or overwrite:
        if os.path.exists(name):
            sys.stderr.write('rm -rf %s\n' % name)
            if not dryrun:
                rm_rf(name)
        sys.stderr.write('%s => %s\n' % (name, source))
        if not dryrun:
            os.symlink(source, name)
    else:
        sys.stderr.write('%s exists, cowardly refusing to overwrite\n' % name)


WHITELIST = [sys.argv[0], 'install.rb', '.git', '.gitignore']

configs = [os.path.abspath(x) for x in os.listdir('.') if not x in WHITELIST]
overwrite = '--force' in sys.argv
dryrun = '--dryrun' in sys.argv

if __name__ == '__main__':
    for i in configs:
        ln_s(i, os.path.join(os.path.expanduser('~'), '.' + os.path.basename(i)), overwrite, dryrun)

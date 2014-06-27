#!/usr/bin/python2

import os
import os.path
import shutil
import subprocess
import sys

WHITELIST = [sys.argv[0], 'install.rb', '.git', '.gitignore']

def pre_hook():
    pass

def post_hook():
    # Install all git submodules
    subprocess.call('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle', shell=True)
    subprocess.call('vim +BundleInstall +qall', shell=True)

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

def do_install(configpath='.', overwrite=False, dryrun=False):
    pre_hook()
    configs = [os.path.abspath(x) for x in os.listdir(configpath) if not x in WHITELIST]
    for i in configs:
        ln_s(i, os.path.join(os.path.expanduser('~'), '.' + os.path.basename(i)), overwrite, dryrun)
    post_hook()

if __name__ == '__main__':
    overwrite = '--force' in sys.argv
    dryrun = '--dryrun' in sys.argv
    do_install('.', overwrite, dryrun)

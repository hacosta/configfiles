#!/usr/bin/python2

# Should be py2.6 compatible

import argparse
import os
import os.path
import shutil
import subprocess
import sys
import logging

THIS_DIR = os.path.dirname(os.path.realpath(__file__))


def gitversion():
    try:
        verstr = subprocess.check_output(['git', '--version']).strip().split('version ')[1]
        return tuple([int(x) for x in verstr.split('.')])
    except Exception:
        return (-1, -1, -1)


def add_version_dependent_config(filename):
    """ Adds config directives that only work on certain versions and copies
    the resulting config to filename.MOD Returns the new filename with the modified
    contents"""
    # XXX: generalize this (using templates?)
    if filename == 'gitconfig':
        if gitversion() > (2, 0, 0):
            with open(filename, 'a') as f:
                f.write('''
    [push]
        default = simple
    ''')
    return filename


WHITELIST = [sys.argv[0], '.git', '.gitignore']


def pre_hook():
    pass


def post_hook():
    # Install all git submodules
    clone_to = os.path.join(THIS_DIR, 'vim/bundle/Vundle.com')
    subprocess.call('git clone https://github.com/VundleVim/Vundle.vim.git %s' % clone_to, shell=True)
    subprocess.call('vim +PluginInstall +qall', shell=True, stdout=open(os.devnull))


def rm_rf(path):
    assert(os.path.exists(path))
    if os.path.isfile(path) or os.path.islink(path):
        os.remove(path)
    elif os.path.isdir(path):
        shutil.rmtree(path)
    else:
        raise Exception('Not a file or directory. Wat do?')


def ln_s(source, name, overwrite=False, dryrun=False):
    if not os.path.exists(name) or overwrite:
        if os.path.islink(name) or os.path.exists(name):  # Handle broken symlinks
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
    configs = [os.path.abspath(x) for x in os.listdir(configpath) if x not in WHITELIST]
    for i in configs:
        src = i
        if os.path.basename(i) == 'gitconfig':
            logging.info('Processing gitconfig')
            src = add_version_dependent_config(i)
        ln_s(src, os.path.join(os.path.expanduser('~'), '.' + os.path.basename(i)), overwrite, dryrun)
    post_hook()


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--force', '-f', action='store_true', default=False)
    parser.add_argument('--dry-run', '-n', action='store_true', default=False)
    return parser.parse_args()


def main():
    args = parse_args()
    do_install('.', args.force, args.dry_run)


if __name__ == '__main__':
    main()

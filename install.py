#!/usr/bin/env python3

from os import symlink, listdir, environ, unlink
from os.path import realpath, isdir, exists, join
from sys import argv
from getopt import gnu_getopt

def main():
  optlist = gnu_getopt(argv[1:], 'fdh', ['force', 'dry-run', 'help'])[0]

  force = False
  dry_run = False
  for o, a in optlist:
    if o in ('-h', '--help'):
      show_help()
      return
    elif o in ('-f', '--force'):
      force = True
    elif o in ('-d', '--dry-run'):
      dry_run = True

  if dry_run:
    print('dry run: no changes will occur')
  link_dir_to_home('files', force, dry_run)

def link_dir_to_home(d, force, dry_run):
  for f in listdir(d):
    f = join(d, f)
    if isdir(f):
      link_dir_to_home(f, force, dry_run)
      continue
    link_to_home(f, force, dry_run)

def link_to_home(source, force, dry_run):
  split = source.split('/')[1:]
  split[0] = '.' + split[0]
  dest = join(environ['HOME'], '/'.join(split))
  if exists(dest):
    if force:
      print('forcing symlink to', dest, 'by removing existing file permanently')
      if not dry_run:
        unlink(dest)
    else:
      print('skipping', dest, '- already exists')
      return
  print('symlinking', realpath(source), 'to', dest)
  if not dry_run:
    symlink(realpath(source), dest)

def show_help():
  print('install.py [-fdh]')
  print()
  print('  install dotfiles to $HOME by symlinking')
  print()
  print('  -f --force\tforce symlinking by removing existing files permanently')
  print('  -d --dry-run\tdon\'t actually make any changes, just print what would happen')
  print('  -h --help\tshow this message and exit')

if __name__ == '__main__':
  main()

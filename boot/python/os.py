# Copyright (c) 2014, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Portions based on Python's os.py

"""OS routines for GRUB."""

import _bits
from operator import itemgetter as _itemgetter
import posixpath as path
import sys

# Remove functions from os.path that we don't support
del path.samefile
del path.sameopenfile
del path.samestat
del path.ismount
path.expanduser = lambda path: path

sys.modules['os.path'] = path

from os.path import (curdir, pardir, sep, pathsep, defpath, extsep, altsep, devnull)

# EX_CANTCREAT
# EX_CONFIG
# EX_DATAERR
# EX_IOERR
# EX_NOHOST
# EX_NOINPUT
# EX_NOPERM
# EX_NOUSER
# EX_OK
# EX_OSERR
# EX_OSFILE
# EX_PROTOCOL
# EX_SOFTWARE
# EX_TEMPFAIL
# EX_UNAVAILABLE
# EX_USAGE
# F_OK
# NGROUPS_MAX
# O_APPEND
# O_ASYNC
# O_CREAT
# O_DIRECT
# O_DIRECTORY
# O_DSYNC
# O_EXCL
# O_LARGEFILE
# O_NDELAY
# O_NOATIME
# O_NOCTTY
# O_NOFOLLOW
# O_NONBLOCK
# O_RDONLY
# O_RDWR
# O_RSYNC
# O_SYNC
# O_TRUNC
# O_WRONLY
# P_NOWAIT
# P_NOWAITO
# P_WAIT
# R_OK
# SEEK_CUR
# SEEK_END
# SEEK_SET
# ST_APPEND
# ST_MANDLOCK
# ST_NOATIME
# ST_NODEV
# ST_NODIRATIME
# ST_NOEXEC
# ST_NOSUID
# ST_RDONLY
# ST_RELATIME
# ST_SYNCHRONOUS
# ST_WRITE
# TMP_MAX
# UserDict
# WCONTINUED
# WCOREDUMP
# WEXITSTATUS
# WIFCONTINUED
# WIFEXITED
# WIFSIGNALED
# WIFSTOPPED
# WNOHANG
# WSTOPSIG
# WTERMSIG
# WUNTRACED
# W_OK
# X_OK
# __all__
# __builtins__
# __doc__
# __file__
# __name__
# __package__
# _copy_reg
# _execvpe
# _exists
# _exit

def _get_exports_list(module):
    try:
        return list(module.__all__)
    except AttributeError:
        return [n for n in dir(module) if n[0] != '_']

# _make_stat_result
# _make_statvfs_result
# _pickle_stat_result
# _pickle_statvfs_result
# _spawnvef
# abort
# access
# chdir
# chmod
# chown
# chroot
# close
# closerange
# confstr
# confstr_names
# ctermid
# dup
# dup2

class _Environ(object):
    def __init__(self):
        pass
    def __repr__(self):
        return repr(_bits._getenvdict())
    def __cmp__(self, other):
        return cmp(_bits._getenvdict(), other)
    def __len__(self):
        return len(_bits._getenvdict())
    def __getitem__(self, key):
        ret = getenv(key)
        if ret is not None:
            return ret
        raise KeyError
    def __setitem__(self, key, item):
        putenv(key, item)
    def __delitem__(self, key):
        unsetenv(key)
    def clear(self):
        for key in self.keys():
            unsetenv(key)
    def copy(self):
        return _bits._getenvdict()
    def keys(self):
        return _bits._getenvdict().keys()
    def items(self):
        return _bits._getenvdict().items()
    def values(self):
        return _bits._getenvdict().values()
    def has_key(self, key):
        return getenv(key) is not None
    def __contains__(self, key):
        return self.has_key(key)
    def update(self, other):
        for k, v in other.items():
            putenv(k, v)
    def get(self, key, failobj=None):
        value = getenv(key)
        if value is not None:
            return value
        else:
            return failobj

environ = _Environ()

# errno

error = OSError

# execl
# execle
# execlp
# execlpe
# execv
# execve
# execvp
# execvpe
# fchdir
# fchmod
# fchown
# fdatasync
# fdopen
# fork
# forkpty
# fpathconf
# fstat
# fstatvfs
# fsync
# ftruncate

def getcwd():
    return "/"

def getcwdu():
    return u"/"

# getegid

getenv = _bits._getenv

# geteuid
# getgid
# getgroups
# getloadavg
# getlogin
# getpgid
# getpgrp
# getpid
# getppid
# getsid
# getuid
# isatty
# kill
# killpg
# lchown
# linesep
# link

listdir = _bits._listdir

# lseek

# We don't support symlinks, so lstat matches stat
def lstat(path):
    return stat(path)

# major
# makedev
# makedirs
# minor
# mkdir
# mkfifo
# mknod

name = 'posix'

# nice
# open
# openpty
# pathconf
# pathconf_names
# pipe
# popen
# popen2
# popen3
# popen4

putenv = _bits._putenv

# read
# readlink
# remove
# removedirs
# rename
# renames
# rmdir
# setegid
# seteuid
# setgid
# setgroups
# setpgid
# setpgrp
# setregid
# setreuid
# setsid
# setuid
# spawnl
# spawnle
# spawnlp
# spawnlpe
# spawnv
# spawnve
# spawnvp
# spawnvpe

# Manual copy of the namedtuple (produced with verbose=True), to avoid a
# circular dependency between os and collections.
class stat_result(tuple):
    'stat_result(st_mode, st_ino, st_dev, st_nlink, st_uid, st_gid, st_size, st_atime, st_mtime, st_ctime)'

    __slots__ = ()

    _fields = ('st_mode', 'st_ino', 'st_dev', 'st_nlink', 'st_uid', 'st_gid', 'st_size', 'st_atime', 'st_mtime', 'st_ctime')

    def __new__(cls, st_mode, st_ino, st_dev, st_nlink, st_uid, st_gid, st_size, st_atime, st_mtime, st_ctime):
        return tuple.__new__(cls, (st_mode, st_ino, st_dev, st_nlink, st_uid, st_gid, st_size, st_atime, st_mtime, st_ctime))

    @classmethod
    def _make(cls, iterable, new=tuple.__new__, len=len):
        'Make a new stat_result object from a sequence or iterable'
        result = new(cls, iterable)
        if len(result) != 10:
            raise TypeError('Expected 10 arguments, got %d' % len(result))
        return result

    def __repr__(self):
        return 'stat_result(st_mode=%r, st_ino=%r, st_dev=%r, st_nlink=%r, st_uid=%r, st_gid=%r, st_size=%r, st_atime=%r, st_mtime=%r, st_ctime=%r)' % self

    def _asdict(t):
        'Return a new dict which maps field names to their values'
        return {'st_mode': t[0], 'st_ino': t[1], 'st_dev': t[2], 'st_nlink': t[3], 'st_uid': t[4], 'st_gid': t[5], 'st_size': t[6], 'st_atime': t[7], 'st_mtime': t[8], 'st_ctime': t[9]}

    def _replace(self, **kwds):
        'Return a new stat_result object replacing specified fields with new values'
        result = self._make(map(kwds.pop, ('st_mode', 'st_ino', 'st_dev', 'st_nlink', 'st_uid', 'st_gid', 'st_size', 'st_atime', 'st_mtime', 'st_ctime'), self))
        if kwds:
            raise ValueError('Got unexpected field names: %r' % kwds.keys())
        return result

    def __getnewargs__(self):
        return tuple(self)

    st_mode = property(_itemgetter(0))
    st_ino = property(_itemgetter(1))
    st_dev = property(_itemgetter(2))
    st_nlink = property(_itemgetter(3))
    st_uid = property(_itemgetter(4))
    st_gid = property(_itemgetter(5))
    st_size = property(_itemgetter(6))
    st_atime = property(_itemgetter(7))
    st_mtime = property(_itemgetter(8))
    st_ctime = property(_itemgetter(9))

def stat(path):
    (mode, size) = _bits._stat(path)
    return stat_result(mode, 0, 0, 0, 0, 0, size, 0, 0, 0)

# stat_float_times
# stat_result
# statvfs
# statvfs_result
# strerror
# symlink
# sys
# sysconf
# sysconf_names
# system
# tcgetpgrp
# tcsetpgrp
# tempnam
# times
# tmpfile
# tmpnam
# ttyname
# umask
# uname
# unlink

unsetenv = _bits._unsetenv

# urandom
# utime
# wait
# wait3
# wait4
# waitpid
# walk
# write

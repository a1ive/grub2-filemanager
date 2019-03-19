# Copyright (c) 2011, Intel Corporation
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

"""redirect module."""

import bits as _bits
import bits.pyfs
import struct as _struct
import sys as _sys
import contextlib

__all__ = ["redirect", "write_logfile", "clear", "log", "logonly", "nolog"]

NOLOG_STATE, LOGONLY_STATE, LOG_STATE = range(3)
state = LOG_STATE

class Tee(object):
    """Tee output to both input files provided."""
    def __init__(self, out1, out2):
        self.out1 = out1
        self.out2 = out2
    def write(self, data):
        self.out1.write(data)
        self.out2.write(data)
    def flush(self):
        self.out1.flush()
        self.out2.flush()

# Create the log file
_log = bits.pyfs.pyfs_file("log")

def write_logfile(filename):
    f = file(filename)
    data, blocks = _bits.file_data_and_disk_blocks(f)
    total_size = len(data)
    logdata = _log.getvalue()[:total_size].ljust(total_size, "\n")
    bytes_written = 0
    for sector, offset, length in blocks:
        chunk = logdata[bytes_written:bytes_written+length]
        if chunk != data[bytes_written:bytes_written+length]:
            _bits.disk_write(f, sector, offset, logdata[bytes_written:bytes_written+length])
        bytes_written += length

def _log_header():
    print >>_log, "GNU GRUB"
    print >>_log

def redirect():
    """Redirect all screen outputs (stdout and stderr) to a log file.

    Not to be called except as part of system initialization."""
    global _orig_stdout, _orig_stderr
    _log_header()
    _orig_stdout = _sys.stdout
    _orig_stderr = _sys.stderr
    _sys.stdout = Tee(_orig_stdout, _log)
    _sys.stderr = Tee(_orig_stderr, _log)

def clear():
    """Clear the log file."""
    _log.truncate(0)
    _log_header()

@contextlib.contextmanager
def _redirect_stdout(f):
    old_stdout = _sys.stdout
    try:
        _sys.stdout = f
        yield
    finally:
        _sys.stdout = old_stdout

@contextlib.contextmanager
def _redirect_stderr(f):
    old_stderr = _sys.stderr
    try:
        _sys.stderr = f
        yield
    finally:
        _sys.stderr = old_stderr

@contextlib.contextmanager
def log():
    """with log() sends stdout/stderr to both the screen and the log file"""
    global state
    saved_state = state
    state = LOG_STATE
    with _redirect_stdout(Tee(_orig_stdout, _log)):
        with _redirect_stderr(Tee(_orig_stderr, _log)):
            yield
    state = saved_state

@contextlib.contextmanager
def logonly():
    """with logonly() sends stdout to the log only, and stderr to both screen and log"""
    global state
    saved_state = state
    state = LOGONLY_STATE
    with _redirect_stdout(_log):
        with _redirect_stderr(Tee(_orig_stderr, _log)):
            yield
    state = saved_state

@contextlib.contextmanager
def nolog():
    """with nolog() sends stdout/stderr to the screen only"""
    global state
    saved_state = state
    state = NOLOG_STATE
    with _redirect_stdout(_orig_stdout):
        with _redirect_stderr(_orig_stderr):
            yield
    state = saved_state

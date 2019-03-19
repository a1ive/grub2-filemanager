# Copyright (c) 2013, Intel Corporation
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

"""pyfs module."""

from cStringIO import StringIO as _StringIO
import _pyfs

_pyfs_files = {}

def _pyfs_dir(dirname):
    """_pyfs_dir(dirname) -> an iterable of (filename, is_directory) pairs,
    or None if not a directory"""
    if dirname != "/":
        return None
    return [(filename, 0) for filename in sorted(_pyfs_files.iterkeys())]

def _lookup(filename):
    components = filename.split("/")
    if len(components) != 2 or components[0] != '':
        return None
    return _pyfs_files.get(components[1])

def _pyfs_open(filename):
    """_pyfs_open(filename) -> the file size, or None if the file does not exist"""
    functions = _lookup(filename)
    if functions is None:
        return None
    do_open, do_read = functions
    return do_open()

def _pyfs_read(filename, offset, size):
    """_pyfs_read(filename, offset, size) -> size bytes starting at offset,
    as a string"""
    functions = _lookup(filename)
    if functions is None:
        return None
    do_open, do_read = functions
    return do_read(offset, size)

_pyfs._set_pyfs_callbacks(_pyfs_dir, _pyfs_open, _pyfs_read)

def pyfs_add(filename, do_open, do_read):
    """Add a file to the (python) filesystem.

    Attempts to open and read the file will get passed to the specified open
    and read functions, which should have the following signatures:

    do_open(): return the length of the file.

    do_read(offset, size): return the data from offset to offset+size as a
    string."""
    assert "/" not in filename
    assert "\0" not in filename
    assert _pyfs_files.get(filename) is None
    assert callable(do_open)
    assert callable(do_read)
    _pyfs_files[filename] = do_open, do_read

def pyfs_del(filename):
    """Delete an existing file from the (python) filesystem."""
    del _pyfs_files[filename]

def add_static(filename, contents):
    """Add a file to the (python) filesystem with the given static contents.

    Use this function when the contents of the file will never need to change.
    If you need to dynamically generate the file contents, use pyfs_add."""
    l = len(contents)
    def do_open():
        return l
    def do_read(offset, size):
        return contents[offset:offset+size]
    pyfs_add(filename, do_open, do_read)

class pyfs_file(object):
    """A temporary file in the (python) filesystem"""

    def __init__(self, basename):
        self.basename = basename
        self._file = _StringIO()
        pyfs_add(self.basename, self._do_open, self._do_read)

    # Forward everything to StringIO; cannot inherit from the cStringIO
    # version of StringIO, so this is the next simplest thing.
    def __getattr__(self, name):
        return getattr(self._file, name)

    # Context management protocol
    def __enter__(self):
        if self._file.closed:
            raise ValueError("Cannot enter context with closed file")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    # Don't close the underlying file when closing the temporary file, because
    # that will prevent reading the same StringIO via (python)/filename
    def close(self):
        pass

    def __iter__(self):
        return self._file.__iter__()

    @property
    def filename(self):
        return "(python)/" + self.basename

    @property
    def size(self):
        return len(self._file.getvalue())

    def _do_open(self):
        return self.size

    def _do_read(self, offset, size):
        pos = self.tell()
        self.seek(offset)
        ret = self._file.read(size)
        self.seek(pos)
        return ret

    def delete(self):
        pyfs_del(self.basename)
        self._file.close()

    def xreadlines(self):
        return self

    def flush(self):
        self._file.flush()

# Copyright (c) 2015, Intel Corporation
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

"""bits module."""

from __future__ import print_function
import _bits
from _bits import *
import ctypes
import functools
import itertools
from collections import namedtuple
import string
import struct
import time

ptrsize = struct.calcsize("P")

_grub_command_map = {}

def addr_alignment(addr):
    """Compute the maximum alignment of a specified address, up to 4."""
    return addr & 1 or addr & 2 or 4

def register_grub_command(command, func, summary, description):
    """Register a new GRUB command, implemented using the given callable.
    The callable should accept a single argument, the list of argument strings.
    The arguments include the command name as [0]."""
    _bits._register_grub_command(command, summary, description)
    _grub_command_map[command] = func

def _grub_command_callback(args):
    try:
        return _grub_command_map[args[0]](args)
    except:
        import traceback
        traceback.print_exc()
        return False

_bits._set_grub_command_callback(_grub_command_callback)

def grouper(n, iterable, fillvalue=None):
    "grouper(3, 'ABCDEFG', 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * n
    return itertools.izip_longest(fillvalue=fillvalue, *args)

def dumpmem(mem, addr=0):
    """Dump hexadecimal and printable ASCII bytes for a memory buffer"""
    s = ''
    for offset, chunk in zip( range(0, len(mem), 16), grouper(16, mem) ):
        s += "{:08x}: ".format(addr + offset)
        s += " ".join("  " if x is None else "{:02x}".format(ord(x)) for x in chunk)
        s += "  "
        for x in chunk:
            if x is None:
                s += ' '
            elif x in string.letters or x in string.digits or x in string.punctuation:
                s += x
            else:
                s += '.'
        s += '\n'
    return s

def set_func_ptr(funcptr_ptr, wrapper):
    """Set a C function pointer to a ctypes-wrapped Python function

    C code should export the address of the function pointer using
    PyLong_FromVoidPtr. Python code should pass that address as the first
    argument, and the wrapper as the second argument. Python code must maintain
    a reference to the wrapper to prevent it from being garbage-collected."""
    ctypes.c_ulong.from_address(funcptr_ptr).value = ctypes.cast(wrapper, ctypes.c_void_p).value

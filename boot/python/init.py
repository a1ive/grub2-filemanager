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
#
# Portions based on site.py from Python 2.6, under the Python license.

"""Python initialization, to run at BITS startup."""

import _bits

start = _bits._time()

def current_time():
    global start
    return _bits._time()-start

def time_prefix():
    return "[{:02.02f}]".format(current_time())

class import_annotation(object):
    def __init__(self, modname):
        self.modname = modname

    # Context management protocol
    def __enter__(self):
        print "{} Import {}".format(time_prefix(), self.modname)

    def __exit__(self, exc_type, exc_val, exc_tb):
        print "{} Import {} done".format(time_prefix(), self.modname)

class init_annotation(object):
    def __init__(self, modname):
        self.modname = modname

    # Context management protocol
    def __enter__(self):
        print "{} Init {}".format(time_prefix(), self.modname)

    def __exit__(self, exc_type, exc_val, exc_tb):
        print "{} Init {} done".format(time_prefix(), self.modname)

def early_init():
    with import_annotation("redirect"):
        import redirect
    with init_annotation("redirect"):
        redirect.redirect()
        
    with import_annotation("os"):
        import os

def init():
    with import_annotation("bits"):
        import bits

    with import_annotation("os"):
        import os

    with import_annotation("sys"):
        import sys
    sys.argv = []

    with import_annotation("readline"):
        import readline
    with init_annotation("readline"):
        readline.init()
    with import_annotation("rlcompleter_extra"):
        import rlcompleter_extra

    if sys.platform == "BITS-EFI":
        with import_annotation("efi"):
            import efi
        with init_annotation("efi"):
            efi.register_keyboard_interrupt_handler()

    with import_annotation("__builtin__"):
        import __builtin__

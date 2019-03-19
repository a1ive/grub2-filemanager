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

"""bits.input: Support for keyboard input"""

import sys
from collections import namedtuple

# key contains either a one-character string or one of the constants below.
# shift, ctrl, and alt are booleans.
KEY = namedtuple("KEY", ("key", "shift", "ctrl", "alt"))

def key(key, shift=False, ctrl=False, alt=False):
    return KEY(key, shift, ctrl, alt)

if sys.platform == 'BITS-EFI':
    from efikeys import *

    stiex = None

    def get_key():
        global stiex
        import efi
        import ctypes
        if stiex is None:
            stiex = efi.EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL.from_handle(efi.system_table.ConsoleInHandle)
        key_data = efi.EFI_KEY_DATA()
        while True:
            ret = stiex.ReadKeyStrokeEx(stiex, ctypes.byref(key_data))
            if ret == efi.EFI_NOT_READY:
                continue
            efi.check_status(ret)
            mod = 0
            if key_data.KeyState.KeyShiftState & efi.EFI_SHIFT_STATE_VALID:
                mod = key_data.KeyState.KeyShiftState
            shift=bool(mod & (efi.EFI_LEFT_SHIFT_PRESSED | efi.EFI_RIGHT_SHIFT_PRESSED))
            ctrl=bool(mod & (efi.EFI_LEFT_CONTROL_PRESSED | efi.EFI_RIGHT_CONTROL_PRESSED))
            alt=bool(mod & (efi.EFI_LEFT_ALT_PRESSED | efi.EFI_RIGHT_ALT_PRESSED))
            if key_data.Key.UnicodeChar != '\x00':
                key = key_data.Key.UnicodeChar
            else:
                key = key_data.Key.ScanCode
            return KEY(key, shift, ctrl, alt)

else:
    from _bits import _get_key

    MOD_SHIFT = 0x1000000
    MOD_CTRL  = 0x2000000
    MOD_ALT   = 0x4000000
    EXTENDED  = 0x0800000

    KEY_ESC = 0x1b
    KEY_LEFT = EXTENDED | 0x4b
    KEY_RIGHT = EXTENDED | 0x4d
    KEY_UP = EXTENDED | 0x48
    KEY_DOWN = EXTENDED | 0x50
    KEY_HOME = EXTENDED | 0x47
    KEY_END = EXTENDED | 0x4f
    KEY_INS = EXTENDED | 0x52
    KEY_INSERT = KEY_INS
    KEY_DEL = EXTENDED | 0x53
    KEY_DELETE = KEY_DEL
    KEY_PGUP = EXTENDED | 0x49
    KEY_PAGE_UP = KEY_PGUP
    KEY_PGDN = EXTENDED | 0x51
    KEY_PAGE_DOWN = KEY_PGDN
    KEY_F1 = EXTENDED | 0x3b
    KEY_F2 = EXTENDED | 0x3c
    KEY_F3 = EXTENDED | 0x3d
    KEY_F4 = EXTENDED | 0x3e
    KEY_F5 = EXTENDED | 0x3f
    KEY_F6 = EXTENDED | 0x40
    KEY_F7 = EXTENDED | 0x41
    KEY_F8 = EXTENDED | 0x42
    KEY_F9 = EXTENDED | 0x43
    KEY_F10 = EXTENDED | 0x44
    KEY_F11 = EXTENDED | 0x85
    KEY_F12 = EXTENDED | 0x86

    def get_key():
        key = _get_key()
        shift = bool(key & MOD_SHIFT)
        ctrl = bool(key & MOD_CTRL)
        alt = bool(key & MOD_ALT)
        key &= ~(MOD_SHIFT | MOD_CTRL | MOD_ALT)
        if not(key & EXTENDED) and key != KEY_ESC:
            key = chr(key)
        return KEY(key, shift, ctrl, alt)

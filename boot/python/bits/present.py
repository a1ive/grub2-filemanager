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

"""Give a presentation using EFI Graphics Output Protocol (GOP)."""

from __future__ import print_function
import bits
import bits.input
from ctypes import *
from efi import *
import itertools
import os
import readline
import zlib

EFI_GRAPHICS_PIXEL_FORMAT = UINTN
PixelRedGreenBlueReserved8BitPerColor, PixelBlueGreenRedReserved8BitPerColor, PixelBitMask, PixelBltOnly, PixelFormatMax = range(5)

EFI_GRAPHICS_OUTPUT_BLT_OPERATION = UINTN
EfiBltVideoFill, EfiBltVideoToBltBuffer, EfiBltBufferToVideo, EfiBltVideoToVideo, EfiGraphicsOutputBltOperationMax = range(5)

class EFI_PIXEL_BITMASK(bits.cdata.Struct):
    """EFI PIXEL BITMASK"""
    _fields_ = [
        ('RedMask', UINT32),
        ('GreenMask', UINT32),
        ('BlueMask', UINT32),
        ('ReservedMask', UINT32),
    ]

class EFI_GRAPHICS_OUTPUT_MODE_INFORMATION(bits.cdata.Struct):
    """EFI Graphics Output Mode Information"""
    _fields_ = [
        ('Version', UINT32),
        ('HorizontalResolution', UINT32),
        ('VerticalResolution', UINT32),
        ('PixelFormat', EFI_GRAPHICS_PIXEL_FORMAT),
        ('PixelInformation', EFI_PIXEL_BITMASK),
        ('PixelsPerScanLine', UINT32),
    ]

class EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE(bits.cdata.Struct):
    """EFI Graphics Output Protocol Mode"""
    _fields_ = [
        ('MaxMode', UINT32),
        ('Mode', UINT32),
        ('Info', POINTER(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION)),
        ('SizeOfInfo', UINTN),
        ('FrameBufferBase', EFI_PHYSICAL_ADDRESS),
        ('FrameBufferSize', UINTN),
    ]

class EFI_GRAPHICS_OUTPUT_BLT_PIXEL(bits.cdata.Struct):
    _fields_ = [
        ('Blue', UINT8),
        ('Green', UINT8),
        ('Red', UINT8),
        ('Reserved', UINT8),
    ]

class EFI_GRAPHICS_OUTPUT_PROTOCOL(Protocol):
    """EFI Graphics Output Protocol"""
    guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID

EFI_GRAPHICS_OUTPUT_PROTOCOL._fields_ = [
    ('QueryMode', FUNC(POINTER(EFI_GRAPHICS_OUTPUT_PROTOCOL), UINT32, POINTER(UINTN), POINTER(POINTER(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION)))),
    ('SetMode', FUNC(POINTER(EFI_GRAPHICS_OUTPUT_PROTOCOL), UINT32)),
    ('Blt', FUNC(POINTER(EFI_GRAPHICS_OUTPUT_PROTOCOL), POINTER(EFI_GRAPHICS_OUTPUT_BLT_PIXEL), EFI_GRAPHICS_OUTPUT_BLT_OPERATION, UINTN, UINTN, UINTN, UINTN, UINTN, UINTN, UINTN)),
    ('Mode', POINTER(EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE)),
]

def init():
    global gop
    gop = EFI_GRAPHICS_OUTPUT_PROTOCOL.from_handle(system_table.ConsoleOutHandle)

def load(name="slides", bufsize=1024):
    """Load presentation slides"""
    global slides, current_slide, max_slide, saved_screen
    init()
    info = gop.Mode.contents.Info.contents
    saved_screen = (info.HorizontalResolution * info.VerticalResolution * EFI_GRAPHICS_OUTPUT_BLT_PIXEL)()
    directory = os.path.join("/", name, "{}x{}".format(info.HorizontalResolution, info.VerticalResolution))
    slides = []
    for n in itertools.count(1):
        try:
            f = open(os.path.join(directory, "{}z".format(n)), "rb")
            s = ''.join(iter(lambda:f.read(bufsize), ''))
            s = zlib.decompress(s)
        except IOError:
            max_slide = n - 2
            break
        slides.append(create_string_buffer(s, len(s)))
    current_slide = 0
    sizes = list(len(f) for f in slides)
    if set(sizes) != set([info.HorizontalResolution * info.VerticalResolution * sizeof(EFI_GRAPHICS_OUTPUT_BLT_PIXEL)]):
        print("Load error: Inconsistent buffer sizes = {}".format(sizes))
    readline.add_key_hook(bits.input.KEY_F10, resume)

def resume():
    """Start or resume a presentation"""
    global slides, current_slide, max_slide, saved_screen
    info = gop.Mode.contents.Info.contents
    gop.Blt(byref(gop), saved_screen, EfiBltVideoToBltBuffer, 0, 0, 0, 0, info.HorizontalResolution, info.VerticalResolution, 0)
    while True:
        if len(slides[current_slide]) != info.HorizontalResolution * info.VerticalResolution * sizeof(EFI_GRAPHICS_OUTPUT_BLT_PIXEL):
            break
        slide_p = cast(slides[current_slide], POINTER(EFI_GRAPHICS_OUTPUT_BLT_PIXEL))
        gop.Blt(byref(gop), slide_p, EfiBltBufferToVideo, 0, 0, 0, 0, info.HorizontalResolution, info.VerticalResolution, 0)
        k = bits.input.get_key()
        if k.key == bits.input.KEY_ESC:
            break
        elif k.key in (bits.input.KEY_LEFT, bits.input.KEY_UP, bits.input.KEY_PAGE_UP):
            if current_slide > 0:
                current_slide -= 1
        elif k.key in (bits.input.KEY_RIGHT, bits.input.KEY_DOWN, bits.input.KEY_PAGE_DOWN, ' '):
            if current_slide < max_slide:
                current_slide += 1
        elif k.key == bits.input.KEY_HOME:
            current_slide = 0
    gop.Blt(byref(gop), saved_screen, EfiBltBufferToVideo, 0, 0, 0, 0, info.HorizontalResolution, info.VerticalResolution, 0)

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

"""time module."""

import _bits
from collections import namedtuple

struct_time = namedtuple('struct_time', ['tm_year', 'tm_mon', 'tm_mday',
                                         'tm_hour', 'tm_min', 'tm_sec',
                                         'tm_wday', 'tm_yday', 'tm_isdst'])

#accept2dyear
#altzone
#asctime
#clock
#ctime
#daylight

def localtime(seconds = None):
    """
    localtime([seconds]) -> (tm_year,tm_mon,tm_mday,tm_hour,tm_min,
                             tm_sec,tm_wday,tm_yday,tm_isdst)

    Convert seconds since the Epoch to a time tuple expressing local time.
    When 'seconds' is not passed in, convert the current time instead.
    """

    if seconds is not None:
        loctime = struct_time(*_bits._localtime(seconds))
    else:
        loctime = struct_time(*_bits._localtime())

    if (loctime.tm_year % 400) == 0:
       leap_year = 1
    elif (loctime.tm_year % 100) == 0:
       leap_year = 0
    elif (loctime.tm_year % 4) == 0:
       leap_year = 1
    else:
       leap_year = 0

    ordinaldate = sum([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][0:loctime.tm_mon-1]) + loctime.tm_mday + leap_year

    return loctime._replace(tm_yday = ordinaldate)

# Support gmtime for compatibility with callers.  Timezones intentionally
# ignored; always assumes localtime matches UTC.
gmtime = localtime

#mktime

def sleep(seconds):
    """sleep(seconds)

    Delay execution for a given number of seconds.  The argument may be
    a floating point number for subsecond precision."""
    if seconds < 0:
        raise ValueError("seconds must not be negative")
    start = time()
    while time() - start < seconds:
        pass

#strftime
#strptime
#struct_time

time = _bits._time

#timezone
#tzname
#tzset

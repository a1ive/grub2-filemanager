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

"""readline module."""

import bits
import bits.input
import pager
import redirect
import string
import sys

__all__ = ["init", "get_completer", "set_completer", "parse_and_bind"]

width = []
height = []
line_x = []
line_y = []
buffer_max = 0
history = []
kill_ring = [] # Most recent last
kill_accumulate = False
ctrl_o_index = None
completer = None

def init():
    """Initialize the readline module and configure it as the Python readline callback."""
    from _bits import _set_readline_callback
    _set_readline_callback(_readline)

def insert_char(line_buffer, c, pos):
    global buffer_max
    if len(line_buffer) < buffer_max:
        line_buffer = line_buffer[:pos] + c + line_buffer[pos:]
        pos = pos + 1
    return line_buffer, pos

def delete_char(line_buffer, pos):
    if len(line_buffer) > 0:
        line_buffer = line_buffer[:pos] + line_buffer[pos+1:]
    return line_buffer, pos

def delete_char_left(line_buffer, pos):
    if pos == 0:
        return line_buffer, pos
    line_buffer, temp_pos = delete_char(line_buffer, pos - 1)
    return line_buffer, pos - 1

def insert_string(line_buffer, s, pos):
    global buffer_max
    chars_remaining = buffer_max - len(line_buffer)
    if chars_remaining < len(s):
        s = s[:chars_remaining]
    line_buffer = line_buffer[:pos] + s + line_buffer[pos:]
    insert_start = pos
    pos = pos + len(s)
    return line_buffer, insert_start, pos

def add_to_kill_ring(s, to_right):
    global kill_ring, kill_accumulate
    if kill_accumulate:
        if to_right:
            kill_ring[-1] = kill_ring[-1] + s
        else:
            kill_ring[-1] = s + kill_ring[-1]
    else:
        kill_ring.append(s)
    kill_accumulate = True

def print_buffer(line_buffer, x, y, term):
    global width, height, line_y
    curr_pos = 0
    while curr_pos < len(line_buffer):
        bits.goto_xy(x, y, term)
        max_width = width[term] - 1 - x
        newline = False
        if len(line_buffer) - curr_pos >= max_width:
            partial_count = max_width
            x = 0
            y = y + 1
            newline = True
        else:
            partial_count = len(line_buffer) - curr_pos
            x = x + partial_count
        bits.puts(line_buffer[curr_pos:curr_pos + partial_count], term)
        if newline:
            bits.puts('\n', term)
            # check for scroll here and adjust start position
            if y == height[term]:
                y = y - 1
                line_y[term] = line_y[term] - 1
        curr_pos = curr_pos + partial_count

def PositionCursor(pos, x, y, term):
    global width
    curr_pos = 0
    while curr_pos < pos:
        max_width = width[term] - 1 - x
        if pos - curr_pos >= max_width:
            partial_count = max_width
            x = 0
            y = y + 1
        else:
            partial_count = pos - curr_pos
            x = x + partial_count
        curr_pos = curr_pos + partial_count
    bits.goto_xy(x, y, term)
    return(x, y)

def get_completer():
    """Get the readline completer function."""

    global completer
    return completer

def set_completer(f):
    """Set the readline completer function."""

    global completer
    completer = f

def parse_and_bind(s):
    """Stub parse_and_bind() function for compatibility with readline.

    This module does not support readline's configuration syntax, so this
    function does nothing."""
    return None

key_hooks = {}
function_keys = set(getattr(bits.input, "KEY_F{}".format(n)) for n in range(1, 12+1))

def add_key_hook(key, func):
    global key_hooks
    assert key in function_keys
    assert key_hooks.get(key) in (None, func)
    key_hooks[key] = func

def _readline(prompt=""):
    global width, height, line_x, line_y, buffer_max, history, kill_ring, kill_accumulate, ctrl_o_index, completer

    with redirect.nolog():
        with pager.nopager():
            sys.stdout.write(prompt)

            line_buffer = ''
            pos = 0
            prev_len = 0

            term_count = bits.get_term_count()
            width = [0] * term_count
            height = [0] * term_count
            line_x = [0] * term_count
            line_y = [0] * term_count

            for term in range(term_count):
                width[term], height[term] = bits.get_width_height(term)
                line_x[term], line_y[term] = bits.get_xy(term)

            buffer_max = min((width[term] - 2 - line_x[term]) + ((height[term] - 1) * (width[term] - 1)) for term in range(term_count))

            history_index = len(history)
            history_state = dict()
            completer_state = 0
            last_yank_start = None
            kill_accumulate = False

            if ctrl_o_index is not None:
                if ctrl_o_index < len(history):
                    history_index = ctrl_o_index
                    line_buffer = history[history_index]
                    pos = len(line_buffer)
                ctrl_o_index = None

            while True:
                # Update history
                history_state[history_index] = (line_buffer, pos)

                try:
                    # clear any characters after the current line buffer
                    trailing_len = prev_len - len(line_buffer)
                    if trailing_len > 0:
                        for term in range(term_count):
                            trailing_x, trailing_y = PositionCursor(len(line_buffer), line_x[term], line_y[term], term)
                            print_buffer(" " * trailing_len, trailing_x, trailing_y, term)
                    prev_len = len(line_buffer)

                    for term in range(term_count):
                        # print the current line buffer
                        print_buffer(line_buffer, line_x[term], line_y[term], term)
                        # move the cursor to location of pos within the line buffer
                        PositionCursor(pos, line_x[term], line_y[term], term)

                    c = bits.input.get_key()

                    key = bits.input.key
                    def ctrl(k):
                        return key(k, ctrl=True)

                    # Reset states that depend on last key
                    if c != key('y', alt=True):
                        last_yank_start = None
                    if c not in (ctrl('k'), ctrl('u'), ctrl('w')):
                        kill_accumulate = False

                    if c == key('\r') or c == key('\n') or c == ctrl('o'):
                        if line_buffer or (history and history[-1]):
                            history.append(line_buffer)
                        if c == ctrl('o'): # Ctrl-O
                            ctrl_o_index = history_index + 1
                        sys.stdout.write('\n')
                        return line_buffer + '\n'

                    if not (c == key('\t') or c == ctrl('i')):
                        # reset completer state to force restart of the completer
                        completer_state = 0

                    if c == key(bits.input.KEY_HOME) or c == ctrl('a'):
                        # start of line
                        pos = 0
                    elif c == key(bits.input.KEY_LEFT) or c == ctrl('b'):
                        # left
                        if pos != 0:
                            pos -= 1
                    elif c == ctrl('d'):
                        # EOF
                        if len(line_buffer) == 0:
                            return ""
                        if pos < len(line_buffer):
                            line_buffer, pos = delete_char(line_buffer, pos)
                    elif c == key(bits.input.KEY_DELETE):
                        if pos < len(line_buffer):
                            line_buffer, pos = delete_char(line_buffer, pos)
                    elif c == key(bits.input.KEY_END) or c == ctrl('e'):
                        # end of line
                        pos = len(line_buffer)
                    elif c == key(bits.input.KEY_RIGHT) or c == ctrl('f'):
                        # right
                        if pos != len(line_buffer):
                            pos += 1
                    elif c == key('\b') or c == ctrl('h'):
                        # backspace
                        line_buffer, pos = delete_char_left(line_buffer, pos)
                    elif c == key('\t') or c == ctrl('i'):
                        # tab completion
                        if completer is not None:
                            if completer_state != 0:
                                for c in range(len(current_completion)):
                                    line_buffer, pos = delete_char_left(line_buffer, pos)
                            else:
                                cur = pos
                                while pos != 0 and line_buffer[pos-1] != ' ':
                                    pos -= 1
                                saved_str = line_buffer[pos:cur]
                                line_buffer = line_buffer[:pos] + line_buffer[cur:]
                            current_completion = completer(saved_str, completer_state)
                            completer_state += 1
                            if current_completion is not None:
                                for c in current_completion:
                                    line_buffer, pos = insert_char(line_buffer, c, pos)
                            else:
                                for c in saved_str:
                                    line_buffer, pos = insert_char(line_buffer, c, pos)
                                completer_state = 0
                    elif c == ctrl('k'):
                        # delete from current to end of line
                        killed_text = line_buffer[pos:]
                        line_buffer = line_buffer[:pos]
                        add_to_kill_ring(killed_text, to_right=True)
                    elif c == ctrl('l'):
                        # clear screen
                        bits.clear_screen()
                        sys.stdout.write(prompt)
                        for term in range(term_count):
                            line_x[term], line_y[term] = bits.get_xy(term);
                    elif c == key(bits.input.KEY_DOWN) or c == ctrl('n'):
                        # Next line in history
                        if history_index < len(history):
                            history_index += 1
                            if history_index == len(history):
                                line_buffer, pos = history_state.get(history_index, ('', 0))
                            else:
                                line_buffer, pos = history_state.get(history_index, (history[history_index], len(history[history_index])))
                    elif c == key(bits.input.KEY_UP) or c == ctrl('p'):
                        # Previous line in history
                        if history_index > 0:
                            history_index -= 1
                            line_buffer, pos = history_state.get(history_index, (history[history_index], len(history[history_index])))
                    elif c == ctrl('u'):
                        # delete from current to beginning of line
                        killed_text = line_buffer[:pos]
                        line_buffer = line_buffer[pos:]
                        pos = 0
                        add_to_kill_ring(killed_text, to_right=False)
                    elif c == ctrl(bits.input.KEY_LEFT):
                        # Move left by word
                        while pos != 0 and not line_buffer[pos-1].isalnum():
                            pos -= 1
                        while pos != 0 and line_buffer[pos-1].isalnum():
                            pos -= 1
                    elif c == ctrl(bits.input.KEY_RIGHT):
                        # Move right by word
                        end = len(line_buffer)
                        while pos != end and not line_buffer[pos].isalnum():
                            pos += 1
                        while pos != end and line_buffer[pos].isalnum():
                            pos += 1
                    elif c == ctrl('w'):
                        # delete previous word; note that this uses a different
                        # definition of "word" than Ctrl-Left and Ctrl-Right.
                        cur = pos
                        while pos != 0 and line_buffer[pos-1] == ' ':
                            pos -= 1
                        while pos != 0 and line_buffer[pos-1] != ' ':
                            pos -= 1
                        killed_text = line_buffer[pos:cur]
                        line_buffer = line_buffer[:pos] + line_buffer[cur:]
                        add_to_kill_ring(killed_text, to_right=False)
                    elif c == ctrl('y'):
                        # Yank
                        if kill_ring:
                            line_buffer, last_yank_start, pos = insert_string(line_buffer, kill_ring[-1], pos)
                    elif c == key('y', alt=True):
                        # If immediately after yank, rotate kill ring and yank
                        # the new top instead.
                        if last_yank_start is not None:
                            line_buffer = line_buffer[:last_yank_start] + line_buffer[pos:]
                            pos = last_yank_start
                            kill_ring.insert(0, kill_ring.pop()) # Rotate
                            line_buffer, last_yank_start, pos = insert_string(line_buffer, kill_ring[-1], pos)
                    elif c == ctrl('z') or c == key(bits.input.KEY_ESC):
                        if len(line_buffer) == 0:
                            return ""
                    elif c.key in key_hooks:
                        key_hooks[c.key]()
                    elif not(c.ctrl) and not(c.alt) and isinstance(c.key, basestring) and c.key in string.printable:
                        # printable
                        try:
                            line_buffer, pos = insert_char(line_buffer, c.key.encode('ascii'), pos)
                        except UnicodeError:
                            pass
                    else:
                        pass

                except IOError:
                    pass

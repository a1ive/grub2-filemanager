# Based on Python's rlcompleter.py, under the Python license.  Replacement for
# the function computing possible matches, with the following improvements:
# - Sort matches and eliminate duplicates.
# - Handle subscripting with [].

def undercmp(s1, s2):
    """Compare two strings, sorting leading underscores last."""
    if s1.startswith("_"):
        if s2.startswith("_"):
            return undercmp(s1[1:], s2[1:])
        return 1
    if s2.startswith("_"):
        return -1
    return cmp(s1, s2)

def attr_matches(self, text):
    """Compute matches when text contains a dot.

    Assuming the text is of the form NAME.NAME....[NAME], and is
    evaluatable in self.namespace, it will be evaluated and its attributes
    (as revealed by dir()) are used as possible completions.  (For class
    instances, class members are also considered.)

    WARNING: this can still invoke arbitrary C code, if an object
    with a __getattr__ hook is evaluated.

    """
    import re
    m = re.match(r"([\w\[\]]+(\.[\w\[\]]+)*)\.(\w*)", text)
    if not m:
        return []
    expr, attr = m.group(1, 3)
    try:
        thisobject = eval(expr, self.namespace)
    except Exception:
        return []

    # get the content of the object, except __builtins__
    words = dir(thisobject)
    if "__builtins__" in words:
        words.remove("__builtins__")

    if hasattr(thisobject, '__class__'):
        words.append('__class__')
        words.extend(rlcompleter.get_class_members(thisobject.__class__))
    matches = []
    n = len(attr)
    for word in sorted(set(words), cmp=undercmp):
        if word[:n] == attr and hasattr(thisobject, word):
            val = getattr(thisobject, word)
            word = self._callable_postfix(val, "%s.%s" % (expr, word))
            matches.append(word)
    return matches

import readline
import rlcompleter
Completer = rlcompleter.Completer
Completer.attr_matches = attr_matches
readline.set_completer(Completer().complete)

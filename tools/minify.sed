#!/bin/sed -Ef
1a#!/bin/sed -Ef

1,${H;$!d;}
x

s/^\s*//mg
s/^#.*$//mg

:a
s/\n\n/\n/mg
ta
s/\n//m

s/\n\}$/}/mg
s/\{\n/{/mg

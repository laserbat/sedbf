#!/bin/bash
# 400 character quine from http://www.hevanet.com/cristofd/brainfuck/

cd "$(dirname "$0")"

cat ./400quine.b | ../tools/strip.sh  | ../sedbf.sed | ../tools/bytes_to_ascii.py

echo

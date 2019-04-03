#!/bin/bash
# Example using some deeply nested code
# Taken from http://www.hevanet.com/cristofd/brainfuck/

cd "$(dirname "$0")"

input="Hello, world!"

input="$(../tools/ascii_to_bytes.py <<< "$input")"

( cat ./rot13.b; echo "!$input") | ../tools/strip.sh | ../sedbf.sed | ../tools/bytes_to_ascii.py

echo

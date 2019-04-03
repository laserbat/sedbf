#!/bin/bash
tr '\n' ' ' |  sed -E "s/[^][+,.<>!0-9-]//g"

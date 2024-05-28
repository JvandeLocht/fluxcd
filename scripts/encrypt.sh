#!/bin/sh

grep --recursive --files-without-match -e "AGE" secrets | xargs -n 1 sops --encrypt --in-place

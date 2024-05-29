#!/bin/sh

grep --recursive --files-without-match -e "AGE" secrets | xargs -n 1 -r /bin/sh -c 'echo encrypting: "$@"; sops --encrypt --in-place "$@"; echo encrypted. Now staging: "$@"; git add "$@";' ''

#!/bin/sh

# grep --recursive --files-without-match -e "AGE" secrets | xargs -n 1 sops --encrypt --in-place
grep --recursive --files-without-match -e "AGE" secrets | xargs -n 1 /bin/sh -c 'sops --encrypt --in-place "$@"; git add "$@";' ''

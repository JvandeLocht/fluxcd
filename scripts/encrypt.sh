#!/bin/sh

grep -rL "BEGIN AGE ENCRYPTED FILE" . | xargs grep -l "apiVersion: v1" | xargs grep -l "kind: Secret" | xargs -n 1 -r /bin/sh -c 'echo encrypting: "$@"; sops --encrypt --in-place "$@"; echo encrypted. Now staging: "$@"; git add "$@";' ''

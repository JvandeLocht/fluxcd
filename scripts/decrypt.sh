#!/bin/sh

read -e -p "Enter file or filepath to the file you want to decrypt: " FILE

sops --decrypt --encrypted-regex '^(data|stringData)$' --in-place "$FILE"

echo "File $FILE is decrypted"


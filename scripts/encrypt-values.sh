#!/bin/sh

# Script to encrypt values.yaml using sops

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo "Error: sops command not found. Please install sops first."
    exit 1
fi

# Check if the input file exists
if [ ! -f "values.yaml" ]; then
    echo "Error: values.yaml file not found in the current directory."
    exit 1
fi

# Encrypt the file
echo "Encrypting values.yaml..."
sops -e --input-type=yaml --output-type=yaml values.yaml > values.enc.yaml

# Check if encryption was successful
if [ $? -eq 0 ]; then
    echo "Encryption successful! Output saved to values.enc.yaml"
else
    echo "Encryption failed."
    exit 1
fi

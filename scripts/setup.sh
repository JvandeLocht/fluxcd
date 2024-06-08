#!/bin/sh

kubectl create namespace flux-system

cat ~/.config/sops/age/keys.txt | kubectl create secret generic sops-age \
        --namespace=flux-system \
        --from-file=age.agekey=/dev/stdin

flux bootstrap github \
        --owner=$GITHUB_USER \
        --repository=fluxcd \
        --branch=main \
        --path=./clusters/production \
        --personal

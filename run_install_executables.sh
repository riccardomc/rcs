#!/usr/bin/env bash

DESTINATION_DIRECTORY=~/.bin

AWS_CLI_VERSION=1.18.65

# Install awscli
if ! [ -x "$(command -v aws)" ] ; then
    curl -Lo "awscli-bundle.zip" "https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip"
    unzip awscli-bundle.zip
    ./awscli-bundle/install -i $DESTINATION_DIRECTORY
    rm -f awscli-bundle.zip
fi    

if ! [ -x "$(command -v arkade)" ] ; then
    curl -sLS https://get.arkade.dev | sh
fi

for executable in \
    kubectl \
    kustomize \
    istioctl \
    terraform \
    argocd \
    krew \
    pack \
    ; do
    if ! [ -x "$(command -v $executable)" ] ; then
            arkade get $executable
    fi
done

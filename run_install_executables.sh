#!/usr/bin/env bash

DESTINATION_DIRECTORY=~/.bin

AWS_CLI_VERSION=1.18.65

# Install awscli
if ! [ -x "$(command -v aws)" ] ; then
    if uname | grep -q Darwin ; then
        # we're on MacOS
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"
        sudo installer -pkg /tmp/AWSCLIV2.pkg -target /
        rm /tmp/AWSCLIV2.pkg
    else
        # we're on Linux
        curl -Lo "awscli-bundle.zip" "https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip"
        unzip awscli-bundle.zip
        ./awscli-bundle/install -i $DESTINATION_DIRECTORY
        rm -f awscli-bundle.zip
    fi
fi    

if ! [ -x "$(command -v arkade)" ] ; then
    curl -sLS https://get.arkade.dev | sh
    cp $HOME/arkade $DESTINATION_DIRECTORY
fi

for executable in \
    kubectl \
    kustomize \
    helm \
    istioctl \
    terraform \
    argocd \
    krew \
    pack \
    ; do
    if ! [ -x "$(command -v $executable)" ] ; then
            arkade get --os darwin --arch arm64 $executable
    fi
done

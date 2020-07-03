#!/usr/bin/env bash

DESTINATION_DIRECTORY=~/.bin

ISTIO_VERSION=1.6.0
AWS_CLI_VERSION=1.18.65
AWS_IAM_AUTHENTICATOR_VERSION=0.5.0
KUBECTL_VERSION=v1.18.3
KUSTOMIZE_VERSION=v3.6.1
TERRAFORM_VERSION=0.12.25
KREW_VERSION=v0.3.4
ARGOCD_VERSION=v1.6.1

# Install awscli
if ! [ -x "$(command -v aws)" ] ; then
    curl -Lo "awscli-bundle.zip" "https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip"
    unzip awscli-bundle.zip
    ./awscli-bundle/install -i $DESTINATION_DIRECTORY
    rm -f awscli-bundle.zip
fi    

# Install aws-iam-authenticator
if ! [ -x "$(command -v aws-iam-authenticator)" ] ; then
    curl -Lo $DESTINATION_DIRECTORY/aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64
    chmod +x $DESTINATION_DIRECTORY/aws-iam-authenticator
fi

# Install kubectl
if ! [ -x "$(command -v kubectl)" ] ; then
    curl -Lo $DESTINATION_DIRECTORY/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
    chmod +x $DESTINATION_DIRECTORY/kubectl
fi

# Install kustomize
if ! [ -x "$(command -v kustomize)" ] ; then
    curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
    tar -xf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
    mv kustomize $DESTINATION_DIRECTORY/kustomize
    rm -f kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
fi    

# Install istioctl
if ! [ -x "$(command -v istioctl)" ] ; then
    curl -Lo istio.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz
    tar xvzf istio.tar.gz
    chmod +x istioctl
    mv istioctl $DESTINATION_DIRECTORY
    rm -f istio.tar.gz
fi

# Install terraform
if ! [ -x "$(command -v terraform)" ] ; then
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d $DESTINATION_DIRECTORY
    chmod +x $DESTINATION_DIRECTORY/terraform
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
fi

# Install argocd
if ! [ -x "$(command -v argocd)" ] ; then
    echo "Installing argocd $ARGOCD_VERSION"
    curl -sSL \
        -o "$DESTINATION_DIRECTORY/argocd" \
        "https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64"
    chmod +x $DESTINATION_DIRECTORY/argocd
fi


# Install krew
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
if ! kubectl krew; then
    (
      set -x; cd "$(mktemp -d)" &&
          curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/${KREW_VERSION}/download/krew.{tar.gz,yaml}" &&
      tar zxvf krew.tar.gz &&
      KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
      "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
      "$KREW" update
    )
fi

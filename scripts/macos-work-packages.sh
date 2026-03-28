#!/bin/bash
set -euo pipefail

echo "==> Installing work packages via Homebrew ..."

brew install \
    awscli \
    aws-sso-util \
    k9s \
    yq \
    act \
    kubectl \
    terraform \
    helm \
    pipx \
    tflint

echo "==> Work packages installed"

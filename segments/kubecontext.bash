#!/usr/bin/env bash
#
#  Kubernetes (kubectl)
#
# Kubernetes is an open-source system for deployment, scaling,
# and management of containerized applications.
# Link: https://kubernetes.io/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

GAUDI_KUBECONTEXT_SHOW="${GAUDI_KUBECONTEXT_SHOW=true}"
GAUDI_KUBECONTEXT_PREFIX="${GAUDI_KUBECONTEXT_PREFIX="$GAUDI_PROMPT_DEFAULT_PREFIX"}"
GAUDI_KUBECONTEXT_SUFFIX="${GAUDI_KUBECONTEXT_SUFFIX="$GAUDI_PROMPT_DEFAULT_SUFFIX"}"
GAUDI_KUBECONTEXT_SYMBOL="${GAUDI_KUBECONTEXT_SYMBOL="\\ue773"}"
GAUDI_KUBECONTEXT_COLOR="${GAUDI_KUBECONTEXT_COLOR="$GAUDI_MAGENTA"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show current context in kubectl
gaudi_kubecontext () {
  [[ $GAUDI_KUBECONTEXT_SHOW == false ]] && return

  gaudi::exists kubectl || return

  local kube_context kube_namespace kubectl_version

  kube_context=$(kubectl config current-context 2>/dev/null)
  kube_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  kubectl_version=$(kubectl version --short 2>/dev/null | grep "Server Version" | sed 's/Server Version: \(.*\)/\1/')

  [[ -n $kube_namespace && "$kube_namespace" != "default" ]] && kube_context="$kube_context ($kube_namespace)"

  if [[ -z $kube_namespace ]]; then
    kube_namespace="default"
  fi

  [[ -z $kubectl_version && -z $kubectl_context ]] && return

  gaudi::section \
    "$GAUDI_KUBECONTEXT_COLOR" \
    "$GAUDI_KUBECONTEXT_PREFIX" \
    "$GAUDI_KUBECONTEXT_SYMBOL" \
    "$kubectl_version | $kube_context | $kube_namespace" \
    "$GAUDI_KUBECONTEXT_SUFFIX"
}

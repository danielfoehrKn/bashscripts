#!/usr/bin/env bash

TMP_CONFIGS_DIR=$HOME/.kube/switch/.tmp/

# copy kubeconfig to temp dir under ~/.kube-secrets/.tmp
savek () {
  if [[ -n "$1" ]]; then TMP_CONFIGS_DIR=$1; fi

  local TMPKC="$(mktemp -p ${TMP_CONFIGS_DIR} kube_tmp_$$_XXXXX)"

  if [ -p /dev/stdin ]; then
    cat > $TMPKC
  else
    pbpaste > $TMPKC
  fi

  # test if valid kubeconfig
  if ! KUBECONFIG=$TMPKC kubectl config current-context > /dev/null ; then
    rm $TMPKC
    return 1
  fi
  echo "wrote config to $TMPKC"
}

save () {
  # test if valid kubeconfig
  if ! kubectl config current-context > /dev/null ; then
    echo "current kubeconfig is invalid"
    return 1
  fi

  # let user pick folder
    echo "$HOME/.kube-secrets directory: "
    ls $HOME/.kube-secrets
    echo "Specify folder starting from "$HOME/.kube-secrets/", followed by [ENTER]:"

    read dir

    newLocation=$HOME/.kube-secrets/${dir}

  # mkdir folder
    mkdir -p ${newLocation}

  # copy file to that location
   cp $KUBECONFIG ${newLocation}/config

  # set env variable to point there
    oldLocation=${KUBECONFIG}
    export KUBECONFIG=${newLocation}/config

  if ! kubectl config current-context > /dev/null ; then
    echo "kubeconfig could not be saved"
    export KUBECONFIG=${oldLocation}
    return 1
  fi

  echo "wrote config to ${newLocation}/config"
}
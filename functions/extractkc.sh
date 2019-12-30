#!/usr/bin/env bash

extractkc () {
  # get secret and convert to pure json
  if [ -p /dev/stdin ]; then
    cat | yaml2json | jq -r '.data.kubeconfig' | base64 -d
  else
    pbpaste | yaml2json | jq -r '.data.kubeconfig' | base64 -d
  fi
}
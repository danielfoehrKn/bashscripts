#!/usr/bin/env bash

kbase64() {
 if [ -p /dev/stdin ]; then
    cat | yaml2json | jq -r '.data.kubeconfig' | base64 -d
  else
    pbpaste | yaml2json | jq -r '.data.kubeconfig' | base64 -d
  fi
}
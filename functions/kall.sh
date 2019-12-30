#!/usr/bin/env bash

kall() {
  if [[ -z "$1" ]]; then
      echo "need to supply namespace"
      return
  fi

  for i in $(kubectl --insecure-skip-tls-verify=true api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl --insecure-skip-tls-verify=true -n ${1} get --ignore-not-found ${i}
  done
}
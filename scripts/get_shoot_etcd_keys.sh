#!/bin/bash

 get_shoot_etcd_keys(){
  if [[ -z "$1" ]]; then
      echo "need to supply namespace"
      return
  fi

  namespace=$1
  kubectl get secret ca-etcd  -o json | jq -r .data.\"ca.crt\" | base64 -d > ca.crt
  kubectl get secret etcd-client-tls -o json | jq -r .data.\"tls.crt\" | base64 -d > client_tls.crt
  kubectl get secret etcd-client-tls -o json | jq -r .data.\"tls.key\" | base64 -d > client_tls.key

  echo "Execute: 'k -n $namespace port-forward  etcd-main-0 2379:2379'"
  echo "Then use: 'etcdctl --cacert=ca.crt --cert=tls.crt --key=tls.key --insecure-skip-tls-verify=true get "" --prefix=true'"
}

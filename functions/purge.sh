#!/usr/bin/env bash

purge() {
    if [[ -z "$1" ]]; then
      echo "need to supply shoot name in ns garden-dev"
     fi

    k -n garden-dev annotate shoot "$1" confirmation.garden.sapcloud.io/deletion=true --overwrite
    k -n garden-dev delete shoot "$1"
}
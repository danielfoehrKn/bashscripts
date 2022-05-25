#!/bin/bash

setupLocalVault () {
if [[ -z "$1" ]]; then
    echo "need to supply vault token"
    return
fi


export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="$1"

vault secrets enable -path=landscapes kv
}
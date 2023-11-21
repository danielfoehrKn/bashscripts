#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
for ctx in $(kubectl config view --output json | jq -rc '.contexts[] | .name'); do
  echo --- context $ctx ---
  while IFS= read -r s ; do
    ns=$(echo "$s" | awk '{print $1}')
    name=$(echo "$s" | awk '{print $2}')
    state=$(echo "$s" | awk '{print $3}')

    if [[ $state != "Error" ]]; then
      continue
    fi

    shoot_name=$(echo $ns | awk -F -- '{print $3}')
    project_name=garden-$(echo $ns | awk -F -- '{print $2}')

    kubectl --kubeconfig "$KUBECONFIG" --context "canary-virtual-garden" -n $project_name annotate shoot $shoot_name gardener.cloud/operation=retry --overwrite

    sleep 0.5

    kubectl --kubeconfig "$KUBECONFIG" --context $ctx -n $ns annotate dnsrecord $name gardener.cloud/operation=reconcile --overwrite

  done < <(kubectl --kubeconfig "$KUBECONFIG" --context $ctx get dnsrecords -A -ocustom-columns=namespace:metadata.namespace,name:metadata.name,status:status.lastOperation.state --no-headers)
done

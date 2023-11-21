function debugpod() {
  if [[ -z "$1" ]]; then
    echo "You need to provide the nodename as a first argument"
    exit 0
  fi

  tolerations_array=$(kubectl get nodes "$1" -o jsonpath='{range .spec.taints[*]}  - effect: "{@.effect}"{"\n"}    key: "{@.key}"{"\n"}    value: "{@.value}"{"\n"}    operator: "{@.operator}"{"\n"}{end}')
  echo "tolerations: $tolerations_array"

  tmpfile=$(mktemp /tmp/debugpod."$1".XXXXXX)
  cat /Users/d060239/go/src/github.com/danielfoehrkn/better-resource-reservations/hack/debug-pod.yaml > "$tmpfile"

  # make the debugpod name uniqueu by setting the last five characters as suffix
  echo "Created in $tmpfile"
  sed -i "s|<replace>|$1|g" "$tmpfile"
  sed -i "s|<tolerations_array>|$tolerations_array|g" "$tmpfile"
  cat "$tmpfile" | yaml2json | jq --arg NODE_NAME "$1" '.spec.nodeName=$NODE_NAME' | k apply -f -

  rm "$tmpfile"
}
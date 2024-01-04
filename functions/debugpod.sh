function debugpod() {
  if [[ -z "$1" ]]; then
    echo "You need to provide the nodename as a first argument"
    exit 0
  fi

  tolerations_array=$(kubectl get nodes "$1" -o jsonpath='{range .spec.taints[*]}  - effect: "{@.effect}"{"\n"}    key: "{@.key}"{"\n"}    value: "{@.value}"{"\n"}    operator: "{@.operator}"{"\n"}{end}')

  tmpfile=$(mktemp /tmp/debugpod."$1".XXXXXX)
  cat /Users/D060239/go/src/github.com/danielfoehrkn/reserved-resources-recommender/hack/debug-pod.yaml > "$tmpfile"

  # make the debugpod name unique by setting the last five characters as suffix
  echo "Created in $tmpfile"

  sed -i "s|<replace>|$1|g" "$tmpfile"

  echo "replaced <replace> with $1"
  cat "$tmpfile"
  echo "tolerations array: $tolerations_array" 

  k apply -f "$tmpfile"

  # TODO: fix tolerations later - below command hangs for empty array
  # tolerations_json=$(yaml2json $tolerations_array)

  #echo "tolerations: $tolerations_json"
  #sed -i "s|<tolerations_array>|$tolerations_array|g" "$tmpfile"
  #cat "$tmpfile" | yaml2json | jq --arg TOLERATIONS "$tolerations_array" '.spec.tolerations += [$TOLERATIONS]' | k apply -f -

  #rm "$tmpfile"
}

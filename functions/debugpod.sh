function debugpod() {
  if [[ -z "$1" ]]; then
    echo "You need to provide the nodename as a first argument"
    exit 0
  fi

  cat /Users/d060239/go/src/github.com/danielfoehrkn/better-resource-reservations/hack/debug-pod.yaml | yaml2json | jq --arg NODE_NAME "$1" '.spec.nodeName=$NODE_NAME' | k apply -f -

}
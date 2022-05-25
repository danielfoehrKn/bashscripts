# open the dashboard for any Shoot whose kubeconfig has been switched to by kubeswitch
function dashboard() {
  if [[ -z "${KUBECONFIG}" ]]; then
    echo "Kubeconfig environment variable is not set"
    exit 0
  fi

  identity=$(cat $KUBECONFIG | grep gardener-landscape-identity | awk '{ print $2 }')
  type=$(cat $KUBECONFIG | grep gardener-cluster-type | awk '{ print $2 }')
  project=$(cat $KUBECONFIG | grep gardener-project | awk '{ print $2 }')
  name=$(cat $KUBECONFIG | grep gardener-cluster-name | awk '{ print $2 }')

  # https://dashboard.garden.dev.k8s.ondemand.com/namespace/garden-core/shoots/d060239-reserved/
  # https://dashboard.garden.canary.k8s.ondemand.com/namespace/garden/shoots/
  baseUrl=""
  if [[ "$identity" == "sap-landscape-dev" ]]; then
    baseUrl="https://dashboard.garden.dev.k8s.ondemand.com/namespace"
  fi
  if [[ "$identity" == "sap-landscape-live" ]]; then
    baseUrl="https://dashboard.garden.live.k8s.ondemand.com/namespace"
  fi
  if [[ "$identity" == "sap-landscape-canary" ]]; then
    baseUrl="https://dashboard.garden.canary.k8s.ondemand.com/namespace"
  fi
  if [[ "$identity" == "sap-landscape-staging" ]]; then
    baseUrl="https://dashboard.garden.staging.k8s.ondemand.com/namespace"
  fi

  ns="$project"
  if [[ "$project" != "garden" ]]; then
    ns="garden-$ns"
  fi

  url="$baseUrl/$ns/shoots/$name"
  open -a "Google Chrome" "$url" --args '--new-window'
}
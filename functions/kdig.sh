#!/usr/local/bin bash

tmpDIRDig="$HOME/.kube/switch/.dig"
tmpDIR="$HOME/.kube/switch/.tmp"

kdig(){
   mkdir -p ${tmpDIR}
   mkdir -p ${tmpDIRDig}

   foundShoot=false
   for namespace in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
        if [[ $namespace == "shoot--"* ]]; then
          echo "found shoot ns $namespace"

          if ! kubectl get secret -n "$namespace" kubecfg -o yaml > /dev/null ; then
            continue
          fi
          foundShoot=true
           # saving the kubeconfig to a temp directory only for this cluster
          kubectl get secret -n "$namespace" kubecfg -o yaml | extractkc | savek ${tmpDIRDig}
        fi
    done

    if [ "$foundShoot" = false ] ; then
        echo 'No Shoot found in cluster'
        return
    fi

    # copy just created tmp kubeconfigs to general tmp folder to make available with normal mashtmp
    cp -r ${tmpDIRDig}/* "$HOME/.kube/switch/.tmp"

    # only show shoots found in this cluster
    switchdig
}
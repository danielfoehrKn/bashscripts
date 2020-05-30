#!/usr/bin/env bash

goExecuter='go/src/github.com/danielfoehrkn/bashscripts/util/kubectlSwitch'
switchtmp(){
    # construct list of arguments to pass to golang binary (where the real work happens)
    configPaths=""

    chmod +x $HOME/${goExecuter}

    IFS=$'\n'; set -f
    for f in $(find $HOME/.kube/switch/.tmp/ -name '*kube_tmp*'); do
        configPaths+="$f "
    done

    unset IFS; set +f

    # execute golang binary handing over all the filepaths to the kubeconfigs as arguments
    NEW_KUBECONFIG=$($HOME/"$goExecuter" $configPaths)
    if [[ "$?" = "0" ]]; then
        export KUBECONFIG=${NEW_KUBECONFIG}
        currentContext=$(kubectl config current-context)
	    echo "switched to context $currentContext"
    else
	    exit 1
    fi
}
#!/usr/bin/env bash

goExecuter='go/src/github.com/danielfoehrkn/bashscripts/util/kubectlSwitch'
switch(){
    # construct list of arguments to pass to golang binary (where the real work happens)
    configPaths=""

    chmod +x $HOME/${goExecuter}

    IFS=$'\n'; set -f
    # directory where I store my kubeconfigs
    for f in $(find $HOME/.kube-secrets/ -name '*config*'); do
        configPaths+="$f "
    done

    # additonal directory for gardener
    for f in $(find $HOME/go/src/github.com/gardener/gardener/dev -name 'config'); do
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

switchdig(){
    # construct list of arguments to pass to golang binary (where the real work happens)
    configPaths=""

    chmod +x $HOME/${goExecuter}

    IFS=$'\n'; set -f
    for f in $(find $HOME/.kube-secrets/.dig/ -name '*kube_tmp*'); do
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

switchtmp(){
    # construct list of arguments to pass to golang binary (where the real work happens)
    configPaths=""

    chmod +x $HOME/${goExecuter}

    IFS=$'\n'; set -f
    for f in $(find $HOME/.kube-secrets/.tmp/ -name '*kube_tmp*'); do
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
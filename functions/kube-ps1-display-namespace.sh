function get_namespace_kubeps1() {
    # only display the last namespace
    # Reason: kube-ps1 returns the namespace in the exec-plugin as first namespace (bug)
    echo $1 | cut -d' ' -f2
    echo  " "
}
export KUBE_PS1_SUFFIX=""
export KUBE_PS1_PREFIX=""
export KUBE_PS1_SYMBOL_DEFAULT="🤼"
export KUBE_PS1_NS_COLOR=green
export KUBE_PS1_SYMBOL_ENABLE=true
export KUBE_PS1_NAMESPACE_FUNCTION=get_namespace_kubeps1
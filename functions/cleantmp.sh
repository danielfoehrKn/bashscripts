#!/usr/bin/env bash

cleantmp(){
# >/dev/null 2>/dev/null
    (/bin/rm -rf $HOME/.kube/switch/.tmp/*)
    (/bin/rm -rf $HOME/.kube/switch/.dig/*)
}
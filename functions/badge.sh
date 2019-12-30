#!/usr/bin/env bash
badge () {
    local name=${1:-}
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$name" | base64)
}
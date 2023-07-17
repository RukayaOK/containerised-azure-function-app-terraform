#!/bin/bash

# Helpers
wipe="\033[1m\033[0m"

_information() {
    _color='\033[0;35m' #cyan
    echo "${_color} $1 ${wipe}"
}

_success() {
    _color='\033[0;32m' #green
    echo "${_color} $1 ${wipe}"
}
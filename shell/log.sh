#!/bin/bash
source colors.sh

log(){
    if [ "$2" == "msg" ]; then
        echo -e "${INFO}$1${NO}"
    elif [ "$2" == "ok" ]; then
        echo -e "${OK}$1${NO}"
    elif [ "$2" == "error" ]; then
        echo -e "${ERROR}$1${NO}"
    elif [ "$2" == "warn" ]; then
        echo -e "${WARN}$1${NO}"
    else
        echo -e "${FUN}$1${NO}"
    fi
}

#!/usr/bin/env bash

usage() {
    cat << NOTICE
    OPTIONS
    -h  show this message
    -v  print verbose info
    -p  install programs (apt)
    -i  install dotfiles
    -t  install theme
NOTICE
}

say() {
    [ "$VERBOSE" ] || [ "$2" ] && echo "==> $1"
}

PROJ_DIR=$(cd $(dirname "${0}") && pwd)

VERBOSE=""
INSTALL=""
INSTALL_THEME=""
INSTALL_PROGRAMS=""

while getopts hvpit opts; do
    case ${opts} in
        h) usage && exit 0 ;;
        v) VERBOSE=1 ;;
        i) INSTALL=1 ;;
        p) INSTALL_PROGRAMS=1 ;;
        t) INSTALL_THEME=1 ;;
        *) ;;
    esac
done

if [ "$INSTALL_PROGRAMS" ]; then
    say "programs"
fi

if [ "$INSTALL" ]; then
    say "dotfiles"
fi

if [ "$INSTALL_THEME" ]; then
    say "themes"
fi

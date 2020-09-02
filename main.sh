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

if [ -z "${HOME:-}" ]; then
    HOME="$(cd ~ && pwd)"
fi

PROJ_DIR=$(cd $(dirname "${0}") && pwd)

FILES=(
    "gitconfig"
    "terminator"
    "vimrc"
    "zshrc"
)

PATHS=(
    "${HOME}/.gitconfig"
    "${HOME}/.config/terminator/config"
    "${HOME}/.vimrc"
    "${HOME}/.zshrc"
)

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
    say "installing apt programs"
    sudo apt install curl git zsh vim zsh-syntax-highlighting terminator \
        gnome-shell-extensions gnome-tweak-tool chrome-gnome-shell

    say "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    say "installing vim-plug"
    curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    say "installing powerlevel9k"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k > /dev/null 2>&1

    say "downloading hack font"
    curl -sfLo /tmp/hackfont/hack.zip --create-dirs \
         https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip

    say "installing hack font"
    unzip /tmp/hackfont/hack.zip -d /tmp/hackfont/
    mkdir -p ~/.local/share/fonts/
    cp /tmp/hackfont/ttf/*.ttf ~/.local/share/fonts/
    rm -r /tmp/hackfont

    say "clearing font cache"
    fc-cache -f -v > /dev/null 2>&1
fi

if [ "$INSTALL" ]; then
    for INDEX in "${!FILES[@]}"; do
        if [ ! -d "$(dirname "${PATHS[$INDEX]}")" ]; then
            mkdir -p "$(dirname "${PATHS[$INDEX]}")"
        fi
        if [ -f "${PATHS[$INDEX]}" ]; then
            mv "${PATHS[$INDEX]}" "${PATHS[$INDEX]}.backup"
        fi
        ln -s "${PATHS[$INDEX]}" "${PROJ_DIR}/files/${FILES[$INDEX]}"
    done
fi

if [ "$INSTALL_THEME" ]; then
    git clone https://github.com/jaxwilko/gtk-theme-framework.git ~/.misc/gtk-theme-framework
    ~/.misc/gtk-theme-framework/main.sh -ios
fi

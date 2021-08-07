#!/usr/bin/env bash

note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        printf "%s" > "$HOME/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}

is_x_session () {
    [[ $(xhost >& /dev/null) ]] && return 0 || return 1
}

#aur () {
    ## download package ($1) from aur
    #package=${1}
    #directory=${2:-/tmp}
    #git clone https://aur.archlinux.org/${package}.git ${directory}/${package}
#}

aur () {
    # Download and upgrade given AUR package (yay AUR helper by default)
    package_name=${1:-yay}
    download_path=/tmp/${package_name}

    # Ensure the base-devel package group is instulled
    missing_dependencies=$(pacman --deptest $(pacman -Sgq base-devel))
    [[ ! -z $missing_dependencies ]] && 
        { sudo pacman --noconfirm -S $missing_dependencies; }

    # Acquire build files
    [[ -d ${download_path} ]] && sudo rm -r ${download_path}
    git clone https://aur.archlinux.org/${package_name}.git ${download_path}

    # Build the package
    echo "starting package building..."
    (cd ${download_path} && makepkg PKGBUILD)

    # Install the package
    sudo pacman -U $(find ${download_path} -name "${package_name}*.pkg*")
}

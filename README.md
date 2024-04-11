
# Installation

1. Install pre-requirements:

`pacman -S git stow make`

2. Clone this repository and cd into it.


# Commands

- `*-dotfiles` commands work with configurations

- `install-*` commands upgrade the system
    * `aura` pacman wrapper is required to install AUR packages

- `save-packages-list` saves current packages for later installation


# Misc

## bin

Runnable scripts are stored in `binary files` folder


## Crontab

Run `crontab ./crontab` to replace your current crontab with ./crontab contents, or use `crontab -e` to alter your crontab manually.


## Next steps

1. enable daemonized services
2. edit system-level config files


# TODO

1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. .stowrc for packages

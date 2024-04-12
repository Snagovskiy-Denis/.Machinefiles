
# Installation

1. Install pre-requirements:

`pacman -S git stow make`

2. Clone this repository and cd into it.

3. Run `make help` to get commands explanations


# Misc

## Crontab

Run `crontab ./crontab` to replace your current crontab with ./crontab contents, or use `crontab -e` to alter your crontab manually.


## bin

Runnable scripts are stored in `binary files` directory.


## Next steps

1. setup cronie and enable its service
2. edit system-level config files on demand
3. enable synchronization of passwords, tasks, music, etc. using syncthing


# TODO

1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. .stowrc for packages

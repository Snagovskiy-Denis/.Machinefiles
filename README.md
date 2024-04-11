## Installing

1. Pre-requirements (*run as root*)

`pacman -S git stow`

2. Clone repository and cd into it

3. Optional dry run 

`stow */ --target=$HOME --simulate --verbose=1`

4. Installation itself

All packages: `stow */ --target=$HOME`

Only one package: `stow nvim --target=$HOME`


## Programs

Create\update .paclist file:

`pacman -Qeq > ./programs/.config/.pacman.list`

Native:
`comm -23 <(pacman -Qqen | sort) <(pacman -Qmq | sort) > ./programs/.config/.pacman-native.list`

Foreign (AUR):
`pacman -Qmeq > ./programs/.config/.pacman-aur.list`

Install packages from .paclist file *as root*:

`pacman -S - < ./programs/.config/.pacman.list`

It might be better to use AUR helper (such as aura) for synchronization

After fresh installation, you may need to enable some of the daemonized services.


## bin

Runnable scripts are stored in `binary files` folder


## Crontab

Run `crontab ./crontab` to replace your current crontab with ./crontab contents, or use `crontab -e` to alter your crontab manually.


## TODO

1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. .stowrc for packages

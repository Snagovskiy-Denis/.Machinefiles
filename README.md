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

Create\update .pacman.list file:

`pacman -Qeq > .pacman.list`


Install .pacman.list file *as root*:

`pacman -S - < .pacman.list`

It might be better to use AUR helper (such as aura) for synchronization


## bin

Runnable scripts are stored in `binary files` folder


## TODO

1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. Automate installation
3. Cat config paths for dmconf (e.g. take target from step 1 and then add rest of a path)
4. Ranger marks paths

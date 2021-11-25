## Installing
1. `# pacman -S git stow`
2. `$ git clone git@github.com:Di0nisBloody/.Machinefiles.git`
3. Optional dry run: `$ stow */ --target=$HOME --simulate --verbose=1`
4. all: `$ stow */ --target=$HOME`; only one:`$ stow nvim --target=$HOME`


## Programs
Create\update .pacman.list file:
`$ pacman -Qeq > .pacman.list`

Install .pacman.list file:
`# pacman -S - < .pacman.list`

It might be better to use aur helper (like aura) for synchronization


## Keymap

File on path `/etc/vconsole.conf` should contain this string: `KEYMAP=<path to personal.map>`


## bin

Scripts are in `binary files` folder


## TODO
1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. Automate installation
3. Cat config paths for dmconf (e.g. take target from step 1 and then add rest of a path)
4. Ranger marks paths

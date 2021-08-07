## Installing
1. `# pacman -S git stow`
2. `$ git clone git@github.com:Di0nisBloody/Machinefiles.git`
3. Optional dry run: `$ stow */ --target=$HOME --simulate --verbose=1`
4. `$ stow */ --target=$HOME` or `$ stow nvim --target=$HOME`

## Programs
Create\update .pacman.list file:
`$ pacman -Qeq > .pacman.list`

Install .pacman.list file:
`# pacman -S - < .pacman.list`

It might be better to use yay for synchronize because of aur

## Keymap
File on path `/etc/vconsole.conf` should contain this string: `KEYMAP=<path to personal.map>`

## Temp
dmconf & dmprompt are not configs but still here for a while

## TODO
1. Add stow targets for each directory individually (add --ignore option or create .stow-local-ignore)
2. Automate installation
3. Cat config paths for dmconf (e.g. take target from step 1 and then add rest of a path)
4. Ranger marks paths

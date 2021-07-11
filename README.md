## Installing
1. `# pacman -S git stow`
2. `$ git clone git@github.com:Di0nisBloody/Machinefiles.git`
3. Optional dry run: `$ stow */ --target=$HOME --simulate --verbosity=2`
4. `$ stow */ --target=$HOME` or `$ stow nvim --target=$HOME`

## Programs
Create\update .pacman.list file:
`$ pacman -Qeq > .pacman.list`

Install .pacman.list file:
`# pacman -S - < .pacman.list`

It might be better to use yay for synchronize because of aur

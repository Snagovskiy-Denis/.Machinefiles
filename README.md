## Installing
1. `$ pacman -S git stow`
2. `$ cd ~; git clone git@github.com:Di0nisBloody/Machinefiles.git`
3. Optionally: `$ stow */ --simulate --verbosity=2  # dry run`
4. `$ stow */` or `$ stow nvim`

## Programs
Create\update .pacman.list file:
`$ pacman -Qeq > .pacman.list`

Install .pacman.list file:
`$ pacman -S - < .pacman.list`

It might be better to use yay for synchronize because of aur

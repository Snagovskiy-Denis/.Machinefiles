.PHONY: check-dotfiles
check-dotfiles:  # dry run for install-dotfiles command
	stow */ --target="${HOME}" --simulate --verbose=1

.PHONY: install-dotfiles
install-dotfiles: check-dotfiles  # create symlinks for dotfiles
	stow */ --target="${HOME}"

.PHONY: save-packages-lists
save-packages-lists:  # save current packages for later installation
	comm -23 <(pacman -Qqen | sort) <(pacman -Qmq | sort) > ./programs/.config/.pacman-native.list
	pacman -Qmeq > ./programs/.config/.pacman-aur.list

.PHONY: install-native
install-native:  # install native packages
	pacman -S --noconfirm - < ./programs/.config/.pacman-native.list

.PHONY: install-foreign
install-foreign:  # install AUR packages using aura pacman wrapper
	aura -A --noconfirm $(cat ./programs/.config/.pacman-aur.list)

.PHONY: install-all
install-all: install-native install-foreign  # install both native and AUR packages

.PHONY: help
help: # show this help message
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

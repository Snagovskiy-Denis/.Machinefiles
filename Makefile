.PHONY: check-dotfiles
check-dotfiles:
	stow */ --target="${HOME}" --simulate --verbose=1

.PHONY: install-dotfiles
install-dotfiles: check-dotfiles
	stow */ --target="${HOME}"

.PHONY: save-packages-lists
save-packages-lists:
	echo saving native packages...
	comm -23 <(pacman -Qqen | sort) <(pacman -Qmq | sort) > ./programs/.config/.pacman-native.list
	echo saving foreign packages...
	pacman -Qmeq > ./programs/.config/.pacman-aur.list
	echo done

.PHONY: install-native
install-native:
	echo install native packages
	pacman -S --noconfirm - < ./programs/.config/.pacman-native.list

.PHONY: install-foreign
install-foreign:
	echo install AUR packages
	aura -A --noconfirm $(cat ./programs/.config/.pacman-aur.list)

.PHONY: install-all
install-all: install-native install-foreign

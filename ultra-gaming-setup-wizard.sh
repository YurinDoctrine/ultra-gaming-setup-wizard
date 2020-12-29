#!/bin/bash

which apt >/dev/null 2>&1
if [ $? -eq 0 ]; then
	clear
	echo -e "╔═══════════════════════════════════════════════════╗"
	echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
	echo -e "║                                                   ║"
	echo -e "╚═══════════════════════════════════════════════════╝"
fi
which pacman >/dev/null 2>&1
if [ $? -eq 0 ]; then
	clear
	echo -e "╔═══════════════════════════════════════════════════╗"
	echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
	echo -e "║                                                   ║"
	echo -e "╚═══════════════════════════════════════════════════╝"
elif [ $? -eq 1 ]; then
        clear
        echo -e "╔═══════════════════════════════════════════════════╗"
        echo -e "║THIS SCRIPT ONLY WORKS ON ARCH&UBUNTU BASED DISTROS║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 1
fi

32bit() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e 'Acquire::Languages "none";' | sudo tee -a /etc/apt/apt.conf.d/00aptitude
		sudo dpkg --add-architecture i386
		sudo apt update
		sudo apt install --install-recommends ubuntu-restricted-extras -y
		sudo apt install --install-recommends software-properties-common -y
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		_has_multilib=$(grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:)
		if [[ -z $_has_multilib ]]; then
			echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf
			echo -e 'Multilib repository successfully added into pacman.conf file\n'
		else
			sudo sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
			_has_multilib=$((${_has_multilib} + 1))
			sudo sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
		fi
	fi
}
32bit

amd() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:kisak/kisak-mesa -y
		sudo apt update
		sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
		echo -e 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm yay
		which yay >/dev/null 2>&1
		if [ $? != 0 ]; then
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si
			cd
		fi
		yay -S --needed --noconfirm lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader xf86-video-amdgpu vulkan-radeon
		echo -e 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment
		clear
	fi
}

nvidia() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:graphics-drivers/ppa -y
		sudo apt update
		sudo apt install nvidia-driver-450 libnvidia-gl-450 libnvidia-gl-450:i386 libvulkan1 libvulkan1:i386 -y
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm yay
		which yay >/dev/null 2>&1
		if [ $? != 0 ]; then
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si
			cd
		fi
		yay -S --needed --noconfirm nvidia opencl-nvidia lib32-opencl-nvidia lib32-nvidia-utils
		clear
	fi
}

prompt_0() {
	echo -e "CHOOSE WHAT COMPATIBLE WHICH IS IN BELOW WITH YOUR HARDWARE. (RETURN IS: NONE)"
	echo -e "1. : AMD"
	echo -e "2. : NVIDIA"
	read -p $'>_: ' noc
	if [[ "$noc" == "1" ]]; then
		amd
	fi
	if [[ "$noc" == "2" ]]; then
		nvidia
	fi
	if [[ "$noc" == "" ]]; then
		clear
	fi

}
prompt_0

xanmod() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e 'deb http://deb.xanmod.org releases main' | sudo tee -a /etc/apt/sources.list.d/xanmod-kernel.list &&
			wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
		sudo apt update &&
			sudo apt install --install-recommends linux-xanmod-rt -y
		echo -e 'net.core.default_qdisc = fq_pie' | sudo tee -a /etc/sysctl.d/90-override.conf
		clear
		echo -e '[r]EBOOT NOW OR [l]ATER?'
		read -p $'>_: 'nock

		if [[ "$nock" == "r" ]]; then
			sudo reboot
		fi
		clear

	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm linux-xanmod-rt linux-xanmod-headers
		echo -e 'net.core.default_qdisc = fq_pie' | sudo tee -a /etc/sysctl.d/90-override.conf
		clear
		echo -e '[r]EBOOT NOW OR [l]ATER?'
		read -p $'>_: 'nock

		if [[ "$nock" == "r" ]]; then
			sudo reboot
		fi
		clear
	fi
}

liquarix() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:damentz/liquorix &&
			sudo apt-get update
		sudo apt-get install --install-recommends linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -y
		clear
	fi
}

zen() {
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm linux-zen linux-zen-headers
		clear
	fi
}

linux-tkg() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		git clone https://github.com/Frogging-Family/linux-tkg.git
		cd linux-tkg/
		./install.sh install
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		git clone https://github.com/Frogging-Family/linux-tkg.git
		cd linux-tkg/
		makepkg -si
		clear
	fi
}

prompt_1() {
	echo -e "FIND IN BELOW CUSTOM KERNELS ACROSS OF THEM BENEFITS... (RETURN IS: NONE)"
	echo -e "1. : XANMOD(BOTH)"
	echo -e "2. : LIQUARIX(UBUNTUONLY)"
	echo -e "3. : ZEN(ARCHONLY)"
	echo -e "4. : LINUX-TKG(BOTH)"
	read -p $'>_: ' nockl
	if [[ "$nockl" == "1" ]]; then
		echo -e 'INSTALLING ...' &&
			clear
		xanmod
	fi
	if [[ "$nockl" == "2" ]]; then
		echo -e 'INSTALLING ...' &&
			clear
		liquarix
	fi
	if [[ "$nockl" == "3" ]]; then
		echo -e 'INSTALLING ...' &&
			clear
		zen
	fi
	if [[ "$nockl" == "4" ]]; then
		echo -e 'INSTALLING ...' &&
			clear
		linux-tkg
	fi
	if [[ "$nockl" == "" ]]; then
		clear
	fi

}
prompt_1

prompt_2() {
	echo -e "NOW YOU GOTTA INSTALL WINE EITHER. [RETURN]"
	read -p $'>_: '
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		wget -nc https://dl.winehq.org/wine-builds/winehq.key
		sudo apt-key add winehq.key
		sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y
		sudo add-apt-repository ppa:lutris-team/lutris -y
		sudo apt update
		sudo apt-get install --install-recommends winehq-staging -y
		sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y
		sudo apt-get install --install-recommends dxvk steam lutris -y
		sudo apt-get install --install-recommends build-essential manpages-dev libx11-dev ninja xorg-dev meson glslang systemd git dbus base-devel -y
		cd
		git clone https://github.com/DadSchoorse/vkBasalt.git
		cd vkBasalt/
		meson --buildtype=release --prefix=/usr builddir
		ninja -C builddir install
		cd
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader steam lutris
		yay -S --needed --noconfirm ninja meson glslang systemd git dbus base-devel dxvk-bin vkbasalt
	fi
}
prompt_2

prompt_3() {
	clear
	ulimit -Hn
	echo -e "IF THIS ABOVE RETURNS MORE THAN 500,000 THEN ESYNC IS ENABLED!"
	read -p $'true/false? >_: ' nocklb
	if [[ "$nocklb" == "false" ]]; then
		echo -e 'DefaultLimitNOFILE=524288' | sudo tee -a /etc/systemd/system.conf &&
			echo -e 'DefaultLimitNOFILE=524288' | sudo tee -a /etc/systemd/user.conf
		echo -e $USER 'hard nofile 524288' | sudo tee -a /etc/security/limits.conf
		sleep 1s
		echo -e "DONE."
		clear
	fi
	clear
}
prompt_3

utilities() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:linrunner/tlp
		sudo apt update
		sudo apt install gamemode -y
		sudo apt install earlyoom preload tlp tlp-rdw -y
		sudo tlp start
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm gamemode lib32-gamemode
		yay -S --needed --noconfirm earlyoom preload tlp tlp-rdw
		sudo tlp start
		clear
	fi
}

prompt_4() {
	echo -e "DO YOU ALSO WANT INSTALL UTILITY WARES? gamemode, earlyoom and tlp etc."
	read -p $'yes/no >_: ' nocklby
	if [[ "$nocklby" == "yes" ]]; then
		utilities
	fi
	clear

}
prompt_4

extra() {
	curl https://raw.githubusercontent.com/YurinDoctrine/secure-linux/master/secure.sh >secure.sh &&
		chmod 755 secure.sh &&
		./secure.sh

}

final() {
	echo -e "FINAL: DO YOU ALSO WANT TO RUN THE AUTHOR'S secure-linux?"
	read -p $'yes/no >_: ' nocklbye
	if [[ "$nocklbye" == "yes" ]]; then
		echo -e 'RUNNING ...\n'
		extra
	elif [[ "$nocklbye" == "no" ]]; then
		echo -e 'LEAVING ...\n'
		exit 1
	else
		echo -e 'INVALID VALUE!\n'
		final
	fi
}
final

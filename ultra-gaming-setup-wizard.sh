#!/bin/bash

clear
echo "╔═══════════════════════════════════════════════════╗"
echo "║This script only works on Arch&Ubuntu based distros║"
echo "║                                                   ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
read -p "To continue press [ENTER], ^C to Abort."

title_bar() {
	clear
	echo "╔═══════════════════════════════════════════════════╗"
	echo "║YURIN'S | ultimate-gaming-setup-wizard | Greetings!║"
	echo "╚═══════════════════════════════════════════════════╝"

}
title_bar

multiarch() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo dpkg --add-architecture i386
		sudo apt update
		sudo apt install ubuntu-restricted-extras -y
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		_has_multilib=$(grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:)
		if [[ -z $_has_multilib ]]; then
			echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf
			echo -e 'Multilib repository successfully added into pacman.conf file\n'
		else
			sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
			_has_multilib=$((${_has_multilib} + 1))
			sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
		fi
	fi
}
read -p "YOU'LL NEED TO BE ABLE SURE 32-BIT LIBRARIES ENABLED[ENTER], ^C to Abort: "

multiarch

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
		sudo pacman -S --needed yay -y
		sudo pacman -S lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader xf86-video-amdgpu vulkan-radeon -y
		echo -e 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment
		clear
	fi
}
nvidia() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo pacman -S --needed yay -y
		sudo add-apt-repository ppa:graphics-drivers/ppa -y
		sudo apt update
		sudo apt install nvidia-driver-450 libnvidia-gl-450 libnvidia-gl-450:i386 libvulkan1 libvulkan1:i386 -y
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo pacman -S nvidia opencl-nvidia lib32-opencl-nvidia lib32-nvidia-utils -y
		clear
	fi
}
prompt_0() {
	echo "Choose what compatible which is in below with your hardware."
	echo "1. : AMD"
	echo "2. : NVIDIA"
	read -p ">: " noc
	if [[ "$noc" == "1" ]]; then
		printf 'INSTALLING...' && clear
		amd
	fi
	if [[ "$noc" == "2" ]]; then
		printf 'INSTALLING...' && clear
		nvidia
	fi

}
prompt_0
xanmod() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e 'deb http://deb.xanmod.org releases main' | sudo tee -a /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
		sudo apt update && sudo apt install --install-recommends linux-xanmod-rt intel-microcode iucode-tool amd64-microcode -y
		echo -e 'net.core.default_qdisc = fq_pie' | sudo tee -a /etc/sysctl.d/90-override.conf
		clear
		read -p "You better reboot right now [r], or reboot (l)ater: " nock
		if [[ "$nock" == "r" ]]; then
			sudo reboot
		fi
		if [[ "$nock" == "l" ]]; then
			clear
		fi

	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm linux-xanmod linux-xanmod-headers
		echo -e 'net.core.default_qdisc = fq_pie' | sudo tee -a /etc/sysctl.d/90-override.conf
		clear
		read -p "You better reboot right now [r], or reboot (l)ater: " nock
		if [[ "$nock" == "r" ]]; then
			sudo reboot
		fi
		if [[ "$nock" == "l" ]]; then
			clear
		fi
	fi
}
liquarix() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:damentz/liquorix && sudo apt-get update
		sudo apt-get install --install-recommends linux-image-liquorix-amd64 linux-headers-liquorix-amd64
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
		cd
		git clone https://github.com/Frogging-Family/linux-tkg.git
		cd linux-tkg
		./install.sh install
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		cd
		git clone https://github.com/Frogging-Family/linux-tkg.git
		cd linux-tkg
		makepkg -si
		clear
	fi
}
prompt_1() {
	echo "You might want to customize your regular kernel as well, here is a couple of kernels(XANMOD is currently recommended) or you might (s)kip this step simply..."
	echo "1. : XANMOD(BOTH)"
	echo "2. : LIQUARIX(UBUNTUONLY)"
	echo "3. : ZEN(ARCHONLY)"
	echo "4. : LINUX-TKG((BOTH) Nvidia not for sure)"
	read -p ">: " nockl
	if [[ "$nockl" == "1" ]]; then
		printf 'INSTALLING...' && clear
		xanmod
	fi
	if [[ "$nockl" == "2" ]]; then
		printf 'INSTALLING...' && clear
		liquarix
	fi
	if [[ "$nockl" == "3" ]]; then
		printf 'INSTALLING...' && clear
		zen
	fi
	if [[ "$nockl" == "4" ]]; then
		printf 'INSTALLING...' && clear
		linux-tkg
	fi
	if [[ "$nockl" == "s" ]]; then
		printf 'SKIPPING...' && clear
	fi

}
prompt_1
prompt_2() {
	echo "Now you must install WINE and Dependencies either.[ENTER]"
	read -p ">: "
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		wget -nc https://dl.winehq.org/wine-builds/winehq.key
		sudo apt-key add winehq.key
		sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y
		sudo add-apt-repository ppa:lutris-team/lutris -y
		sudo apt update
		sudo apt-get install --install-recommends winehq-staging -y
		sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y
		sudo apt-get install --install-recommends dxvk lutris -y
		sudo apt-get install --install-recommends build-essential manpages-dev libx11-dev ninja xorg-dev meson glslang systemd git dbus base-devel -y
		cd
		git clone https://github.com/DadSchoorse/vkBasalt.git
		cd vkBasalt
		meson --buildtype=release --prefix=/usr builddir
		ninja -C builddir install
		cd
		git clone https://github.com/Frogging-Family/wine-tkg-git.git
		cd wine-tkg-git
		./non-makepkg-build.sh
		cd
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lutris -y
		yay -S --needed --noconfirm ninja meson glslang systemd git dbus base-devel dxvk-bin preload systemd-swap-git vkbasalt
		cd
		git clone https://github.com/Frogging-Family/wine-tkg-git.git
		cd wine-tkg-git
		makepkg -si
		cd
	fi
}
prompt_2
prompt_3() {
	clear
	ulimit -Hn
	echo "If this above returns more than 500,000 than ESYNC IS ENABLED! (s)kip this step... If not than dig in![y]"
	read -p ">: " nocklb
	if [[ "$nocklb" == "y" ]]; then
		echo -e 'DefaultLimitNOFILE=524288' | sudo tee -a /etc/systemd/system.conf && echo -e 'DefaultLimitNOFILE=524288' | sudo tee -a /etc/systemd/user.conf
		echo -e $USER 'hard nofile 524288' | sudo tee -a /etc/security/limits.conf
		sleep 1s
		printf "DONE."
	fi
	if [[ "$nocklb" == "s" ]]; then
		printf 'SKIPPING...' && clear
	fi

}
prompt_3
utilities() {
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo add-apt-repository ppa:linrunner/tlp
		sudo apt update
		sudo apt install gamemode earlyoom steam preload tlp tlp-rdw zram-tools amd64-microcode iucode-tool intel-microcode microcode.ctl -y
		sudo apt --purge remove gstreamer1.0-fluendo-mp3 deja-dup shotwell whoopsie whoopsie-preferences -y
		sudo tlp start
		sudo sysctl -w vm.swappiness=1
		echo -e 'vm.swappiness=1' | sudo tee -a /etc/sysctl.d/local.conf
		echo -e 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.d/local.conf
		echo -e 'Acquire::Languages "none";' | sudo tee -a /etc/apt/apt.conf.d/00aptitude
		clear
	fi
	which pacman >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		yay -S --needed --noconfirm gamemode lib32-gamemode earlyoom steam preload tlp tlp-rdw systemd-swap-git
		sudo tlp start
		sudo sysctl -w vm.swappiness=1
		echo -e 'vm.swappiness=1' | sudo tee -a /etc/sysctl.d/local.conf
		echo -e 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.d/local.conf
		clear
	fi
}
prompt_4() {
	echo "Do you want install also Utility wares? gamemode, earlyoom and steam etc.(AS I PERSONALLY RECOMMEND THAT[y]) (s)kip this step"
	read -p ">: " nocklby
	if [[ "$nocklby" == "y" ]]; then
		utilities
	fi
	if [[ "$nocklby" == "s" ]]; then
		clear
	fi

}
prompt_4

extra() {
	curl https://raw.githubusercontent.com/YurinDoctrine/secure-linux/master/secure.sh >secure.sh &&
	 chmod 755 secure.sh &&
	 sudo ./secure.sh

}

prompt_5() {
	echo "Okay here is final step: Do you also want to run the author's secure-linux script? (y)es or (n)o."
	read -p ">: " nocklbye
	if [[ "$nocklbye" == "y" ]]; then
		which apt >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			clear
			extra
		fi
		which pacman >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			clear
			extra
		fi
	fi
	if [[ "$nocklbye" == "n" ]]; then
		clear
		printf "YOU ARE ALL SET TO GO!\n"
		sleep 2s
		printf "MY THANKS <3... IF YOU'RE HAVING AN ISSUE(HOPE NOT) JUST COMMIT YOUR ISSUE RIGHT IN MY GITHUB!\n"
		sleep 1s
		printf "THERE YOU GO; http://www.github.com/YurinDoctrine/ultra-gaming-setup-wizard/issues/ \n"
		printf "\n"
	fi
}
prompt_5

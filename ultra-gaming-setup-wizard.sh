#!/bin/bash

clear
echo "╔═══════════════════════════════════════════════════╗"
echo "║ This script only works on Ubuntu based distros. ╗ ║"
echo "║                                      (for a while)║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
read -p "To continue press [ENTER], or ^C to Abort."

title_bar() {
	clear
	echo "╔═══════════════════════════════════════════════════╗"
	echo "║YURIN'S | ultimate-gaming-setup-wizard | Greetings!║"
	echo "╚═══════════════════════════════════════════════════╝"
}
title_bar
	read -p "YOU'LL NEED TO BE ABLE SURE 32-BIT LIBRARIES ENABLED[ENTER], to Abort{^C}: "

amd() {
	sudo add-apt-repository ppa:kisak/kisak-mesa -y
	sudo apt update
	sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
	echo 'RADV_PERFTEST=aco' | sudo tee /etc/environment
	clear
}

nvidia() {
	sudo add-apt-repository ppa:graphics-drivers/ppa -y
	sudo apt update
	sudo apt install nvidia-driver-450 libnvidia-gl-450 libnvidia-gl-450:i386 libvulkan1 libvulkan1:i386 -y
	clear
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
xanmod() {
	echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
	sudo apt update && sudo apt install linux-xanmod-rt intel-microcode iucode-tool amd64-microcode -y
	echo 'net.core.default_qdisc = fq_pie' | sudo tee /etc/sysctl.d/90-override.conf
	clear
	read -p "You better reboot right now [r], or reboot (l)ater." nock
	if [[ "$nock" == "r" ]]; then
	sudo reboot
	fi
	if [[ "$nock" == "l" ]]; then
	clear
	fi

}

liquarix() {
	sudo add-apt-repository ppa:damentz/liquorix && sudo apt-get update
	sudo apt-get install linux-image-liquorix-amd64 linux-headers-liquorix-amd64
	clear
}

multiarch() {
        sudo dpkg --add-architecture i386
        prompt_0
}
multiarch
prompt_1() {
	echo "You might want to customize your current(generic) kernel as well... here is your options(XANMOD is currently recommended) or you might (s)kip this step simply..."
	echo "1. : XANMOD"
	echo "2. : LIQUARIX"
	read -p ">: " nockl 
	if [[ "$nockl" == "1" ]]; then
	printf 'INSTALLING...' && clear
	xanmod
	fi
	if [[ "$nockl" == "2" ]]; then
	printf 'INSTALLING...' && clear
	liquarix
	fi
	if [[ "$nockl" == "s" ]]; then
	printf 'SKIPPING...' && clear
	fi

}
prompt_1

prompt_2() {
	read -p "Now you must install WINE and Dependancies either[ENTER]>: "
	wget -nc https://dl.winehq.org/wine-builds/winehq.key
	sudo apt-key add winehq.key
	sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y
	sudo add-apt-repository ppa:lutris-team/lutris -y
	sudo apt update
	sudo apt-get install --install-recommends winehq-staging -y
	sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y
	sudo apt-get install --install-recommends dxvk lutris -y
	clear

}

prompt_2

prompt_3() {
	ulimit -Hn
	echo "If this above returns more than 500,000 than ESYNC IS ENABLED![ (s)kip this step ] If not[y], than dig in!"
	read -p ">: " nocklb
	if [[ "$nocklb" == "y" ]]; then
        echo 'DefaultLimitNOFILE=524288' | sudo tee /etc/systemd/system.conf && echo 'DefaultLimitNOFILE=524288' | sudo tee /etc/systemd/user.conf
	echo $USER 'hard nofile 524288'| sudo tee /etc/security/limits.conf
	sleep 1s
	printf "DONE."
        fi
        if [[ "$nocklb" == "s" ]]; then
        printf 'SKIPPING...' && clear
        fi

}
prompt_3
utulities() {
	sudo add-apt-repository ppa:linrunner/tlp
	sudo apt update
	sudo apt install --install-recommends gamemode earlyoom tlp tlp-rdw amd64-microcode iucode-tool intel-microcode -y
	clear
}
prompt_4() {
	echo "Do you want install also Utility wares? gamemode, earlyoom etc.(AS I PERSONALLY RECOMMEND THAT[y]) (s)kip this step"
	read -p ">: " nocklby
	if [[ "$nocklby" == "y" ]]; then
	utulities
	fi
	if [[ "$nocklby" == "s" ]]; then
	clear
	fi

}

prompt_4

prompt_5() {
	echo "Okay here is final step: Do you want to install steam? [y]/[n(later)]"
	read -p ">: " nocklbye
	if [[ "$nocklbye" == "y" ]]; then
	sudo apt install --install-recommends steam-installer -y
	clear
	printf "YOU ARE ALL SET TO GO!\n"
        sleep 2s
        printf "MY THANKS <3... IF YOU'RE HAVING AN ISSUE(HOPE NOT) JUST COMMIT YOUR ISSUE RIGHT IN MY GITHUB.\n"
        sleep 1s
        printf "THERE YOU GO:' http://www.github.com/YurinDoctrine/ultra-gaming-setup-wizard/issues/ '\n"
	fi
	if [[ "$nocklbye" == "n" ]]; then
	clear
	printf "YOU ARE ALL SET TO GO!\n"
	sleep 2s
	printf "MY THANKS <3... IF YOU'RE HAVING AN ISSUE(HOPE NOT) JUST COMMIT YOUR ISSUE RIGHT IN MY GITHUB.\n"
	sleep 1s
	printf "THERE YOU GO:' http://www.github.com/YurinDoctrine/ultra-gaming-setup-wizard/issues/ '\n"
	fi
}

prompt_5

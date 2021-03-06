#!/bin/bash

which apt >/dev/null 2>&1
if [ $? -eq 0 ]; then
    which apt >/dev/null 2>&1
    if [ $? != 0 ]; then
        clear
        echo -e "╔═══════════════════════════════════════════════════╗"
        echo -e "║THIS SCRIPT ONLY WORKS ON ARCH&UBUNTU BASED DISTROS║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 0
    fi
else
    clear
    echo -e "╔═══════════════════════════════════════════════════╗"
    echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
    echo -e "║                                                   ║"
    echo -e "╚═══════════════════════════════════════════════════╝"
    echo -e ""
fi

which pacman >/dev/null 2>&1
if [ $? -eq 0 ]; then
    which pacman >/dev/null 2>&1
    if [ $? != 0 ]; then
        clear
        echo -e "╔═══════════════════════════════════════════════════╗"
        echo -e "║THIS SCRIPT ONLY WORKS ON ARCH&UBUNTU BASED DISTROS║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 0
    fi
else
    clear
    echo -e "╔═══════════════════════════════════════════════════╗"
    echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
    echo -e "║                                                   ║"
    echo -e "╚═══════════════════════════════════════════════════╝"
    echo -e ""
fi

32bit() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dpkg --add-architecture i386
        sudo apt update
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        _has_multilib=$(grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:)
        if [[ -z $_has_multilib ]]; then
            echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
            echo -e "Multilib repository successfully added into pacman.conf file\n"
        else
            sudo sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
            _has_multilib=$((${_has_multilib} + 1))
            sudo sed -i "${_has_multilib}s/^#//" /etc/pacman.conf
        fi
        sudo pacman -Sy
    fi
}
32bit

amd() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo add-apt-repository ppa:kisak/kisak-mesa -y
        sudo apt update
        sudo apt install --install-recommends libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y &&
            echo -e "RADV_PERFTEST=aco" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=0" | sudo tee -a /etc/environment
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader xf86-video-amdgpu vulkan-radeon &&
            echo -e "RADV_PERFTEST=aco" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=0" | sudo tee -a /etc/environment
    fi
}

nvidia() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo add-apt-repository ppa:graphics-drivers/ppa -y
        sudo apt update
        sudo apt install --install-recommends nvidia-driver-450 libnvidia-gl-450 libnvidia-gl-450:i386 libvulkan1 libvulkan1:i386 -y
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm nvidia opencl-nvidia lib32-opencl-nvidia lib32-nvidia-utils
    fi
}

prompt_0() {
    echo -e "CHOOSE THE COMPATIBLE WHICH IS IN BELOW WITH YOUR HARDWARE. (RETURN IS: NONE)"
    echo -e "1. : AMD"
    echo -e "2. : NVIDIA"
    read -p $'>_: ' nock
    if [[ "$nock" == "1" ]]; then
        amd
    fi
    if [[ "$nock" == "2" ]]; then
        nvidia
    fi
    if [[ "$nock" == "" ]]; then
        clear
    fi
}
prompt_0

xanmod() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "deb http://deb.xanmod.org releases main" | sudo tee -a /etc/apt/sources.list.d/xanmod-kernel.list &&
            wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
        sudo apt update &&
            sudo apt install --install-recommends linux-xanmod-rt -y
        echo -e "net.core.default_qdisc = fq_pie" | sudo tee /etc/sysctl.d/90-override.conf
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm linux-xanmod-rt linux-xanmod-headers
        echo -e "net.core.default_qdisc = fq_pie" | sudo tee /etc/sysctl.d/90-override.conf
    fi
}

liquarix() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo add-apt-repository ppa:damentz/liquorix -y &&
            sudo apt update
        sudo apt install --install-recommends linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -y
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm linux-lqx linux-lqx-headers
    fi
}

zen() {
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm linux-zen linux-zen-headers
    fi
}

linux-tkg() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        cd /tmp &&
            git clone https://github.com/Frogging-Family/linux-tkg.git &&
            cd linux-tkg/ &&
            ./install.sh install &&
            cd /tmp
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        cd /tmp &&
            git clone https://github.com/Frogging-Family/linux-tkg.git &&
            cd linux-tkg/ &&
            makepkg -si &&
            cd /tmp
    fi
}

prompt_1() {
    echo -e "FIND IN BELOW CUSTOM KERNELS ACROSS OF THEM BENEFITS... (RETURN IS: NONE)"
    echo -e "1. : XANMOD(BOTH)"
    echo -e "2. : LIQUARIX(BOTH)"
    echo -e "3. : ZEN(ARCHONLY)"
    echo -e "4. : LINUX-TKG(BOTH)"
    read -p $'>_: ' nockl
    if [[ "$nockl" == "1" ]]; then
        echo -e "INSTALLING ..." &&
            xanmod
    fi
    if [[ "$nockl" == "2" ]]; then
        echo -e "INSTALLING ..." &&
            liquarix
    fi
    if [[ "$nockl" == "3" ]]; then
        echo -e "INSTALLING ..." &&
            zen
    fi
    if [[ "$nockl" == "4" ]]; then
        echo -e "INSTALLING ..." &&
            linux-tkg
    fi
    if [[ "$nockl" == "" ]]; then
        clear
    fi
}
prompt_1

prompt_2() {
    echo -e "NOW YOU GOTTA INSTALL WINE THOUGH. [RETURN]"
    read -p $'>_: '
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        cd /tmp &&
            wget -qnc https://dl.winehq.org/wine-builds/winehq.key &&
            sudo apt-key add winehq.key &&
            sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' -y &&
            cd
        sudo add-apt-repository ppa:lutris-team/lutris -y
        sudo apt update
        sudo apt install --install-recommends winehq-staging -y
        sudo apt install --install-recommends libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y
        sudo apt install --install-recommends build-essential manpages-dev libx11-dev xorg-dev dbus steam lutris -y
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm wine-staging
        yay -S --needed --noconfirm giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
        yay -S --needed --noconfirm dbus steam lutris
    fi
}
prompt_2

prompt_3() {
    echo -e ""
    ulimit -Hn
    echo -e ""
    echo -e "IF THIS ABOVE RETURNS MORE THAN 500,000 THEN ESYNC IS ENABLED!"
    read -p $'true/false >_: ' nocklb
    if [[ "$nocklb" == "false" ]]; then
        sudo sed -i 's/^#DefaultLimitNOFILE/DefaultLimitNOFILE/' /etc/systemd/system.conf
        sudo sed -i 's/^#DefaultLimitNOFILE/DefaultLimitNOFILE/' /etc/systemd/user.conf
        echo -e $USER "hard nofile 524288" | sudo tee -a /etc/security/limits.conf
        sleep 0.8
        echo -e "DONE."
    fi
}
prompt_3

prompt_4() {
    echo -e "NEXT YOU GOTTA INSTALL A COUPLE OF DAEMON EITHER (gamemode, thermald etc.) [HIT RETURN]"
    read -p $'>_: '
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo apt install --install-recommends gamemode -y
        sudo apt install --install-recommends thermald -y
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm gamemode lib32-gamemode
        yay -S --needed --noconfirm thermald
    fi
}
prompt_4

extra() {
    curl -fsSL https://raw.githubusercontent.com/YurinDoctrine/secure-linux/master/secure.sh >secure.sh &&
        chmod 755 secure.sh &&
        ./secure.sh
}

final() {
    echo -e "FINAL: DO YOU ALSO WANT TO RUN THE AUTHOR'S secure-linux?"
    read -p $'yes/no >_: ' nocklby
    if [[ "$nocklby" == "yes" ]]; then
        echo -e "RUNNING ..."
        extra
    elif [[ "$nocklby" == "no" ]]; then
        echo -e "LEAVING ..."
        exit 0
    else
        echo -e "INVALID VALUE!\n"
        final
    fi
}
final

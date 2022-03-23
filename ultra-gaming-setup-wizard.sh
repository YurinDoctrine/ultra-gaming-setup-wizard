#!/usr/bin/env bash

which apt >/dev/null 2>&1
if [ $? -eq 0 ]; then
    which apt >/dev/null 2>&1
    if [ $? != 0 ]; then
        clear
        echo -e "╔═══════════════════════════════════════════════════╗"
        echo -e "║ THIS SCRIPT ONLY WORKS ON ARCH, UBUNTU AND FEDORA ║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 1
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
        echo -e "║ THIS SCRIPT ONLY WORKS ON ARCH, UBUNTU AND FEDORA ║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 1
    fi
else
    clear
    echo -e "╔═══════════════════════════════════════════════════╗"
    echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
    echo -e "║                                                   ║"
    echo -e "╚═══════════════════════════════════════════════════╝"
    echo -e ""
fi

which dnf >/dev/null 2>&1
if [ $? -eq 0 ]; then
    which dnf >/dev/null 2>&1
    if [ $? != 0 ]; then
        clear
        echo -e "╔═══════════════════════════════════════════════════╗"
        echo -e "║ THIS SCRIPT ONLY WORKS ON ARCH, UBUNTU AND FEDORA ║"
        echo -e "║                                                   ║"
        echo -e "╚═══════════════════════════════════════════════════╝"
        echo -e ""
        exit 1
    fi
else
    clear
    echo -e "╔═══════════════════════════════════════════════════╗"
    echo -e "║YURIN's | ultimate-gaming-setup-wizard | greetings!║"
    echo -e "║                                                   ║"
    echo -e "╚═══════════════════════════════════════════════════╝"
    echo -e ""
fi

multilib() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo add-apt-repository universe -y &&
            sudo add-apt-repository multiverse -y
        sudo dpkg --add-architecture i386
        sudo apt-get update
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        _has_multilib=$(grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:)
        if [[ -z $_has_multilib ]]; then
            # artix
            echo -e "\n[lib32]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
        else
            sudo sed -i -e "${_has_multilib}s/^#//" /etc/pacman.conf
            _has_multilib=$((${_has_multilib} + 1))
            sudo sed -i -e "${_has_multilib}s/^#//" /etc/pacman.conf
        fi
        sudo pacman -Syy
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf check-update
        sudo dnf install dnf-plugins-core -y
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    fi
}
multilib

amd() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        ubuntu-drivers devices
        ubuntu-drivers list
        sudo ubuntu-drivers autoinstall
        sudo add-apt-repository ppa:kisak/kisak-mesa -y
        sudo apt-get update
        sudo apt install -f --assume-yes --no-install-recommends libglx-mesa0 libglx-mesa0:i386 libgl1-mesa-dri libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 mesa-va-drivers mesa-va-drivers:i386 libvulkan-dev libvulkan-dev:i386 mesa-utils vulkan-tools mesa-common-dev &&
            echo -e "AMD_VULKAN_ICD=amdvlk" | sudo tee -a /etc/environment &&
            echo -e "RADV_PERFTEST=aco" | sudo tee -a /etc/environment &&
            echo -e "RADV_TEX_ANISO=16" | sudo tee -a /etc/environment &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "WINE_FSR_OVERRIDE=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR_STRENGTH=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm mesa lib32-mesa xf86-video-ati xf86-video-amdgpu libva-mesa-driver vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools &&
            echo -e "AMD_VULKAN_ICD=amdvlk" | sudo tee -a /etc/environment &&
            echo -e "RADV_PERFTEST=aco" | sudo tee -a /etc/environment &&
            echo -e "RADV_TEX_ANISO=16" | sudo tee -a /etc/environment &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "WINE_FSR_OVERRIDE=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR_STRENGTH=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf install vulkan -y &&
            echo -e "AMD_VULKAN_ICD=amdvlk" | sudo tee -a /etc/environment &&
            echo -e "RADV_PERFTEST=aco" | sudo tee -a /etc/environment &&
            echo -e "RADV_TEX_ANISO=16" | sudo tee -a /etc/environment &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "WINE_FSR_OVERRIDE=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_FULLSCREEN_FSR_STRENGTH=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
    fi
}

nvidia() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        ubuntu-drivers devices
        ubuntu-drivers list
        sudo ubuntu-drivers autoinstall
        sudo add-apt-repository ppa:graphics-drivers/ppa -y
        sudo apt-get update
        sudo apt install -f --assume-yes --no-install-recommends libglx-mesa0 libglx-mesa0:i386 libgl1-mesa-dri libgl1-mesa-dri:i386 nvidia-driver-510 libnvidia-gl-510 libnvidia-gl-510:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 mesa-va-drivers mesa-va-drivers:i386 libvulkan-dev libvulkan-dev:i386 mesa-utils vulkan-tools mesa-common-dev &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "__NV_PRIME_RENDER_OFFLOAD=1" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm mesa lib32-mesa nvidia nvidia-dkms opencl-nvidia lib32-opencl-nvidia nvidia-utils lib32-nvidia-utils xf86-video-nouveau libva-mesa-driver vulkan-tools vulkan-intel lib32-vulkan-intel &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "__NV_PRIME_RENDER_OFFLOAD=1" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs -y &&
            echo -e "WINE_LARGE_ADDRESS_AWARE=1" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC_SPINCOUNT=24" | sudo tee -a /etc/environment &&
            echo -e "WINEFSYNC=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_GECKO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "WINE_SKIP_MONO_INSTALLATION=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_WRITECOPY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_SHARED_MEMORY=1" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_SERVER=4" | sudo tee -a /etc/environment &&
            echo -e "STAGING_RT_PRIORITY_BASE=2" | sudo tee -a /etc/environment &&
            echo -e "DXVK_ASYNC=1" | sudo tee -a /etc/environment &&
            echo -e "DXVK_HUD=compile" | sudo tee -a /etc/environment &&
            echo -e "MESA_NO_ERROR=1" | sudo tee -a /etc/environment &&
            echo -e "mesa_glthread=true" | sudo tee -a /etc/environment &&
            echo -e "__GL_THREADED_OPTIMIZATIONS=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SYNC_TO_VBLANK=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_MaxFramesAllowed=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_SHADER_DISK_CACHE=1" | sudo tee -a /etc/environment &&
            echo -e "__GL_YIELD=NOTHING" | sudo tee -a /etc/environment &&
            echo -e "__NV_PRIME_RENDER_OFFLOAD=1" | sudo tee -a /etc/environment &&
            echo -e "VKD3D_CONFIG=upload_hvv" | sudo tee -a /etc/environment &&
            echo -e "vblank_mode=1" | sudo tee -a /etc/environment
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
        echo -e "deb http://deb.xanmod.org releases main" | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list &&
            wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
        sudo apt-get update
        sudo apt install --assume-yes --install-recommends linux-xanmod-rt -f
        echo -e "net.core.default_qdisc = fq_pie
net.ipv4.tcp_congestion_control = bbr" | sudo tee /etc/sysctl.d/90-override.conf
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm linux-xanmod-rt linux-xanmod-headers
        echo -e "net.core.default_qdisc = fq_pie
net.ipv4.tcp_congestion_control = bbr" | sudo tee /etc/sysctl.d/90-override.conf
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf copr enable rmnscnce/kernel-xanmod -y &&
        sudo dnf in kernel-xanmod-rt kernel-xanmod-exptl -y
        echo -e "net.core.default_qdisc = fq_pie
net.ipv4.tcp_congestion_control = bbr" | sudo tee /etc/sysctl.d/90-override.conf
    fi
}

liquarix() {
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo add-apt-repository ppa:damentz/liquorix -y &&
            sudo apt-get update
        sudo apt install --assume-yes --install-recommends linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -f
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm linux-lqx linux-lqx-headers
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf copr enable rmnscnce/kernel-lqx -y &&
        sudo dnf install kernel-lqx kernel-lqx-headers -y
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
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        cd /tmp &&
            git clone https://github.com/Frogging-Family/linux-tkg.git &&
            cd linux-tkg/ &&
            ./install.sh install &&
            cd /tmp
    fi
}

prompt_1() {
    echo -e "FIND IN BELOW CUSTOM KERNELS ACROSS OF THEM BENEFITS... (RETURN IS: NONE)"
    echo -e "1. : XANMOD(ALL)"
    echo -e "2. : LIQUARIX(ALL)"
    echo -e "3. : ZEN(ARCHONLY)"
    echo -e "4. : LINUX-TKG(ALL)"
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
            sudo add-apt-repository ppa:lutris-team/lutris -y
        sudo apt-get update
        sudo apt install --assume-yes winehq-staging libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -f
        sudo apt install -f --assume-yes kubuntu-restricted-extras
        sudo apt install -f --assume-yes --no-install-recommends dialog dosbox speedtest-cli steam lutris make zenity q4wine winetricks
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugin lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
        yay -S --needed --noconfirm dialog dosbox speedtest-cli steam lutris make zenity q4wine winetricks
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/$(rpm -E %fedora)/winehq.repo &&
            sudo dnf install winehq-staging -y
        sudo dnf install dialog dosbox speedtest-cli steam lutris make zenity q4wine winetricks -y
    fi
    echo -e "abi.vsyscall32 = 0" | sudo tee -a /etc/sysctl.d/99-swappiness.conf
}
prompt_2

prompt_3() {
    clear
    ulimit -n 1048576
    ulimit -Hn
    echo -e ""
    echo -e "IF THIS ABOVE RETURNS MORE THAN 500,000 THEN ESYNC IS ENABLED!"
    read -p $'true/false >_: ' nocklb
    if [[ "$nocklb" == "false" ]]; then
        echo -e $USER "hard nofile 1048576" | sudo tee -a /etc/security/limits.conf
        sudo sed -i -e 's/^#DefaultLimitNOFILE.*/DefaultLimitNOFILE=1048576/' /etc/systemd/system.conf
    else
        sudo sed -i -e 's/^#DefaultLimitNOFILE/DefaultLimitNOFILE/' /etc/systemd/system.conf
    fi
    echo -e "DONE!"
}
prompt_3

prompt_4() {
    echo -e "NEXT YOU GOTTA INSTALL A COUPLE OF DAEMON EITHER (gamemode, thermald etc.) [HIT RETURN]"
    read -p $'>_: '
    which apt >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo apt install --assume-yes --install-recommends schedtool -f
        sudo apt install --assume-yes --install-recommends acpi-support -f
        git clone https://github.com/Nefelim4ag/Ananicy.git
        ./Ananicy/package.sh debian
        sudo dpkg -i ./Ananicy/ananicy-*.deb
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        sudo ./auto-cpufreq/auto-cpufreq-installer
        sudo apt install --assume-yes --install-recommends gamemode -f
        sudo apt install --assume-yes --install-recommends thermald -f

        sudo systemctl enable ananicy
        sudo systemctl start ananicy
        sudo systemctl enable auto-cpufreq
        sudo systemctl start auto-cpufreq
    fi
    which pacman >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        yay -S --needed --noconfirm schedtool acpid ananicy-git auto-cpufreq-git gamemode lib32-gamemode thermald

        sudo systemctl enable ananicy
        sudo systemctl start ananicy
        sudo systemctl enable auto-cpufreq
        sudo systemctl start auto-cpufreq
    fi
    which dnf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        sudo dnf install acpid -y
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        sudo ./auto-cpufreq/auto-cpufreq-installer
        sudo dnf install gamemode -y
        sudo dnf install thermald -y

        sudo systemctl enable auto-cpufreq
        sudo systemctl start auto-cpufreq
    fi
}
prompt_4

extra() {
    cd /tmp
    curl --tlsv1.2 -fsSL https://raw.githubusercontent.com/YurinDoctrine/secure-linux/master/secure.sh >secure.sh &&
        chmod 0755 secure.sh &&
        ./secure.sh
}

final() {

    sleep 0.2 && clear
    echo -e "
###############################################################################
# FINAL: DO YOU ALSO WANT TO RUN THE AUTHOR'S secure-linux?
###############################################################################"

    read -p $'yes/no >_: ' nocklby
    if [[ "$nocklby" == "yes" ]]; then
        echo -e "RUNNING ..."
        extra
    elif [[ "$nocklby" == "no" ]]; then
        echo -e "LEAVING ..."
        exit 0
    else
        echo -e "INVALID VALUE!"
        final
    fi
}
final

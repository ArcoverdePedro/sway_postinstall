#!/bin/bash

# Esse é um arquivo de post-install para o meu arch padrão com kernel zen e SwayWM instalado com o arquivo de instalação arch install 

# Atualiza sistema
sudo pacman -Syu --noconfirm

# Instalações para Coding e Redes
sudo pacman -S --noconfirm \
  emacs dbeaver wezterm podman podman-compose docker docker-compose jupyter vscodium go \
  wireguard openvpn python-pipx curl flatpak vlc \
  thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman ffmpegthumbnailer tumbler gvfs gvfs-mtp gvfs-gphoto2 \
  virtualbox virtualbox-host-dkms virtualbox-guest-iso linux-zen-headers \
  libreoffice-still imv xarchiver okular grub efibootmgr os-prober \
  thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman \
  ffmpegthumbnailer tumbler gvfs gvfs-mtp gvfs-gphoto2 telegram-desktop

# Configuração GTK
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
EOF

# Definir como padrão
xdg-mime default thunar.desktop inode/directory

# Configurar thumbnails
mkdir -p ~/.config/tumbler
cat > ~/.config/tumbler/tumbler.rc <<EOF
[Thumbnailer]
EnableThumbnailer=true
MaxFileSize=2048
EOF

echo "Thunar configurado com sucesso!"

# Pyenv
curl -fsSL https://pyenv.run | bash
pipx ensurepath
pipx install bandit black pyright

# Dual Boot com Windows (Se tiver)
echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Instalação Fonte do Emacs
wget -q https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
unzip -o JetBrainsMono-2.304.zip -d ~/.fonts/
fc-cache -fv

# Instalação do yay
if [ ! -d yay ]; then
    git clone --depth 1 https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si --noconfirm)
fi

# Instalação de programas com AUR

yay -S --noconfirm librewolf-bin nerd-fonts github-desktop-bin gittyup soapui wlrobs bash-language-server

# Instalações para o OBS
sudo pacman -S --noconfirm \
  obs-studio xdg-desktop-portal-wlr v4l2loopback-dkms \
  xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-gnome \
  qt5-wayland qt6-wayland

# Configuração VBox
sudo modprobe vboxdrv
sudo usermod -aG vboxusers "$USER"
vboxver=$(vboxmanage -v | cut -dr -f1) 
wget https://download.virtualbox.org/virtualbox/$((vboxver))/Oracle_VM_VirtualBox_Extension_Pack-$((vboxver)).vbox-extpack

# Configuração Docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"




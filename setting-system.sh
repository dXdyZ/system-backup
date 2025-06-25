#!/bin/bash

# Установка основных пакетов
sudo pacman -Syu --noconfirm

# Установка AUR-помощника (например, yay)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

sudo pacman -S --noconfirm ttf-font-awesome otf-font-awesome ttf-jetbrains-mono 
sudo pacman -S --noconfirm fish pkgfile ttf-dejavu powerline-fonts inetutils
sudo pacman -S --noconfirm telegram-desktop 
sudo pacman -S --noconfirm jdk17-openjdk 
sudo pacman -S --noconfirm bluez bluez-utils
sudo pacman -S --noconfirm openvpn 
sudo pacman -S --noconfirm zathura mpv termdown 
sudo pacman -S --noconfirm fuse2 htop 
sudo pacman -S --noconfirm lsd pavucontrol

yay -S --noconfirm hyprshot


# Установка Docker
echo "Установка Docker..."
sudo pacman -S --noconfirm docker docker-compose
# Включение службы
sudo systemctl enable --now docker
# Настройка прав для пользователя
sudo usermod -aG docker $USER


# Установка idea
echo "Установка idea"
sudo openvpn --config aaaaaaa-gr8.vpnjantit-udp-2500.ovpn --daemon

sleep 5
yay -S --noconfirm intellij-idea-ultimate-edition
sudo pkill -f "openvpn --config **"

echo "Установка завершена. VPN выключен"

# Копирование конфигов
echo "Копирование конфигов"
cp -r ~/system-backup/hypr ~/.config/
cp -r ~/system-backup/kitty ~/.config/
cp -r ~/system-backup/wofi ~/.config/
cp -r ~/system-backup/mpv ~/.config/
echo "Копирование конфигов завершено"







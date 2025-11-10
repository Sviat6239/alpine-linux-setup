#!/bin/ash

# get current username or fallback to "user"
USER_NAME=${USER:-user}

# basic packages and tools
apk add curl socat nmap net-tools build-base setxkbmap sudo xrandr bash zsh dbus dbus-x11

# Xorg and display manager
apk add setup-xorg-base lightdm lightdm-gtk-greeter

# i3 window manager and bar components
apk add i3wm i3status i3lock dmenu i3bar libxcb-dev feh

# graphics and network utilities
apk add mesa-gl glib firefox-esr accountsservice openvpn

# create user if doesn't exist
if ! id "$USER_NAME" >/dev/null 2>&1; then
    adduser -D "$USER_NAME"
fi

# create user directories
mkdir -p /home/$USER_NAME/wallpaper
mkdir -p /home/$USER_NAME/.config/i3
mkdir -p /home/$USER_NAME/.scripts

# copy configs
cp ./ibuetler/wallpaper/compass.jpg /home/$USER_NAME/wallpaper/compass.jpg
cp ./ibuetler/.config/i3/config /home/$USER_NAME/.config/i3/config
cp ./ibuetler/.profile /home/$USER_NAME/.profile
cp ./ibuetler/login-script.sh /home/$USER_NAME/.scripts/login-script.sh
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

# add to sudoers
cat ./ibuetler/sudoers >> /etc/sudoers

# lightdm background
echo "background=/home/$USER_NAME/wallpaper/compass.jpg" >> /etc/lightdm/lightdm-gtk-greeter.conf

# accountsservice setup
cp ./ibuetler/ibuetler /var/lib/AccountsService/users/$USER_NAME
chown root:root /var/lib/AccountsService/users/$USER_NAME

# docker group
addgroup $USER_NAME docker

# VMware tools (if needed)
apk add open-vm-tools open-vm-tools-guestinfo open-vm-tools-deploypkg open-vm-tools-gtk xf86-video-vmware
chmod g+s /usr/bin/vmware-user-suid-wrapper

# permissions for /opt
chown $USER_NAME:$USER_NAME /opt
mkdir -p /opt/docker
cp ./docker/* /opt/docker/
chown $USER_NAME:$USER_NAME /opt/docker

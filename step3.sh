#!/bin/ash

# detect current user (fallback to 'user' if undefined)
USER_NAME=${USER:-user}

echo ">>> Setting up system services for $USER_NAME"

# start and enable D-Bus
rc-service dbus start
rc-update add dbus default

# start and enable LightDM display manager
rc-service lightdm start
rc-update add lightdm default

# start and enable VMware tools (if running in a VM)
apk info | grep -q open-vm-tools && {
    rc-service open-vm-tools start
    rc-update add open-vm-tools boot
}

# start and enable Docker
rc-service docker start
rc-update add docker boot

echo ">>> Services have been started and added to autostart."

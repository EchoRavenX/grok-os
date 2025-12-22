#!/bin/bash
set -ouex pipefail

# Install our light tweaks (rawhide NVK/Mesa already daily bleeding-edge maxed)
rpm-ostree install \
    zsh \
    uutils-coreutils \
    zenity

# Set zsh as default shell for root and new users
chsh -s /bin/zsh root

# Fix for Atomic minimal root home (create dir first)
mkdir -p /root
cp -r /etc/skel/. /root/.

# uutils aliases sauce
echo "alias ls='uu-ls'  # uutils coreutils" >> /etc/skel/.zshrc
echo "alias ll='uu-ls -l'" >> /etc/skel/.zshrc
echo "alias cat='uu-cat'" >> /etc/skel/.zshrc
echo "alias cp='uu-cp'" >> /etc/skel/.zshrc
echo "alias mv='uu-mv'" >> /etc/skel/.zshrc

# Make driver switcher executable (if you added the file)
chmod +x /usr/bin/grok-driver-switch || true

# General cleanup (pure image)
rpm-ostree cleanup -m

ostree container commit

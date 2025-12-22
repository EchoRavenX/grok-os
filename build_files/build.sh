#!/bin/bash
set -ouex pipefail

# No COPR needed - rawhide base has latest NVK/Mesa git daily (community bug reports → patches next day)
# kernel stock rawhide = responsive gaming beast (no need tkg conflicts)

# Install our light tweaks (extras you wanted)
rpm-ostree install \
    zsh \
    uutils-coreutils \
    zenity

# Set zsh as default shell for root and new users
chsh -s /bin/zsh root
cp -r /etc/skel/. ~root/.
echo "alias ls='uu-ls'  # uutils coreutils aliases" >> /etc/skel/.zshrc
echo "alias ll='uu-ls -l'" >> /etc/skel/.zshrc
echo "alias cat='uu-cat'" >> /etc/skel/.zshrc
echo "alias cp='uu-cp'" >> /etc/skel/.zshrc
echo "alias mv='uu-mv'" >> /etc/skel/.zshrc

# Make driver switcher executable (if you added the file)
chmod +x /usr/bin/grok-driver-switch || true

# General cleanup (pure image)
rpm-ostree cleanup -m

ostree container commit

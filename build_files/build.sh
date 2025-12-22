#!/bin/bash
set -ouex pipefail

# Enable COPRs for bleeding-edge sauce
rpm-ostree copr enable whitehara/kernel-tkg  # Zen-like gaming kernel patches (responsive AF)
rpm-ostree copr enable xxmitsu/mesa-and-llvm-git  # Latest mesa-git + llvm-git for max NVK gains (active & frequent builds)

# Remove old stock shit and install our tweaks
rpm-ostree override remove mesa* libdrm* kernel* kernel-core kernel-modules || true
rpm-ostree install \
    mesa-git \
    vulkan-loader-git \
    libdrm-git \
    kernel-tkg kernel-tkg-core kernel-tkg-modules kernel-tkg-modules-extra kernel-tkg-devel \
    zsh \
    uutils-coreutils \
    zenity

# Set zsh as default shell
chsh -s /bin/zsh root
cp -r /etc/skel/. ~root/.
echo "alias ls='uu-ls'  # uutils aliases (add more if you want)" >> /etc/skel/.zshrc

# Cleanup for clean image
rpm-ostree cleanup -m
ostree container commit

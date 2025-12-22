#!/bin/bash
set -ouex pipefail

# Manually add COPR repos (pure Fedora Atomic has no 'copr enable' plugin)
curl -Lo /etc/yum.repos.d/_copr_whitehara-kernel-tkg.repo https://copr.fedorainfracloud.org/coprs/whitehara/kernel-tkg/repo/fedora-$(rpm -E %fedora)/whitehara-kernel-tkg-fedora-$(rpm -E %fedora).repo

curl -Lo /etc/yum.repos.d/_copr_xxmitsu-mesa.repo https://copr.fedorainfracloud.org/coprs/xxmitsu/mesa-and-llvm-git/repo/fedora-$(rpm -E %fedora)/xxmitsu-mesa-and-llvm-git-fedora-$(rpm -E %fedora).repo

# Override remove stock packages (REQUIRED - base has old mesa/kernel that conflict with git/tkg versions)
rpm-ostree override remove mesa* libdrm* kernel* kernel-core kernel-modules kernel-modules-extra || true

# Install our bleeding-edge tweaks
rpm-ostree install \
    mesa-git \
    vulkan-loader-git \
    libdrm-git \
    kernel-tkg kernel-tkg-core kernel-tkg-modules kernel-tkg-modules-extra kernel-tkg-devel \
    zsh \
    uutils-coreutils \
    zenity

# Set zsh as default shell for root and new users
chsh -s /bin/zsh root
cp -r /etc/skel/. ~root/.
echo "alias ls='uu-ls'  # uutils aliases - add more if you want (uu-cp, uu-mv, etc.)" >> /etc/skel/.zshrc
echo "alias ll='uu-ls -l'" >> /etc/skel/.zshrc

# Make driver switcher executable (if you added the file)
chmod +x /usr/bin/grok-driver-switch || true

# Clean up temp COPR repo files + general cleanup (keeps image pure)
rm -f /etc/yum.repos.d/_copr_*.repo
rpm-ostree cleanup -m

ostree container commit

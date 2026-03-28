#!/bin/bash
set -euo pipefail

sudo apt install -y zsh-syntax-highlighting fzf build-essential

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/djui/alias-tips.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/alias-tips"
git clone --depth=1 https://github.com/ntnyq/omz-plugin-pnpm.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pnpm"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

case "$(uname -m)" in
    x86_64|amd64)  LAZYGIT_ARCH="Linux_x86_64" ;;
    aarch64|arm64) LAZYGIT_ARCH="Linux_arm64"   ;;
    *)
        echo "ERROR: Unsupported architecture '$(uname -m)' for lazygit download." >&2
        exit 1
        ;;
esac

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit

sudo install -m 755 lazygit /usr/local/bin/lazygit

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

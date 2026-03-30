# AGENTS.md

## Repo overview

- **GNU Stow-based dotfiles repo.** Each top-level directory is a stow package whose contents mirror the target layout relative to `$HOME`.
- Stow packages currently in the repo: `alacritty`, `dlv`, `k9s`, `lazygit`, `nvim`, `opencode`, `scroll-launchagents`, `scroll-switcher`, `starship`, `tmux`, `zathura`, `zshrc`.
- Helper scripts live in `scripts/`.

## Installation / bootstrap

- Run `./install.sh` to install system packages and restow dotfiles.
- Pass `--work` to include work-specific packages (runs `scripts/macos-work-packages.sh` and stows `k9s`).
- Auto-restowed packages (always): `lazygit`, `nvim`, `opencode`, `scroll-launchagents`, `scroll-switcher`, `starship`, `tmux`, `zshrc`.
- Auto-restowed packages (with `--work` only): `k9s`.
- On macOS, `scripts/macos-scroll-switcher.sh` is also executed.
- Some directories exist in the repo but are **not** auto-stowed by `install.sh`: `alacritty`, `dlv`, `zathura`. Stow these manually if needed (`stow -t "$HOME" --restow <pkg>`).

## Editing guidance

- **Edit files inside their package directory**, not the symlink targets in `$HOME`. Stow creates symlinks; the source of truth is this repo.
- Keep package directory contents aligned with what actually gets installed. If you add files to a package, verify the resulting symlink paths make sense under `$HOME`.
- When adding a brand-new stow package, decide whether it should be added to the `STOW_PACKAGES` array in `install.sh`.

## Neovim config

- Config path: `nvim/.config/nvim`
- Framework: **LazyVim** (distro) + **lazy.nvim** (plugin manager)
- Enabled LazyVim extras (in `lua/config/lazy.lua`): `lang.go`, `lang.json`, `lang.yaml`, `lang.terraform`, `lang.python`, `lang.typescript`, `lang.astro`, `lang.docker`, `lang.markdown`, `editor.illuminate`, `test.core`
- Additional extras via `lazyvim.json`: `coding.mini-surround`, `editor.telescope`, `util.project`
- Custom plugin overrides: `lua/plugins/coding.lua`, `lua/plugins/editor.lua`, `lua/plugins/ui.lua`
- **Completion engine is `blink.cmp`**, not `nvim-cmp`. Do not add `nvim-cmp` config.
- Colorscheme: `catppuccin` (mocha flavour)
- Leader key: `<Space>`

## Workflow notes

- After Neovim config changes, run `:Lazy sync` inside Neovim or restart Neovim to pick up changes.
- LSP log: `~/.local/state/nvim/lsp.log` (log level set to `error` in `lua/config/options.lua`).
- Persistent undo dir: `stdpath("state") .. "/undo"` (created automatically).
- `lazy-lock.json` is checked in. `:Lazy sync` updates it; commit the result when plugin versions change intentionally.

## Do / Don't

| Do | Don't |
|---|---|
| Edit files inside the stow package dirs in this repo | Edit symlink targets directly in `$HOME` |
| Run `stow --restow <pkg>` after adding/removing files in a package | Manually create symlinks |
| Keep `lazy-lock.json` in sync after plugin changes | Delete or `.gitignore` the lock file |
| Use `blink.cmp` APIs for completion config | Add `nvim-cmp` configuration |
| Check `install.sh` when adding a new package that should auto-stow | Assume new directories are stowed automatically |
| Verify symlink paths match the intended `$HOME` layout | Add bare files at the package root without the correct directory nesting |

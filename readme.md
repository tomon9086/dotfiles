# dotfiles

Shell configurations for macOS and Linux (Arch Linux, etc.)

## setup

1. Clone this repository into HOME directory.

```bash
git clone git@github.com:tomon9086/mac-dotfiles.git ~/.dotfiles
```

2. Add `source` line to `~/.zshrc`

```console
echo 'source "$HOME/.dotfiles/init.zsh"' >> ~/.zshrc
```

3. Link `.gitignore_global`

```console
mkdir -p ~/.config/git
ln -s ~/.dotfiles/.gitignore_global ~/.config/git/ignore
```

4. Link Neovim config

```console
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

## structure

```
.zshrc                      # User's file (not in repo). Just sources init.zsh
init.zsh                    # Main entry: OS detection + module loader
zsh/
  history.zsh               # History management
  git-prompt.sh             # Git prompt support
  git-completion.zsh        # Git completion for zsh
  prompt.zsh                # Prompt configuration
  pnpm-completion.zsh       # pnpm completion
  ghq.zsh                   # ghq integration
  worktree.zsh              # Git worktree integration
  plugin.zsh                # zplug plugins
  keybind.zsh               # Keybindings
  function.zsh              # Custom functions
  tools/                    # Tool initializations
    common.zsh              #   Cross-platform (anyenv, direnv, etc.)
    macos.zsh               #   macOS (Homebrew)
    linux.zsh               #   Linux
  env/                      # PATH and environment variables
    common.zsh              #   Cross-platform
    macos.zsh               #   macOS-specific paths
    linux.zsh               #   Linux-specific paths
  alias/                    # Aliases
    common.zsh              #   Cross-platform
    macos.zsh               #   macOS (ls -G, gcc-12, etc.)
    linux.zsh               #   Linux (ls --color, etc.)
  completion/               # Completions
    common.zsh              #   Cross-platform
    macos.zsh               #   macOS-specific
```

OS detection is performed in `init.zsh` (sets `DOTFILES_OS` to `macos` or `linux`).
Each module directory contains `common.zsh` (shared) and optional `<OS>.zsh` files.
To add support for a new OS, add a new `<os>.zsh` file in each module directory as needed.

```
nvim/
  init.lua                  # lazy.nvim bootstrap + setup
  lua/
    plugins/
      init.lua              # Plugin definitions
```

## debug

`DOTFILES_DEBUG` を設定すると、各モジュールのロード時間を標準エラー出力に表示します。

```console
DOTFILES_DEBUG=1 zsh
```

出力例:

```
[dotfiles]    3ms  zsh/alias/common.zsh
[dotfiles]    1ms  zsh/alias/macos.zsh
[dotfiles]    5ms  zsh/completion/common.zsh
...
```

シェル起動が遅いときのボトルネック特定に使用します。

## commandline tools

### required

- [zplug](https://github.com/zplug/zplug)
- [fzy](https://github.com/jhawthorn/fzy)
  - to support `enhancd`

### optional

- [custom-commands](https://github.com/tomon9086/custom-commands)
- [gibo](https://github.com/simonwhitaker/gibo)

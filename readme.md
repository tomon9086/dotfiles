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

5. Configure `pet`

Add the following to the `[General]` section of `~/.config/pet/config.toml`:

```toml
Format = "$command [$description] $tags"
SelectCmd = "fzy --prompt=Snippets: "
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

### vvsay（VOICEVOX 読み上げ）

```zsh
vvsay "こんにちは"
vvsay -s 3 "話者 ID を指定して読み上げ"
printf 'こんにちは' | vvsay
```

エンジンの応答を確認し、必要なら次のコンテナを起動して、準備完了後に音声合成・再生を順番に実行します。

```sh
docker run --rm -d --name voicevox -p 127.0.0.1:50021:50021 voicevox/voicevox_engine:cpu-latest
```

Docker 自体は事前に起動してください。起動済みのエンジンを再利用し、起動途中なら最大 60 秒待ちます
（初回のイメージ取得時間は別）。再生が終わると一時音声ファイルを削除します。
macOS では `afplay`、Linux では `paplay` または `aplay` を使います。`curl` が必要です。

話者 ID の既定値は `1`。`export VOICEVOX_SPEAKER=3` で変更できます。
ID は `curl -fsS http://127.0.0.1:50021/speakers` で取得する各スタイルの `id` です。
API の詳細は [VOICEVOX ENGINE](https://github.com/VOICEVOX/voicevox_engine#http-リクエストで音声合成するサンプルコード) を参照してください。
エンジンは次回のために起動したまま残します。停止は `docker stop voicevox`。
ヘルプは `vvsay --help`。

### required

- [zplug](https://github.com/zplug/zplug)
- [fzy](https://github.com/jhawthorn/fzy)
  - to support `enhancd`

### optional

- [custom-commands](https://github.com/tomon9086/custom-commands)
- [gibo](https://github.com/simonwhitaker/gibo)
- [pet](https://github.com/knqyf263/pet)

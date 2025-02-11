# ayrock-nvim

A nvim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
some edits
## Installation

> ⚠️ Backup your previous configuration (if any exists)
#### Requirements

[telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) requires [ripgrep](https://github.com/BurntSushi/ripgrep#installation).

```sh
brew install ripgrep
```

Neovim's configurations are located at `~/.config/nvim`. To clone `ayrock-nvim` to this folder, use the following.

```sh
git clone https://github.com/ayrock-dev/ayrock-nvim.git ~/.config/nvim
```

## Post Installation

Start Neovim via

```sh
nvim
```

The `Lazy` plugin manager will start automatically on the first run and install the configured plugins - as can be seen in the introduction video. After the installation is complete you can press `q` to close the `Lazy` UI and **you are ready to go**! Next time you run nvim `Lazy` will no longer show up.

## Configuration And Extension

- To add plugins, add new file in `lua/ayrock/plugins/*`, which will be auto sourced.

## `Lazy` Usage

- `opts = {}` is the same as calling `setup({})`

## Ayrock Dotfiles

`~/.zshrc`

```
PS1="%n %1~ λ "

alias vim='nvim'
```


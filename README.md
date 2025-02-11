# ayrock-nvim

A nvim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## Installation

> **NOTE** > [Backup](#FAQ) your previous configuration (if any exists)

Requirements:

- Make sure to review the readmes of the plugins if you are experiencing errors. In particular:
  - [ripgrep](https://github.com/BurntSushi/ripgrep#installation) is required for multiple [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.

Neovim's configurations are located at `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim`

To clone ayrock-nvim:

```sh
git clone https://github.com/ayrock-dev/ayrock-nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

## Post Installation

Start Neovim

```sh
nvim
```

The `Lazy` plugin manager will start automatically on the first run and install the configured plugins - as can be seen in the introduction video. After the installation is complete you can press `q` to close the `Lazy` UI and **you are ready to go**! Next time you run nvim `Lazy` will no longer show up.

## Configuration And Extension

- For adding plugins, there are 3 primary options:
  - Add new configuration in `lua/ayrock/plugins/*` files, which will be auto sourced using `lazy.nvim`
    - (uncomment the line importing the `ayrock/plugins` directory in the `init.lua` file to enable this)
  - Modify `init.lua` with additional plugins.
  - Include the `lua/kickstart/plugins/*` files in your configuration.

## `Lazy` Usage

- `opts = {}` is the same as calling `setup({})`

## Ayrock Dotfiles

`~/.zshrc`

```
PS1="%n %1~ λ "

alias vim='nvim'
```

`~/.config/alacritty/alacritty.toml`

```
# https://github.com/folke/tokyonight.nvim/blob/main/extras/alacritty/tokyonight_night.yml
[font]
size = 14.0

[font.normal]
family = "BerkeleyMono Nerd Font"
style = "Regular"

[colors]
# TokyoNight Alacritty Colors

# Default colors
[colors.primary]
background = '0x1a1b26'
foreground = '0xc0caf5'

# Normal colors
[colors.normal]
black =   '0x15161e'
red =     '0xf7768e'
green =   '0x9ece6a'
yellow =  '0xe0af68'
blue =    '0x7aa2f7'
magenta = '0xbb9af7'
cyan =    '0x7dcfff'
white =   '0xa9b1d6'

# Bright colors
[colors.bright]
black =   '0x414868'
red =     '0xf7768e'
green =   '0x9ece6a'
yellow =  '0xe0af68'
blue =    '0x7aa2f7'
magenta = '0xbb9af7'
cyan =    '0x7dcfff'
white =   '0xc0caf5'

[[colors.indexed_colors]]
index = 16
color = '0xff9e64'

[[colors.indexed_colors]]
index = 17
color = '0xdb4b4b'

```

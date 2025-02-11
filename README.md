# ayrock-nvim

A nvim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## Installation

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)

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

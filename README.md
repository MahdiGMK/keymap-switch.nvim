# keymap-switch.nvim

A plugin for Neovim for switching keyboard layout and displaying it in a status line.

### Table of contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Status line](#status-line)
- [Hacks](#hacks)

## Requirements

- Neovim 0.7

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'lostl1ght/keymap-switch.nvim',
  keys = {
    { '<c-\\>', '<plug>(keymap-switch)', mode = { 'i', 'c', 'n' } },
  },
  config = function()
    require('keymap_switch').setup({
      keymap = -- *required*, see :h keymap
      -- other configuration
    })
  end
}
```

## Configuration

Default `setup` values:

```lua
{
  keymap = nil, -- *required*, see :h keymap
  format = function(keymap_name) -- used in provider()
    return keymap_name           -- accepts vim.b.keymap_name
  end,
}
```
### Key mappings

Set key mappings:

```lua
vim.keymap.set({'i', 'n', 'c'}, '<c-\\>', '<plug>(keymap-switch)')
```

## Status line

The plugin exposes 2 functions for a status line plugin:

`condition()` allows hiding the component when layout is not EN:

```lua
require('keymap_switch').condition()
```

`provider()` allows displaying layout, returns `en` when `:h iminsert` is 0:

```lua
require('keymap_switch').provider()
```

These functions can be used in a status line to display whether keymap is active.

For example, with [lualine](https://github.com/nvim-lualine/lualine.nvim):

```lua
require('lualine').setup({
  sections = {
    lualine_z = {
      {
        require('keymap_switch').provider,
        cond = require('keymap_switch').condition,
      }
    }
  }
})
```

## Hacks

In insert/command modes the plugin feeds `:h i_CTRL-^`/`:h c_CTRL-^`
because changing `:h iminsert` directly (like in normal mode)
is not reflected in the status line components until exiting
insert/command modes.

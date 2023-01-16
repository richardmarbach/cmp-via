# cmp-via

## Requirements

- `neovim >= 0.6`
- [`via` cli](https://github.com/richardmarbach/via-cli)

## Installation

### Packer
```lua
use({
  "hrsh7th/nvim-cmp",
  requires = {
    { 
      "richardmarbach/cmp-via" 
      requires = "nvim-lua/plenary.nvim"
    },
  },
})


require('cmp').setup({
  sources = {
    { name = "via" },
  },
})

```


### Vim-Plug
```vim
Plug "nvim-lua/plenary.nvim"
Plug "hrsh7th/nvim-cmp"
Plug "richardmarbach/cmp-github" 

lua << EOF
require('cmp').setup({
  sources = {
    { name = "via" },
  },
})
EOF
```

## Usage

The completion source is only enabeld for `gitcommit` filetypes. Typing `issue: ` or `#` triggers the completion of issues.

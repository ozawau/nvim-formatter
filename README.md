# nvim-formatter

A Neovim plugin for seamless data format conversion, supporting JSON, Python dict, and more with extensible architecture.

## Features

- Convert selected Python dict text to formatted JSON
- Support nested dictionaries and lists
- Automatically convert Python's `True`/`False` to JSON's `true`/`false`
- Maintain proper indentation and formatting
- [Planned] Support more format conversions (YAML, TOML, XML, etc.)

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'ozawau/nvim-formatter',
  config = function()
    -- Optional configuration
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ozawau/nvim-formatter'
```

## Usage

### Commands

The plugin provides `:Py2Json` command, which can be used in normal or visual mode:

- In normal mode: Convert Python dict on current line
- In visual mode: Convert selected Python dict text

### Example

Convert the following Python dict:

```python
{'callback_url': 'http://127.0.0.1:8080', 'attempts': 15, 'hello': 'world'}
```

To formatted JSON:

```json
{
  "callback_url": "http://127.0.0.1:8080",
  "attempts": 15,
  "hello": "world"
}
```

### Keybindings

You can add custom keybindings in your Neovim config:

```vim
" Map <leader>pj to Py2Json command in normal and visual mode
nnoremap <leader>pj :Py2Json<CR>
vnoremap <leader>pj :Py2Json<CR>
```

Or in Lua config:

```lua
vim.keymap.set('n', '<leader>pj', ':Py2Json<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>pj', ':Py2Json<CR>', { noremap = true, silent = true })
```

## Notes

- The plugin uses Lua's `load` function to parse Python dicts, so there might be limitations with very complex dicts
- Ensure your Python dict is properly formatted, otherwise parsing errors may occur

## License

MIT
# nvim-formatter

A Neovim plugin for seamless data format conversion, supporting JSON, Python dict, Unicode sequences and more with extensible architecture.

## Features

- Convert selected Python dict text to formatted JSON
- Convert Unicode escape sequences to readable characters (e.g., `\u4f60\u597d` → `你好`)
- Convert readable characters to Unicode escape sequences (e.g., `你好` → `\u4f60\u597d`)
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

The plugin provides the following commands, which can be used in normal or visual mode:

- `:NfPy2Json` - Convert Python dict to formatted JSON
  - In normal mode: Convert Python dict on current line
  - In visual mode: Convert selected Python dict text
  
- `:NfDeunicode` - Convert Unicode escape sequences to readable characters
  - In normal mode: Convert Unicode on current line
  - In visual mode: Convert Unicode in selected text
  
- `:NfUnicode` - Convert readable characters to Unicode escape sequences
  - In normal mode: Convert text on current line
  - In visual mode: Convert selected text

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

Convert Unicode escape sequences to readable text:

```
{"hello": "\u4f60\u597d"} → {"hello": "你好"}
```

Convert readable text to Unicode escape sequences:

```
{"hello": "你好"} → {"hello": "\u4f60\u597d"}
```

### Keybindings

You can add custom keybindings in your Neovim config:

```vim
" Map <leader>pj to NfPy2Json command in normal and visual mode
nnoremap <leader>pj :NfPy2Json<CR>
vnoremap <leader>pj :NfPy2Json<CR>

" Map <leader>du to NfDeunicode command in normal and visual mode
nnoremap <leader>du :NfDeunicode<CR>
vnoremap <leader>du :NfDeunicode<CR>

" Map <leader>tu to NfUnicode command in normal and visual mode
nnoremap <leader>tu :NfUnicode<CR>
vnoremap <leader>tu :NfUnicode<CR>
```

Or in Lua config:

```lua
vim.keymap.set('n', '<leader>pj', ':NfPy2Json<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>pj', ':NfPy2Json<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>du', ':NfDeunicode<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>du', ':NfDeunicode<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tu', ':NfUnicode<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>tu', ':NfUnicode<CR>', { noremap = true, silent = true })
```

## Module Structure

The plugin is organized with an extensible modular architecture:

- `nvim-formatter` - Main module that imports all formatters
  - `py2json` - Python dict to JSON converter
  - `unicode` - Unicode escape sequence converter
  - (future modules for additional formats)

## Notes

- The plugin uses Lua's pattern matching for conversions
- For Python dict conversion, ensure your dict is properly formatted to avoid parsing errors
- Unicode conversion works with `\uXXXX` format escape sequences

## License

MIT
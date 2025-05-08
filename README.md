# nvim-formatter

一个 Neovim 插件，用于将 Python 字典格式转换为标准 JSON 格式。

## 功能

- 将选中的 Python 字典文本转换为格式化的 JSON
- 支持嵌套的字典和列表
- 自动处理 Python 的 `True`/`False` 转换为 JSON 的 `true`/`false`
- 保持良好的缩进和格式

## 安装

### 使用 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'ozawau/nvim-formatter',
  config = function()
    -- 可选配置
  end
}
```

### 使用 [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ozawau/nvim-formatter'
```

## 使用方法

### 命令

插件提供了 `:Py2Json` 命令，可以在普通模式或可视模式下使用：

- 在普通模式下，转换当前行的 Python 字典
- 在可视模式下，转换选中的 Python 字典文本

### 示例

将以下 Python 字典：

```python
{'callback_url': 'http://127.0.0.1:8080', 'attempts': 15, 'hello': 'world'}
```

转换为格式化的 JSON：

```json
{
  "callback_url": "http://127.0.0.1:8080",
  "attempts": 15,
  "hello": "world"
}
```

### 自定义快捷键

您可以在您的 Neovim 配置中添加自定义快捷键：

```vim
" 在普通模式和可视模式下映射 <leader>pj 到 Py2Json 命令
nnoremap <leader>pj :Py2Json<CR>
vnoremap <leader>pj :Py2Json<CR>
```

或者在 Lua 配置中：

```lua
vim.keymap.set('n', '<leader>pj', ':Py2Json<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>pj', ':Py2Json<CR>', { noremap = true, silent = true })
```

## 注意事项

- 插件使用 Lua 的 `load` 函数解析 Python 字典，因此处理非常复杂的字典时可能会有限制
- 确保您的 Python 字典格式正确，否则可能会导致解析错误

## 许可证

MIT
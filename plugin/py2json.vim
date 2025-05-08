" py2json.vim - 将 Python 字典转换为 JSON 格式
" Maintainer: ozawau
" Version: 1.0

if exists('g:loaded_py2json') | finish | endif
let g:loaded_py2json = 1

" 定义命令
command! -range Py2Json lua require('py2json').convert_to_json()

" 可选：定义快捷键
" 取消下面的注释并修改快捷键以启用
" nnoremap <leader>pj :Py2Json<CR>
" vnoremap <leader>pj :Py2Json<CR>
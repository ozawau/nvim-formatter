" nvim-formatter.vim - 格式化和转换工具
" Maintainer: ozawau
" Version: 1.2

if exists('g:loaded_nvim_formatter') | finish | endif
let g:loaded_nvim_formatter = 1

" Python dict 转 JSON 命令
command! -range NfPy2Json lua require('nvim-formatter').py2json.convert_to_json()

" Unicode 转换命令 - 精确选择模式
command! -range=% NfDeunicode call DeUnicode()
command! -range=% NfUnicode call ToUnicode()

" 将 Unicode 转换为可读字符
function! DeUnicode() range
  " 检查当前模式
  let mode = mode()
  
  " 在视觉模式下处理选中的文本
  if mode ==# 'v' || mode ==# 'V' || mode ==# "\<C-v>"
    " 保存选择范围为寄存器内容
    normal! gvy
    let selected_text = getreg('"')
    
    " 转换文本
    let converted_text = luaeval('require("nvim-formatter").unicode.convert_unicode_text(_A)', selected_text)
    
    " 替换选中的文本
    call setreg('"', converted_text)
    normal! gvp
  else
    " 在普通模式下，处理指定的行范围
    let lines = getline(a:firstline, a:lastline)
    let converted_lines = []
    
    " 逐行转换
    for line in lines
      let converted_line = luaeval('require("nvim-formatter").unicode.convert_unicode_text(_A)', line)
      call add(converted_lines, converted_line)
    endfor
    
    " 替换指定的行
    call setline(a:firstline, converted_lines)
  endif
endfunction

" 将可读字符转换为 Unicode
function! ToUnicode() range
  " 检查当前模式
  let mode = mode()
  
  " 在视觉模式下处理选中的文本
  if mode ==# 'v' || mode ==# 'V' || mode ==# "\<C-v>"
    " 保存选择范围为寄存器内容
    normal! gvy
    let selected_text = getreg('"')
    
    " 转换文本
    let converted_text = luaeval('require("nvim-formatter").unicode.to_unicode_text(_A)', selected_text)
    
    " 替换选中的文本
    call setreg('"', converted_text)
    normal! gvp
  else
    " 在普通模式下，处理指定的行范围
    let lines = getline(a:firstline, a:lastline)
    let converted_lines = []
    
    " 逐行转换
    for line in lines
      let converted_line = luaeval('require("nvim-formatter").unicode.to_unicode_text(_A)', line)
      call add(converted_lines, converted_line)
    endfor
    
    " 替换指定的行
    call setline(a:firstline, converted_lines)
  endif
endfunction

" 可选：定义快捷键
" 取消下面的注释并修改快捷键以启用
" nnoremap <leader>pj :NfPy2Json<CR>
" vnoremap <leader>pj :NfPy2Json<CR>
" nnoremap <leader>du :NfDeunicode<CR>
" vnoremap <leader>du :NfDeunicode<CR>
" nnoremap <leader>tu :NfUnicode<CR>
" vnoremap <leader>tu :NfUnicode<CR>
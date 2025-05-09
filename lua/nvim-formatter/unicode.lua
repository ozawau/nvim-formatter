local M = {}

-- 转换 Unicode 文本字符串（处理选中文本）
function M.convert_unicode_text(text)
  if not text or text == "" then
    return ""
  end
  
  -- 转换 Unicode 序列为可读字符
  local function convert_text(text)
    return text:gsub("\\u(%x%x%x%x)", function(hex)
      local code_point = tonumber(hex, 16)
      if code_point then
        -- 使用 vim.fn.nr2char 替代 utf8.char
        return vim.fn.nr2char(code_point)
      else
        return "\\u" .. hex
      end
    end)
  end
  
  return convert_text(text)
end

-- 将文本字符串转换为 Unicode 序列（处理选中文本）
function M.to_unicode_text(text)
  if not text or text == "" then
    return ""
  end
  
  -- 转换非 ASCII 字符为 Unicode 序列
  local function convert_text(text)
    local result = ""
    local i = 1
    
    while i <= #text do
      local c = text:sub(i, i)
      local b = string.byte(c)
      
      -- 如果是 ASCII 字符 (0-127)，保持不变
      if b < 128 then
        result = result .. c
        i = i + 1
      else
        -- 获取完整的 UTF-8 字符
        local code_point
        local char_len = 0
        
        -- 检测 UTF-8 字符长度
        if b >= 240 then  -- 4 字节 UTF-8
          char_len = 4
        elseif b >= 224 then  -- 3 字节 UTF-8
          char_len = 3
        elseif b >= 192 then  -- 2 字节 UTF-8
          char_len = 2
        else  -- 无效的 UTF-8 字符
          result = result .. c
          i = i + 1
          goto continue
        end
        
        -- 确保字符串足够长
        if i + char_len - 1 > #text then
          result = result .. c
          i = i + 1
          goto continue
        end
        
        -- 获取完整的 UTF-8 字符
        local char = text:sub(i, i + char_len - 1)
        
        -- 使用 Neovim API 获取正确的 Unicode 码点
        -- 这里使用 vim.fn.strgetchar 获取字符的 Unicode 码点
        code_point = vim.fn.strgetchar(char, 0)
        
        -- 格式化为 \uXXXX 格式
        result = result .. string.format("\\u%04x", code_point)
        i = i + char_len
      end
      
      ::continue::
    end
    
    return result
  end
  
  return convert_text(text)
end

-- 将 Unicode 转换为可读字符（兼容旧接口）
function M.convert_unicode(start_line, end_line)
  local api = vim.api
  
  -- 如果没有提供行范围，则获取当前行
  if not start_line or not end_line then
    local current_line = api.nvim_win_get_cursor(0)[1]
    start_line = current_line
    end_line = current_line
  end
  
  -- 获取选中的文本
  local lines = api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- 转换 Unicode 序列为可读字符
  local function convert_line(line)
    -- 使用 Vim 内置函数 nr2char 替换 Unicode 转义序列
    return line:gsub("\\u(%x%x%x%x)", function(hex)
      local code_point = tonumber(hex, 16)
      if code_point then
        -- 使用 vim.fn.nr2char 替代 utf8.char
        return vim.fn.nr2char(code_point)
      else
        return "\\u" .. hex
      end
    end)
  end
  
  -- 转换每一行
  for i, line in ipairs(lines) do
    lines[i] = convert_line(line)
  end
  
  -- 替换选中的文本
  api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

-- 将可读字符转换为 Unicode 序列（兼容旧接口）
function M.to_unicode(start_line, end_line)
  local api = vim.api
  
  -- 如果没有提供行范围，则获取当前行
  if not start_line or not end_line then
    local current_line = api.nvim_win_get_cursor(0)[1]
    start_line = current_line
    end_line = current_line
  end
  
  -- 获取选中的文本
  local lines = api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- 转换非 ASCII 字符为 Unicode 序列
  local function convert_line(line)
    local result = ""
    local i = 1
    
    while i <= #line do
      local c = line:sub(i, i)
      local b = string.byte(c)
      
      -- 如果是 ASCII 字符 (0-127)，保持不变
      if b < 128 then
        result = result .. c
        i = i + 1
      else
        -- 获取完整的 UTF-8 字符
        local code_point
        local char_len = 0
        
        -- 检测 UTF-8 字符长度
        if b >= 240 then  -- 4 字节 UTF-8
          char_len = 4
        elseif b >= 224 then  -- 3 字节 UTF-8
          char_len = 3
        elseif b >= 192 then  -- 2 字节 UTF-8
          char_len = 2
        else  -- 无效的 UTF-8 字符
          result = result .. c
          i = i + 1
          goto continue
        end
        
        -- 确保字符串足够长
        if i + char_len - 1 > #line then
          result = result .. c
          i = i + 1
          goto continue
        end
        
        -- 获取完整的 UTF-8 字符
        local char = line:sub(i, i + char_len - 1)
        
        -- 使用 Neovim API 获取正确的 Unicode 码点
        -- 这里使用 vim.fn.strgetchar 获取字符的 Unicode 码点
        code_point = vim.fn.strgetchar(char, 0)
        
        -- 格式化为 \uXXXX 格式
        result = result .. string.format("\\u%04x", code_point)
        i = i + char_len
      end
      
      ::continue::
    end
    
    return result
  end
  
  -- 转换每一行
  for i, line in ipairs(lines) do
    lines[i] = convert_line(line)
  end
  
  -- 替换选中的文本
  api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

return M 
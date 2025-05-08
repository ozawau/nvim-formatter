local M = {}

-- 将 Python 字典字符串转换为 JSON 字符串
local function python_dict_to_json(str)
  -- 替换 Python 的 True/False/None 为 JSON 的 true/false/null
  str = str:gsub("True", "true")
  str = str:gsub("False", "false")
  str = str:gsub("None", "null")
  
  -- 直接将 Python 字典转换为 JSON
  local result = ""
  local in_string = false
  local escape_next = false
  local quote_type = nil
  
  for i = 1, #str do
    local char = str:sub(i, i)
    
    if escape_next then
      -- 处理转义字符
      if char == "'" or char == '"' then
        result = result .. "\\" .. char
      else
        result = result .. "\\" .. char
      end
      escape_next = false
    elseif char == "\\" then
      -- 下一个字符需要转义
      escape_next = true
    elseif char == "'" or char == '"' then
      if not in_string then
        -- 开始一个新的字符串
        in_string = true
        quote_type = char
        result = result .. '"' -- 使用双引号
      elseif quote_type == char then
        -- 结束当前字符串
        in_string = false
        quote_type = nil
        result = result .. '"' -- 使用双引号
      else
        -- 在字符串内部的另一种引号
        result = result .. char
      end
    elseif char == ":" and not in_string then
      -- 保留冒号作为 JSON 的键值对分隔符
      result = result .. char
    elseif char == "," and not in_string then
      -- 保留逗号作为 JSON 的元素分隔符
      result = result .. char
    elseif char == "{" and not in_string then
      -- 保留左花括号
      result = result .. char
    elseif char == "}" and not in_string then
      -- 保留右花括号
      result = result .. char
    elseif char == "[" and not in_string then
      -- 保留左方括号
      result = result .. char
    elseif char == "]" and not in_string then
      -- 保留右方括号
      result = result .. char
    else
      -- 普通字符
      result = result .. char
    end
  end
  
  return result
end

-- 格式化 JSON 字符串
-- 手动格式化 JSON 字符串
local function format_json_string(json_str)
  local result = ""
  local indent_level = 0
  local in_string = false
  local escape_next = false
  
  for i = 1, #json_str do
    local char = json_str:sub(i, i)
    
    if escape_next then
      result = result .. char
      escape_next = false
    elseif char == '\\' then
      result = result .. char
      escape_next = true
    elseif char == '"' then
      result = result .. char
      if not escape_next then
        in_string = not in_string
      end
    elseif not in_string then
      if char == '{' or char == '[' then
        indent_level = indent_level + 1
        result = result .. char .. '\n' .. string.rep('  ', indent_level)
      elseif char == '}' or char == ']' then
        indent_level = indent_level - 1
        result = result .. '\n' .. string.rep('  ', indent_level) .. char
      elseif char == ',' then
        result = result .. char .. '\n' .. string.rep('  ', indent_level)
      elseif char == ':' then
        result = result .. char .. ' '
      elseif char ~= ' ' and char ~= '\n' and char ~= '\r' and char ~= '\t' then
        result = result .. char
      end
    else
      result = result .. char
    end
  end
  
  return result
end

local function format_json(json_str)
  -- 使用 vim.json 解码和编码 JSON
  local success, data = pcall(vim.json.decode, json_str)
  
  if not success then
    error("无法解析 JSON: " .. tostring(data))
    return nil
  end
  
  -- 使用 vim.json.encode 获取 JSON 字符串，并设置不转义斜杠
  local encoded = vim.json.encode(data)
  
  -- 将转义的斜杠 \/ 替换回普通斜杠 /
  encoded = encoded:gsub("\\/", "/")
  
  -- 手动格式化 JSON
  local formatted = format_json_string(encoded)
  
  return formatted
end

-- 转换选中的文本或当前行
function M.convert_to_json()
  local api = vim.api
  local mode = api.nvim_get_mode().mode
  
  local start_line, end_line
  
  -- 检查是否有选中的文本
  if mode == "v" or mode == "V" or mode == "" then
    -- 获取可视模式的选择范围
    start_line = api.nvim_buf_get_mark(0, "<")[1]
    end_line = api.nvim_buf_get_mark(0, ">")[1]
  else
    -- 如果没有选中文本，则使用当前行
    start_line = api.nvim_win_get_cursor(0)[1]
    end_line = start_line
  end
  
  -- 获取选中的文本
  local lines = api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, " ")
  
  -- 尝试转换 Python 字典为 JSON
  local success, result = pcall(function()
    local json_str = python_dict_to_json(text)
    return format_json(json_str)
  end)
  
  if not success then
    api.nvim_err_writeln("转换失败: " .. tostring(result))
    return
  end
  
  -- 将结果分割为多行
  local json_lines = {}
  for line in string.gmatch(result .. "\n", "(.-)\n") do
    table.insert(json_lines, line)
  end
  
  -- 替换选中的文本
  api.nvim_buf_set_lines(0, start_line - 1, end_line, false, json_lines)
end

return M
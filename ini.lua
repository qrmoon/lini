local ini = {}

function ini.parse(str)
  local config = {}
  local section
  for l in str:gmatch "[^\n]+" do
    if not l:match "^%;" then
      local s = l:match "^%[(.+)%]$"
      if s then
        section = s
        config[section] = {}
      else
        local k, v  = l:match "^(%S+)%s*%=%s*(.+)$"
        if k and v then
          if not section then
            return false, "no section defined"
          end
          v = tonumber(v) or v
          if v == "true" or v == "false" then
            v = not not v
          end
          config[section][k] = v
        else
          return false, "syntax error"
        end
      end
    end
  end

  return config
end

function ini.stringify(t)
  local s = ""
  for sec, data in pairs(t) do
    if type(data) == "table" then
      s = s .. "[" .. sec .. "]\n"
      for k, v in pairs(data) do
        s = s .. k .. " = " .. v .. "\n"
      end
      s = s .. "\n"
    end
  end
  s = s:gsub("\n*$", "")
  return s
end

return ini

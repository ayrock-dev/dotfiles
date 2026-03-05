local M = {}

local yaml_cache = {}
local owner_cache = {}

local function parse_owners_yaml(yaml_path)
  if yaml_cache[yaml_path] then
    return yaml_cache[yaml_path]
  end

  local json_str = vim.fn.system({ 'yq', '-o', 'json', yaml_path })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local ok, parsed = pcall(vim.json.decode, json_str)
  if not ok or not parsed or not parsed.rules then
    return nil
  end

  yaml_cache[yaml_path] = parsed.rules
  return parsed.rules
end

local function glob_to_pattern(glob)
  if glob:sub(1, 2) == './' then
    glob = glob:sub(3)
  end

  local pattern = glob:gsub('([%.%+%-%^%$%(%)%%])', '%%%1')
  pattern = pattern:gsub('%*%*', '\0')
  pattern = pattern:gsub('%*', '[^/]*')
  pattern = pattern:gsub('\0', '.*')

  return '^' .. pattern .. '$'
end

local function matches_any(rel_path, patterns)
  if not patterns then
    return false
  end
  for _, glob in ipairs(patterns) do
    if rel_path:match(glob_to_pattern(glob)) then
      return true
    end
  end
  return false
end

--- @param path string A filepath
--- @return string|nil owner The codeowners name for this filepath
function M.codeowners(path)
  if not path or path == '' then
    return nil
  end

  if owner_cache[path] then
    return owner_cache[path]
  end

  local dir = vim.fn.fnamemodify(path, ':h')
  local owners_files = vim.fs.find('owners.yaml', {
    path = dir,
    upward = true,
    type = 'file',
  })

  for _, owners_path in ipairs(owners_files) do
    local rules = parse_owners_yaml(owners_path)
    if rules then
      local owners_dir = vim.fn.fnamemodify(owners_path, ':h')
      local rel_path = path:sub(#owners_dir + 2)

      for _, rule in ipairs(rules) do
        if matches_any(rel_path, rule.include) and not matches_any(rel_path, rule.exclude) then
          if rule.owners and #rule.owners > 0 then
            owner_cache[path] = rule.owners[1]
            return rule.owners[1]
          end
        end
      end
    end
  end

  return nil
end

function M.invalidate()
  owner_cache = {}
  yaml_cache = {}
end

return M

local Config = require("todo-comments.config")
local Grep = require("fzf-lua.providers.grep")

local M = {}

---@param filter? string|string[]
local function keywords_filter(filter)
  local all = vim.tbl_keys(Config.keywords)
  print("All keywords:", vim.print(all))
  if not filter then
    return all
  end
  local filters = type(filter) == "string" and { filter } or filter
  print("Filters:", vim.print(filters))
  local result = vim.tbl_filter(function(kw)
    return vim.tbl_contains(filters, kw)
  end, all)
  print("Filtered keywords:", vim.print(result))
  return result
end

---@param opts? {keywords: string[]}
function M.todo(opts)
  opts = vim.tbl_extend("force", {
    no_esc = true,
    multiline = true,
  }, opts or {})
  opts.no_esc = true

  print("opts.keywords:", vim.print(opts.keywords))
  local filtered_keywords = keywords_filter(opts.keywords)
  print("filtered_keywords:", vim.print(filtered_keywords))

  opts.search = Config.search_regex(filtered_keywords)
  print("Search regex:", opts.search)
  return Grep.grep(opts)
end

return M

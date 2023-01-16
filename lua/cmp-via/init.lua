local Job = require("plenary.job")

local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })

  self.cache = {
    fetched = false,
    items = {},
  }
  return self
end

---Return the debug name of this source. (Optional)
---@return string
function source:get_debug_name()
  return "via"
end

---@return string
function source:get_keyword_pattern()
  return [[#\?\(\d*\)]]
end

function source:get_trigger_characters()
  return { "#" }
end

---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(_, callback)
  if self.cache.fetched then
    callback(self.cache.items)
  else
    Job:new({
      command = "via",
      args = {
        "issues",
        "assigned",
        "--format",
        "json",
      },
      on_exit = function(j, return_value)
        if return_value ~= 0 then
          self.cache.fetched = true
          vim.notify(string.format("[cmp-via] Failed to fetch via issues: %s", j:result()), vim.log.levels.WARN)
          callback(nil)
          return
        end

        local issues = vim.json.decode(j:result()[1])

        local items = {}
        for _, issue in ipairs(issues) do
          local description = string.sub(issue.description, 0, 500)
          description = string.gsub(description, "\r", "")
          if string.len(issue.description) > 500 then
            description = description .. "..."
          end

          local detail = string.format("[#%s] %s", issue.identifier, issue.title)

          table.insert(items, {
            label = detail,
            detail = detail,
            documentation = { kind = "markdown", value = description },
            insertText = string.format("%s %s\n\n%s", issue.identifier, issue.title, issue.url),
            sortText = string.format("%06d", issue.number),
          })
        end
        self.cache.fetched = true
        self.cache.items = items

        callback(items)
      end,
    }):start()
  end
end

return source.new()

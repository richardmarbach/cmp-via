local Linear = {
  cache = {
    issues = {},
  },
}

Linear.new = function(overrides)
  local self = setmetatable({}, {
    __index = Linear,
  })

  return self
end

local do_request = function(callback, query)
  local token = vim.fn.getenv("LINEAR_API_TOKEN")
  local authorization_header = string.format("Authorization: Bearer %s", token)
  local curl_args = {
    "curl",
    "-s",
    "-H",
    "Accept: application/json",
    "-H",
    authorization_header,
    "--data",
    string.format([[{"query": "%s"}]], query)
  }
end

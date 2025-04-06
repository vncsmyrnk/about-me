local lapis = require("lapis")
local util = require("util")

local app = lapis.Application()

local view_json = function(file_path)
  local json_content = util:read_json(file_path)
  if not json_content then
    return { status = 404, layout = false }
  end

  return { json = json_content }
end

app:get("/api", function()
  return view_json("home")
end)

app:get("/api/:route", function(self)
  return view_json(self.params.route)
end)

return app

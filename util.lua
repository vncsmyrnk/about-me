local cjson = require("cjson")

local util = {}

function util:read_json(file_path)
  print(string.format("./views/%s", file_path))
  local file = io.open(string.format("./views/%s", file_path), "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()
  return cjson.decode(content)
end

return util

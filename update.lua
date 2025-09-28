---@diagnostic disable: undefined-global
-- update.lua — run on the turtle; pulls files from your GitHub repo


---List of files to fetch
local files = {
  {
    url  = "https://raw.githubusercontent.com/Evan1041/computercraft-scripts/main/apps/menril_tree_farm.lua",
    path = "menril_tree_farm.lua"
  }
}

---Download a file via HTTP
---@param u string
---@return string|nil, string|nil
local function fetch(u)
  local h = http.get(u)
  if not h then return nil, "HTTP GET failed" end
  local s = h.readAll()
  h.close()
  return s
end

for _, f in ipairs(files) do
  local body, err = fetch(f.url)
  if not body then
    print(("FAILED: %s (%s)"):format(f.url, tostring(err)))
  else
    local dir = f.path:match("^(.*)/[^/]+$")
    if dir and dir ~= "" and not fs.exists(dir) then
      fs.makeDir(dir)
    end

  local fh = fs.open(f.path, "w")
  if fh then
    fh:write(body)
    fh:close()
end
  end
end

print("Done.")

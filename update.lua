-- update.lua — run on the turtle; pulls files from the web
-- 1) Put raw URLs to your scripts below
-- 2) On the turtle: place update.lua, then run:  update

local files = {
  {
    url  = "https://raw.githubusercontent.com/Evan1041/computercraft-scripts/main/apps/menril_tree_farm.lua",
    path = "menril_tree_farm.lua"
  }
}

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
    if dir and dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end
    local fh = fs.open(f.path, "w"); fh.write(body); fh.close()
    print("Updated: " .. f.path)
  end
end

print("Done.")

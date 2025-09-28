---@meta
-- Minimal ComputerCraft/Turtle API stubs for IntelliSense (not for execution)

---@class Turtle
local turtle = {}
function turtle.forward() end
function turtle.back() end
function turtle.up() end
function turtle.down() end
function turtle.turnLeft() end
function turtle.turnRight() end
function turtle.getFuelLevel() end
---@param count integer|nil
function turtle.refuel(count) end
---@param side integer|nil  -- 0=front,1=up,2=down
function turtle.dig(side) end
---@param side integer|nil
function turtle.attack(side) end
---@param slot integer
function turtle.select(slot) end
function turtle.getSelectedSlot() end
---@param slot integer|nil
function turtle.getItemCount(slot) end
---@param side integer|nil
function turtle.place(side) end
_G.turtle = turtle

local fs = {}
function fs.exists(path) end
function fs.isDir(path) end
function fs.makeDir(path) end
function fs.open(path, mode) end
_G.fs = fs

local http = {}
function http.get(url, body, headers, binary) end
function http.post(url, body, headers, binary) end
_G.http = http

local textutils = {}
function textutils.serialize(t) end
function textutils.unserialize(s) end
_G.textutils = textutils

local os = {}
function os.setComputerLabel(label) end
_G.os = os

-- TODO: fuel and inventory management (maybe seperate module)

-- Block IDs
local MENRIL_LOG_IDS = {
  -- Replace with your real IDs (examples shown):
  ["integrateddynamics:menril_log"] = true,
  ["integrateddynamics:menril_log_filled"] = true
}
local MENRIL_SAPLING_ID = "integrateddynamics:menril_sapling"

-- Distance between Menril trees
local TREE_SPACING = 5

-- Table of farming functions
local TreeFarm = {}

-- Is there a menril log above the turtle?
function TreeFarm.is_menril_above()
  local success, block_data = turtle.inspectUp()
  return success and block_data and MENRIL_LOG_IDS[block_data.name] or false
end

-- Function to check the block in front of the turtle
-- Returns false if encounters air, menril leaves, or other
-- Returns true if a menril log (empty or filled)
function TreeFarm.is_facing_menril_log()
    local success, block_data = turtle.inspect() 
    return success and block_data and MENRIL_LOG_IDS[block_data.name] or false
end

-- Function to mine only menril logs
function TreeFarm.dig_menril_log()
    if TreeFarm.is_facing_menril_log() then
        turtle.dig()
        return true
    end
    return false
end

-- Function to mine in a plus sign pattern from trunk position
function TreeFarm.mine_layer()
  turtle.turnLeft();  TreeFarm.dig_menril_log()
  turtle.turnRight(); TreeFarm.dig_menril_log()
  turtle.turnRight(); TreeFarm.dig_menril_log()
  turtle.turnLeft()
end

-- Function to select item by item ID
function TreeFarm.select_item(id)
  for slot = 1, 16 do
    local detail = turtle.getItemDetail(slot)
    if detail and detail.name == id then
      turtle.select(slot)
      return true
    end
  end
  return false -- not found
end

-- Function to select and place menril sapling
-- Assumes turtle is facing air above dirt/grass block
function TreeFarm.place_sapling()
    if not TreeFarm.select_item(MENRIL_SAPLING_ID) then
        return false -- no sapling found
    end
    return turtle.place() -- place sapling 
end

-- Function to harvest trees
function TreeFarm.harvest_tree()
    -- Mine to tree center
    turtle.dig(); turtle.forward()
    turtle.dig(); turtle.forward()

    -- Mine tree base
    TreeFarm.mine_layer()

    -- Ascend tree, mining logs
    local trunk_height = 0
    while TreeFarm.is_menril_above() do
        turtle.digUp()
        turtle.up()

        -- Mine tree layer
        TreeFarm.mine_layer()

        -- Update turtle height
        trunk_height = trunk_height + 1
    end

    -- Descend back to ground level
    for _ = 1, trunk_height do
        turtle.down()
    end

    -- Collect items from decayed leaves that landed on the tree base
    turtle.turnLeft();  turtle.suck()
    turtle.turnRight(); turtle.suck()
    turtle.turnRight(); turtle.suck()
    turtle.turnRight(); turtle.suck(); turtle.forward()
    turtle.turnRight(); turtle.turnRight(); turtle.suck()

    -- Plant sapling
    if not TreeFarm.place_sapling() then -- Plant sapling
        print("Warning: No sapling found!")
    end

    -- Turn around and return to traversal line
    turtle.turnRight(); turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
    return true
end 

-- Function to check left block for menril logs and harvests tree if found
function TreeFarm.check_for_tree()
    turtle.turnLeft()
    if TreeFarm.is_facing_menril_log() then
        -- Found a tree
        TreeFarm.harvest_tree()
        return true
    end
    -- Didn't find a tree
    turtle.turnRight()
    return false
end

function TreeFarm.return_to_start(distance)
    turtle.turnRight()
    turtle.turnRight()
    for _ = 1, distance do
        turtle.forward()
    end
    turtle.turnRight()
    turtle.turnRight()
end

-- Traverses tree line, harvesting trees
-- Stops when encounters block along path parallel to tree line
function TreeFarm.traverse_tree_line()
    local distance = 0
    while true do
        -- Check for block in front of turtle
        local success = turtle.detect() 
        if success then break end -- end harvest

        -- Check for tree on left side and harvest if found
        TreeFarm.check_for_tree()
        
        -- Move to next tree location
        for _ = 1, TREE_SPACING do
            turtle.forward()
            distance = distance + 1
        end
    end
    -- Return to start of tree line
    TreeFarm.return_to_start(distance)
end

return TreeFarm
local collision_mask_util = require "__core__.lualib.collision-mask-util"


-- how far to look for land/water when deploying/undeploying
local placement_box_size = 2



-- Getting into the life raft

local function is_boatable_tile(tile)
    local boat_mask = collision_mask_util.get_mask(game.entity_prototypes["LR-life-raft"])
    local tile_mask = collision_mask_util.get_mask(game.tile_prototypes[tile.name])

    -- IDK why I couldn't use collision_mask_util.mask_collides
    for k, v in pairs(boat_mask) do
        if tile_mask[k] then
            return false
        end
    end
    return true
end

local function get_deployable_position(player)
    if is_boatable_tile(player.surface.get_tile(player.position)) then
        return player.position
    end

    local adjacent_tiles = player.surface.find_tiles_filtered {
        area = {
            { player.position.x - placement_box_size, player.position.y - placement_box_size },
            { player.position.x + placement_box_size, player.position.y + placement_box_size } }
    }

    for _, t in pairs(adjacent_tiles) do
        if is_boatable_tile(t) then
            return t.position
        end
    end

    return nil
end

function try_deploy_life_raft(player)
    local pos = get_deployable_position(player)

    if (pos == nil) then
        player.create_local_flying_text { text = "No water nearby", position = player.position }
        return
    end

    local life_raft = player.surface.create_entity {
        name = "LR-life-raft",
        position = pos,
        force = player.force,
        direction = player.character.direction
    }

    life_raft.set_driver(player)
    player.set_shortcut_toggled("LR-toggle-life-raft", true)
    player.create_local_flying_text { text = "Splash", position = player.position }
end

-- Getting out of the life raft

local function is_walkable_tile(player, tile)
    local player_mask = collision_mask_util.get_mask(game.entity_prototypes[player.character.name])
    local tile_mask = collision_mask_util.get_mask(game.tile_prototypes[tile.name])

    -- IDK why I couldn't use collision_mask_util.mask_collides
    for k, v in pairs(player_mask) do
        if tile_mask[k] then
            return false
        end
    end
    return true
end

local function get_exit_position(player)
    if is_walkable_tile(player, player.surface.get_tile(player.position)) then
        return player.position
    end

    local adjacent_tiles = player.surface.find_tiles_filtered {
        area = {
            { player.position.x - placement_box_size, player.position.y - placement_box_size },
            { player.position.x + placement_box_size, player.position.y + placement_box_size } }
    }

    for _, t in pairs(adjacent_tiles) do
        if is_walkable_tile(player, t) then
            return t.position
        end
    end

    return nil
end

function try_undeploy_life_raft(player)
    if player.vehicle and player.vehicle.name ~= "LR-life-raft" then
        return
    end

    local pos = get_exit_position(player)

    if (pos == nil) then
        player.create_local_flying_text { text = "No land nearby", position = player.position }
        return
    end

    local life_raft = player.vehicle
    life_raft.set_driver(nil)
    player.teleport(pos)
    life_raft.destroy()
    player.set_shortcut_toggled("LR-toggle-life-raft", false)
end

-- event handler

script.on_event({ defines.events.on_lua_shortcut, "LR-toggle-life-raft" },
    function(event)

        if event.prototype_name and event.prototype_name ~= "LR-toggle-life-raft" then return end

        local player = game.get_player(event.player_index) -- get the player that moved

        if player.vehicle then
            try_undeploy_life_raft(player)
        else
            try_deploy_life_raft(player)
        end
    end
)

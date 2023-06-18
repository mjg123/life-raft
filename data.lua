-- data.lua


local model = settings.startup["LR-visual"].value
-- https://sketchfab.com/3d-models/pool-floatie-flamingo-af6ca88ada3842a382aea10163e875a5
-- https://sketchfab.com/3d-models/liferaft-2ad5665f82e946d6b092dddfdb4f318f

local life_raft = table.deepcopy(data.raw.car.car)
life_raft.name = "LR-life-raft"
life_raft.collision_mask = { "ground-tile", "train-layer", "consider-tile-transitions" }
life_raft.collision_box = { { -1, -1 }, { 1, 1 } }
life_raft.selection_box = nil
life_raft.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
life_raft.rotation_speed = 0.01
life_raft.inventory_size = 0
life_raft.working_sound = nil
life_raft.icon = "__life-raft__/graphics/" .. model .. "-icon.png"
life_raft.icon_size = 64
life_raft.minable = nil
life_raft.operable = true
life_raft.destructible = false
life_raft.guns = nil
life_raft.turret_animation = nil
life_raft.energy_source = { type = "void", emissions = 0 }
life_raft.consumption = settings.startup["LR-speed"].value .. "kW"
life_raft.is_military_target = false
life_raft.tank_driving = true
life_raft.allow_passengers = true
life_raft.light = nil
life_raft.light_animation = nil
life_raft.track_particle_triggers = { {
    tiles = { "water", "water-shallow" },
    use_as_default = true,
    actions = {
        {
            type = "create-particle",
            particle_name = "shallow-water-vehicle-particle",
            initial_height = 0.2,
            offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } }
        }
    }
} }

life_raft.animation = {
    layers = {
        {
            slice = 1,
            priority = "low",
            width = 512,
            height = 512,
            direction_count = 64,
            filename = "__life-raft__/graphics/" .. model .. ".png",
            line_length = 8,
            lines_per_file = 8,
            shift = util.by_pixel(0, 0),
            scale = 0.3,
            max_advance = 0.2
        },
        {
            priority = "low",
            animation_speed = 0.6,
            size = { 44, 66 },
            direction_count = 8,
            frame_count = 1,
            filename = "__base__/graphics/entity/character/level1_running.png",
            line_length = 22,
            lines_per_file = 8,
            scale = 1,
            shift = { 0, -0.5625 },
            max_advance = 0.2
        },
        {
            priority = "low",
            animation_speed = 0.6,
            size = { 40, 56 },
            direction_count = 8,
            frame_count = 1,
            filename = "__base__/graphics/entity/character/level1_running_mask.png",
            line_length = 22,
            lines_per_file = 8,
            scale = 1,
            shift = { 0, -0.5625 },
            apply_runtime_tint = true,
            max_advance = 0.2
        },
        {
            slice = 1,
            priority = "low",
            width = 512,
            height = 512,
            direction_count = 64,
            filename = "__life-raft__/graphics/" .. model .. "-shadows.png",
            line_length = 8,
            lines_per_file = 8,
            shift = util.by_pixel(0, 0),
            scale = 0.3,
            max_advance = 0.2,
            draw_as_shadow = true
        }
    }
}
life_raft.water_reflection = {
    pictures = {
        filename = "__life-raft__/graphics/" .. model .. "-water-reflection.png",
        width = 60,
        height = 60,
        shift = util.by_pixel(0, 10),
        variation_count = 1,
        scale = 2.2
    },
    rotate = false,
    orientation_to_variation = false
}

data:extend {
    { -- shortcut icon
        name = "LR-toggle-life-raft",
        type = "shortcut",
        action = "lua",
        associated_control_input = "LR-toggle-life-raft",
        toggleable = true,
        icon = {
            filename = "__life-raft__/graphics/" .. model .. "-icon.png",
            size = 64
        }
    },
    { -- keyboard input
        type = "custom-input",
        name = "LR-toggle-life-raft",
        localised_name = { "shortcut-name.LR-toggle-life-raft" },
        key_sequence = "ALT + L",
        order = "a",
    },
    life_raft
}

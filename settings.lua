--[[

  settings.lua

  Abbreviations:

    LR - Life Raft

  Todo:

    Setting for allowing deliberate disembarkation of a vehicle over water?

--]]

data:extend({
    {
        type = "double-setting",
        name = "LR-speed",
        setting_type = "startup",
        minimum_value = 0.01,
        maximum_value = 10,
        default_value = 4,
        order = "a"
    },
    {
        type = "string-setting",
        name = "LR-visual",
        setting_type = "startup",
        default_value = "life-raft",
        allowed_values = { "life-raft", "pink-flamingo" },
        order = "b"
    },
    {
        type = "bool-setting",
        name = "LR-wind-drift",
        setting_type = "startup",
        default_value = true,
        order = "c"
    },
})

-- Import utility functions
nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
inspect = dofile(SMODS.current_mod.path .. "/inspect.lua")

local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.nof_garden_card = {
        suit = nil, 
        ranks = {}
    }
    ret.nof_disable_play = false
    ret.nof_disable_discard = false
    return ret
end

local originalCardInit = Card.init
function Card:init(X, Y, W, H, card, center, params)
    originalCardInit(self, X, Y, W, H, card, center, params)

    self.charged = false  -- New property for the card
end

-- Create an atlas for cards to use
SMODS.Atlas {
    key = "NofJokers_atlas",
    path = "NofJokers.png",
    px = 71,
    py = 95
}

-- List all Joker files here
local joker_files = {
    "spring_winds",
    "leafy_dew",
    "dowsing_rod",
    "garden_plot",
    "medical_melody",
    "stomp",
    "sickle",
}

-- List all Joker files here
local audio_files = {
    "stomp_medium",
    "take_aim",
    "fish_right",
    "fish_wrong",
    "fish_wrong_back",
    "charge_ready",
    "charge_slash",
    "dew_use",
    "dew_plant",
    "flute_1",
    "flute_2",
    "flute_3",
    "flute_4",
    "flute_5",
    "flute_6",
    "flute_7",
    "flute_8",
}

-- Jokers that shall be removed if another copy is added
unique_jokers = {
    "j_nof_garden_plot"
}

-- Load and register Jokers using the utility function
for _, filename in ipairs(joker_files) do
    local joker = nof_utils.load_joker(filename)
    SMODS.Joker(joker)
end

-- Load and register Sounds
for _, filename in ipairs(audio_files) do
    SMODS.Sound({
        key = filename,
        path = filename..'.wav',
    })
end

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end

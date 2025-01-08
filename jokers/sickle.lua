local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
local inspect = dofile(SMODS.current_mod.path .. "/inspect.lua")

return {
    key = "sickle",
    loc_txt = {
        name = "",
        text = {}
    },
    config = {
        extra = {
            is_active = false,
            extra_hands_usage = 1,
        }
    },
    rarity = 3,
    pos = { x = 1, y = 3 },
    atlas = "NofJokers_atlas",
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.is_active and localize('nof_active') or localize('nof_inactive'),
                center.ability.extra.extra_hands_usage,
            }
        }
    end,    

    calculate = function (self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            if G.GAME.current_round.hands_left >= 2 then
                card.ability.extra.is_active = true

                local eval = function(card) return (card.ability.extra.is_active) end
                juice_card_until(card, eval, true)
            end
        end
    end
}
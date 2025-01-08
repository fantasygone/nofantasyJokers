local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
return {
    key = "medical_melody",
    loc_txt = {
        name = "",
        text = {},
    },
    config = {
        extra = {
            limit = 8,
            played = 0
        }
    },
    rarity = 2,
    pos = { x = 1, y = 1 },
    atlas = "NofJokers_atlas",
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = { 
                center.ability.extra.limit,
                center.ability.extra.played,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.after and context.scoring_hand and not context.blueprint then
            for _, c in ipairs(context.scoring_hand) do
                if not c.debuff then
                    card.ability.extra.played = card.ability.extra.played + 1
                end
            end

            if card.ability.extra.played >= card.ability.extra.limit then
                local cardsToRestore = {}

                local function restore_debuff(cards)
                    for _, c in ipairs(cards) do
                        if c.debuff then
                            table.insert(cardsToRestore, c)
                        end
                    end
                end

                -- restore_debuff(G.play.cards)
                restore_debuff(G.hand.cards)
                restore_debuff(G.jokers.cards)

                if #cardsToRestore > 0 then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        for i = 1, card.ability.extra.played do
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.35,func = function()
                                play_sound('nof_flute_' .. math.random(1, 8))
                            return true end }))
                        end

                        G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function()
                            for _, c in ipairs(cardsToRestore) do
                                c.debuff = false
                                if c.ability and c.ability.perishable then 
                                    c.ability.perish_tally = 3
                                end
                                c:juice_up(0.3, 0.3)
                            end

                            card.ability.extra.played = 0
                        return true end }))

                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_restored'), colour = G.C.GREEN})
                    return true end }))
                end
            end
        end
    end
}
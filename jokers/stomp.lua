local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
return {
    key = "stomp",
    loc_txt = {
        name = "",
        text = {},
    },
    config = {
        extra = {
            incremental = 1,
            current = 0,
            limit = 4,
            copied = 0,
            true_eternal = false
        }
    },
    rarity = 2,
    pos = { x = 1, y = 2 },
    atlas = "NofJokers_atlas",
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'nof_do_not_disturb', set = 'Other'}
        return {
            vars = { 
                center.ability.extra.incremental,
                center.ability.extra.current + center.ability.extra.copied,
                center.ability.extra.limit
            }
        }
    end,

    calculate = function (self, card, context)
        if context.pre_discard and card.ability.extra.current ~= card.ability.extra.limit then
            if not context.blueprint then
                if card.ability and not card.ability.eternal then
                    card:set_eternal(true)
                else
                    if not card.ability.extra.true_eternal and card.ability.extra.current == 0 then card.ability.extra.true_eternal = true end
                end
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.incremental
            else
                card.ability.extra.copied = card.ability.extra.copied + card.ability.extra.incremental
            end

            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+" .. card.ability.extra.incremental .. " " .. localize('nof_hand_size')})
            G.hand:change_size(card.ability.extra.incremental)
        end

        if context.before and not context.after and context.scoring_hand and card.ability.extra.current > 0 then
            -- Remove twice if blueprint
            G.hand:change_size(-(card.ability.extra.current + card.ability.extra.copied))
            card.ability.extra.current = 0
            card.ability.extra.copied = 0

            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_stomp'), colour = G.C.RED, sound = 'nof_stomp_medium'})

            if not card.ability.extra.true_eternal then
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.5,func = function()
                    card:juice_up(0.5, 0.5)
                    card:set_eternal(false)
                return true end }))
            end
        end
    end
}
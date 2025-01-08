local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
return {
    key = "leafy_dew",
    loc_txt = {
        name = "",
        text = {}
    },
    config = {
        extra = {
            suit_spade =   'Spades',
            suit_heart =   'Hearts',
            suit_club =    'Clubs',
            suit_diamond = 'Diamonds',
            sold_spade =    3,   --Sap sell value in Spring Hamlet DONE
            sold_heart =    3,   --Summer Bar DONE
            sold_club =     2,   --Winter Glade
            sold_diamond =  4,   --Autumn Town DONE
        }
    },
    rarity = 1,
    pos = { x = 0, y = 2 },
    atlas = "NofJokers_atlas",
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                localize(center.ability.extra.suit_spade, 'suits_singular'),
                localize(center.ability.extra.suit_heart, 'suits_singular'),
                localize(center.ability.extra.suit_club, 'suits_singular'),
                localize(center.ability.extra.suit_diamond, 'suits_singular'),
                center.ability.extra.sold_spade,
                center.ability.extra.sold_heart,
                center.ability.extra.sold_club,
                center.ability.extra.sold_diamond,
            }
        }
    end,

    calculate = function (self, card, context)
        if (context.cards_destroyed or context.remove_playing_cards) and not context.individual and not context.repetition and not context.before and not context.after then
            local money_gained = 0
            local card_suit = ""
            local garden_joker = nil

            for k, v in ipairs(context.glass_shattered and context.cards_destroyed or context.removed) do
                if v:is_suit("Spades") then
                    money_gained = money_gained + card.ability.extra.sold_spade
                    card_suit = "Spades"
                end
                if v:is_suit("Hearts") then
                    money_gained = money_gained + card.ability.extra.sold_heart
                    card_suit = "Hearts"
                end
                if v:is_suit("Clubs") then
                    money_gained = money_gained + card.ability.extra.sold_club
                    card_suit = "Clubs"
                end
                if v:is_suit("Diamonds") then
                    money_gained = money_gained + card.ability.extra.sold_diamond
                    card_suit = "Diamonds"
                end
            end

            if (next(SMODS.find_card("j_nof_garden_plot"))) then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        local prev_card = G.jokers.cards[i - 1]
                        local next_card = G.jokers.cards[i + 1]
                        if prev_card and prev_card.ability.name == "j_nof_garden_plot" then
                            garden_joker = prev_card
                        elseif next_card and next_card.ability.name == "j_nof_garden_plot" then
                            garden_joker = next_card
                        end
                        break
                    end
                end
            end

            if money_gained > 0 then
                if not garden_joker then
                    ease_dollars(money_gained)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_sold'), colour = G.C.MONEY, sound = 'nof_dew_use'})
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_planted'), colour = G.C.GREEN, sound = 'nof_dew_plant'})
                        nof_utils.flip_cards({garden_joker}, "before", 0)
        
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                        G.GAME.nof_garden_card.suit = card_suit
                        if card_suit == "Spades" then
                            garden_joker.children.center:set_sprite_pos({x = 3, y = 4})
                        elseif card_suit == "Hearts" then
                            garden_joker.children.center:set_sprite_pos({x = 1, y = 4})
                        elseif card_suit == "Clubs" then
                            garden_joker.children.center:set_sprite_pos({x = 2, y = 4})
                        else
                            garden_joker.children.center:set_sprite_pos({x = 4, y = 4})
                        end
                    return true end }))
    
                    nof_utils.unflip_cards({garden_joker}, "after", 0.15)
                end
            end
        end
    end
}
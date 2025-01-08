local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
local inspect = dofile(SMODS.current_mod.path .. "/inspect.lua")

return {
    key = "dowsing_rod",
    loc_txt = {
        name = "Dowsing Rod",
        text = {
            "After first hand drawn,",
            "randomly select {C:green}#1#{},", "{C:green}#2# or #3#{} cards and",
            "{C:green}#4# in #5#{} chance to either",
            "increase/decrease their rank",
            "or change their suit",
            "{C:inactive}(Keeps applying chance until{}",
            "{C:red}#6#{} {C:inactive}failed attempts){}",
        }
    },
    config = {
        extra = {
            selected_cards = {3, 4, 7},
            odds = 4,
            attempts = 9
        }
    },
    rarity = 2,
    pos = { x = 0, y = 3 },
    atlas = "NofJokers_atlas",
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.selected_cards[1],
                center.ability.extra.selected_cards[2],
                center.ability.extra.selected_cards[3],
                ''..(G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds,
                center.ability.extra.attempts,
            }
        }
    end,    

    calculate = function (self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                if #G.hand.cards > 0 then
                    G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0, func = function() 
                        G.GAME.nof_disable_discard = true
                        G.GAME.nof_disable_play = true
                    return true end }))

                    local _cards = {}
                    for k, v in ipairs(G.hand.cards) do
                        _cards[#_cards + 1] = v
                    end

                    local cardsOdd = pseudorandom('dowsingrod')
                    local numberOfCards = 0
                    local hookedCards = {}

                    if cardsOdd <= 0.7 then
                        numberOfCards = card.ability.extra.selected_cards[1]
                    elseif cardsOdd <= 0.9 then
                        numberOfCards = card.ability.extra.selected_cards[2]
                    else
                        numberOfCards = card.ability.extra.selected_cards[3]
                    end

                    if numberOfCards > #_cards then numberOfCards = #_cards end

                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = numberOfCards.." "..localize('nof_bait'), colour = G.C.BLUE, sound = 'nof_take_aim'})

                    for i=1, numberOfCards do
                        local selected = pseudorandom_element(_cards, pseudoseed('dowsingrod'))
                        table.insert(hookedCards, selected)

                        -- Find the selected card in _cards and remove it
                        for j = 1, #_cards do
                            if _cards[j] == selected then
                                table.remove(_cards, j) -- Remove the selected card from _cards
                                break -- Exit the loop once the card is found and removed
                            end
                        end
                    end

                    for i=1, #hookedCards do
                        local percent = 1.15 - (i-0.999)/(#hookedCards-0.998)*0.3
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() hookedCards[i]:flip();play_sound('card1', percent);hookedCards[i]:juice_up(0.3, 0.3);return true end }))
                    end

                    delay(0.5)

                    local remaining_attempts = card.ability.extra.attempts
                    for i = 1, #hookedCards do
                        if remaining_attempts <= 0 then
                            break -- Stop if no attempts are left
                        end

                        local hooked_card = hookedCards[i]
                        local success = false -- Tracks if the effect is successfully applied

                        -- Try applying the effect up to the remaining attempts
                        for attempt = 1, remaining_attempts do
                            if pseudorandom('dowsingrod_individual') < G.GAME.probabilities.normal/card.ability.extra.odds then
                                success = true -- Effect succeeds
                                break -- Exit the retry loop for this card
                            else
                                remaining_attempts = remaining_attempts - 1 -- Deduct 1 attempt

                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = remaining_attempts.." "..localize("nof_attempts_left"), colour = G.C.RED, sound = 'nof_fish_wrong'})
                                if remaining_attempts <= 0 then
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("nof_rod_fail"), colour = G.C.RED, sound = 'nof_fish_wrong_back'})
                                    break -- Stop retrying if no attempts are left
                                end
                            end
                        end

                        -- Apply the effect or leave the card unaffected
                        if success then
                            -- Add juice animation or sound effect
                            G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function() hooked_card:juice_up(0.3, 0.3);return true end }))

                            -- Apply the effect (e.g., modify rank or suit)
                            local random_effect = pseudorandom('dowsingrod_effect')
                            if random_effect < 0.25 then
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("nof_r_down"), colour = G.C.GREEN, sound = 'nof_fish_right'})
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                                    local card = hooked_card
                                    local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                                    local rank_suffix = card.base.id == 2 and 14 or math.max(card.base.id - 1, 2)
                                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                                    elseif rank_suffix == 10 then rank_suffix = 'T'
                                    elseif rank_suffix == 11 then rank_suffix = 'J'
                                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                                    elseif rank_suffix == 13 then rank_suffix = 'K'
                                    elseif rank_suffix == 14 then rank_suffix = 'A'
                                    end
                                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                                    return true
                                end}))
                            elseif random_effect < 0.5 then
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("nof_r_up"), colour = G.C.GREEN, sound = 'nof_fish_right'})
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                                    local card = hooked_card
                                    local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                                    local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                                    elseif rank_suffix == 10 then rank_suffix = 'T'
                                    elseif rank_suffix == 11 then rank_suffix = 'J'
                                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                                    elseif rank_suffix == 13 then rank_suffix = 'K'
                                    elseif rank_suffix == 14 then rank_suffix = 'A'
                                    end
                                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                                return true end }))
                            elseif random_effect < 0.75 then
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("nof_s_next"), colour = G.C.GREEN, sound = 'nof_fish_right'})
                                if hooked_card:is_suit("Spades") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Hearts');return true end }))
                                elseif hooked_card:is_suit("Hearts") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Clubs');return true end }))
                                elseif hooked_card:is_suit("Clubs") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Diamonds');return true end }))
                                else
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Spades');return true end }))
                                end
                            else
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("nof_s_prev"), colour = G.C.GREEN, sound = 'nof_fish_right'})
                                if hooked_card:is_suit("Spades") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Diamonds');return true end }))
                                elseif hooked_card:is_suit("Hearts") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Spades');return true end }))
                                elseif hooked_card:is_suit("Clubs") then
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Hearts');return true end }))
                                else
                                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() hooked_card:change_suit('Clubs');return true end }))
                                end
                            end
                        end
                    end

                    for i=1, #hookedCards do
                        local percent = 0.85 + (i-0.999)/(#hookedCards-0.998)*0.3
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() hookedCards[i]:flip();play_sound('tarot2', percent, 0.6);hookedCards[i]:juice_up(0.3, 0.3);return true end }))
                    end

                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function() 
                        G.GAME.nof_disable_discard = false
                        G.GAME.nof_disable_play = false
                    return true end }))
                end
            return true end }))
        end
    end
}
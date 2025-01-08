local nof_utils = dofile(SMODS.current_mod.path .. "/nofantasy-utils.lua")
local inspect = dofile(SMODS.current_mod.path .. "/inspect.lua")

return {
    key = "spring_winds",
    loc_txt = {
        name = "Spring Winds",
        text = {
            "Every #3# hands played,",
            "cards still held in hand",
            "after {C:green}#1#{} hand played",
            "will trigger {C:green}#2#{} more time",
            "when held in hand or played",
            "{C:inactive}(Activates in: #4#){}",
        }
    },
    config = {
        extra = {
            hands_played = 1,
            retriggers = 1,
            hands_cd = 2,
            cd = 0
        }
    },
    rarity = 3,
    pos = { x = 0, y = 1 },
    atlas = "NofJokers_atlas",
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.hands_played,
                center.ability.extra.retriggers,
                center.ability.extra.hands_cd,
                center.ability.extra.cd == -1 and localize('nof_now') or center.ability.extra.cd .. " " .. localize("nof_hands"),
            }
        }
    end,

    calculate = function (self, card, context)
        local function handle_card_area(card_area, cd_value)
            return context.repetition and context.cardarea == card_area and card.ability.extra.cd == cd_value
        end
    
        local function handle_common_logic()
            if context.other_card.charged then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra.retriggers,
                    card = card,
                    sound = 'nof_charge_slash'
                }
            end
        end

        local function remove_charged(hand_area)
            for i = 1, #hand_area do
                if hand_area[i].charged then hand_area[i].charged = false end
            end
        end
    
        -- for played cards
        if handle_card_area(G.play, -1) then
            return handle_common_logic()
        end
    
        -- for cards held in hand during the round or at the end of the round
        if handle_card_area(G.hand, -1) or (context.end_of_round and handle_card_area(G.hand, card.ability.extra.hands_cd)) then
            if next(context.card_effects[1]) or #context.card_effects > 1 then
                return handle_common_logic()
            end
        end

        if context.after and not context.before and not context.blueprint then
            if card.ability.extra.cd == -1 then 
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                    card.ability.extra.cd = card.ability.extra.hands_cd
                    remove_charged(G.play.cards)
                    remove_charged(G.hand.cards)
                return true end }))
                return
            else
                card.ability.extra.cd = card.ability.extra.cd - 1
            end

            if card.ability.extra.cd ~= -1 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_recharging'), colour = G.C.GREEN})
            else
                local evalJoker = function(joker) return (joker.ability.extra.cd == -1) end
                local evalPlayingCard = function(playing_card) return (card.ability.extra.cd == -1 and playing_card.charged) end

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('nof_charged'), colour = G.C.GREEN, sound = 'nof_charge_ready'})

                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                    for i = 1, #G.hand.cards do
                        G.hand.cards[i].charged = true
                        juice_card_until(G.hand.cards[i], evalPlayingCard, true)
                    end

                    juice_card_until(card, evalJoker, true)
                return true end }))
            end
        end
    end
}
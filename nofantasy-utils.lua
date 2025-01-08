local nof_utils = {}

-- Helper function to load all Joker files
function nof_utils.load_joker(filename)
    return dofile(SMODS.current_mod.path .. "/jokers/" .. filename .. ".lua")
end

-- Helper function to load all Sound files
function nof_utils.load_sound(filename)
    return dofile(SMODS.current_mod.path .. "/assets/sounds/" .. filename .. ".wav")
end

function nof_utils.loadJokers(joker_files)
    for _, filename in ipairs(joker_files) do
        local joker = nof_utils.load_joker(filename)
        SMODS.Joker(joker)
    end
end

function nof_utils.contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function nof_utils.unscore_cards(play_cards, scoring_hand)
    -- Loop through play_cards
    for _, card in ipairs(play_cards) do
        -- If the card is not in scoring_hand, mark it as unscored
        if not contains(scoring_hand, card) then
            card.unscored = true
        end
    end
end

function nof_utils.flip_cards(table, trigger, delay)
    for i=1, #table do
        local percent = 1.15 - (i-0.999)/(#table-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() table[i]:flip();play_sound('card1', percent);table[i]:juice_up(0.3, 0.3);return true end }))
    end
end

function nof_utils.unflip_cards(table, trigger, delay)
    for i=1, #table do
        local percent = 0.85 + (i-0.999)/(#table-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() table[i]:flip();play_sound('tarot2', percent, 0.6);table[i]:juice_up(0.3, 0.3);return true end }))
    end
end

function nof_utils.count_jokers(name, table)
    local count = 0
    local index = 0
    for i = 1, #table do
        if table[i].ability.name == name then
            count = count + 1
            index = i
        end
    end
    return count, index
end

-- Function to filter cards by suit
function nof_utils.get_cards_by_suit(cards_pool, suit)
    local filtered = {}
    for key, card in pairs(cards_pool) do
        if card.suit == suit and not nof_utils.contains(G.GAME.nof_garden_card.ranks, card.value) then
            table.insert(filtered, card)
        end
    end
    return filtered
end

return nof_utils
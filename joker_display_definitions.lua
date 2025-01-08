local jd_def = JokerDisplay.Definitions

jd_def["j_nof_leafy_dew"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { text = "(if destroyed)" },
    },
    reminder_text_config = { scale = 0.25 },

    calc_function = function(card)
        local dollars = 0
        local hand = G.hand.highlighted

        for _, playing_card in pairs(hand) do
            if playing_card:is_suit("Spades") then
                dollars = dollars + card.ability.extra.sold_spade
            end
            if playing_card:is_suit("Hearts") then
                dollars = dollars + card.ability.extra.sold_heart
            end
            if playing_card:is_suit("Clubs") then
                dollars = dollars + card.ability.extra.sold_club
            end
            if playing_card:is_suit("Diamonds") then
                dollars = dollars + card.ability.extra.sold_diamond
            end
        end

        if hand == 1 then

        end

        card.joker_display_values.dollars = dollars > 0 and dollars or 0
    end
}
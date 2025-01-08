calculate = function(self, card, context)
    if context.joker_main then
        local has_ace = false
        local has_ten = false

        for _, hand_card in ipairs(G.play.cards) do
            if hand_card:get_id() == 14 then
                has_ace = true
            elseif hand_card:get_id() == 10 then
                has_ten = true
            end

            if has_ace and has_ten then
                break
            end
        end

        if has_ace and has_ten then
            local result = {}

            for i = 1, #G.jokers.cards do
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
            end

            return result
        end
    end
end
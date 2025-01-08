return {
    key = "garden_plot",
    loc_txt = {
        name = "",
        text = {}
    },
    config = {extra_picks = 1},
    rarity = 3,
    pos = { x = 0, y = 4 },
    atlas = "NofJokers_atlas",
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'nof_unique', set = 'Other'}

        if not G.GAME.nof_garden_card.suit then
            return {
                vars = {},
                key = self.key..'_base'
            }
        elseif G.GAME.nof_garden_card.suit == "Spades" then
            return {
                vars = {
                    localize("Spades", 'suits_singular'),
                    center.ability.extra_picks
                },
                key = self.key..'_spade'
            }
        elseif G.GAME.nof_garden_card.suit == "Hearts" then
            return {
                vars = {
                    localize("Hearts", 'suits_singular'),
                    center.ability.extra_picks
                },
                key = self.key..'_heart'
            }
        elseif G.GAME.nof_garden_card.suit == "Clubs" then
            return {
                vars = {
                    localize("Clubs", 'suits_singular'),
                    center.ability.extra_picks
                },
                key = self.key..'_club'
            }
        else
            return {
                vars = {
                    localize("Diamonds", 'suits_singular'),
                    center.ability.extra_picks
                },
                key = self.key..'_diamond'
            }
        end
    end,

    set_sprites = function(self, card, front)
        if not G.GAME.nof_garden_card.suit then
            card.children.center:set_sprite_pos({x = 0, y = 4})
        elseif G.GAME.nof_garden_card.suit == "Spades" then
            card.children.center:set_sprite_pos({x = 3, y = 4})
        elseif G.GAME.nof_garden_card.suit == "Hearts" then
            card.children.center:set_sprite_pos({x = 1, y = 4})
        elseif G.GAME.nof_garden_card.suit == "Clubs" then
            card.children.center:set_sprite_pos({x = 2, y = 4})
        else
            card.children.center:set_sprite_pos({x = 4, y = 4})
        end
    end,

    calculate = function (self, card, context)
        if (context.selling_self or card.getting_sliced) and not context.blueprint then
            G.GAME.nof_garden_card.suit = nil
            G.GAME.nof_garden_card.ranks = {}
        end

        if context.ending_shop and not context.blueprint then
            G.GAME.nof_garden_card.ranks = {}
        end
    end
}
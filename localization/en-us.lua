return {
	["descriptions"] = {
		["Joker"] = {
			["j_nof_spring_winds"] = {
				["name"] = "Spring Winds",
				["text"] = {
					"Every #3# hands played,",
					"cards still held in hand",
					"after {C:green}#1#{} hand played",
					"will trigger {C:green}#2#{} more time",
					"when held in hand or played",
					"{C:inactive}(Activates in: #4#){}",
				}
			},
			["j_nof_leafy_dew"] = {
				["name"] = "Leafy Dew",
				["text"] = {
					"Earn {C:money}${} when",
					"playing cards are destroyed,",
					"{C:money}${} gained vary depending",
					"on the suit of", "the card destroyed",
					"{C:spades}#1#{} = {C:money}$#5#{}",
					"{C:hearts}#2#{} = {C:money}$#6#{}",
					"{C:clubs}#3#{} = {C:money}$#7#{}",
					"{C:diamonds}#4#{} = {C:money}$#8#{}",
					"{C:inactive}(Gain no $ when{}",
					"{C:inactive}next to a Plot){}",
				}
			},
			["j_nof_dowsing_rod"] = {
				["name"] = "Dowsing Rod",
				["text"] = {
					"After first hand drawn,",
					"randomly select {C:green}#1#{},", "{C:green}#2# or #3#{} cards and",
					"{C:green}#4# in #5#{} chance to either",
					"increase/decrease their rank",
					"or change their suit",
					"{C:inactive}(Keeps applying chance until{}",
					"{C:red}#6#{} {C:inactive}failed attempts){}",
				}
			},
			["j_nof_garden_plot_base"] = {
				["name"] = "Garden Plot",
				["text"] = {
					"{C:inactive}(Needs dew...){}"
				}
			},
			["j_nof_garden_plot_spade"] = {
				["name"] = "Spade Plot",
				["text"] = {
					"All playing cards obtained",
					"will have {C:spades}#1#{} suit",
					"{C:attention}+#2#{} choice in {C:attention}Standard packs{}"
				}
			},
			["j_nof_garden_plot_heart"] = {
				["name"] = "Heart Plot",
				["text"] = {
					"All playing cards obtained",
					"will have {C:hearts}#1#{} suit",
					"{C:attention}+#2#{} choice in {C:attention}Standard packs{}"
				}
			},
			["j_nof_garden_plot_club"] = {
				["name"] = "Club Plot",
				["text"] = {
					"All playing cards obtained",
					"will have {C:clubs}#1#{} suit",
					"{C:attention}+#2#{} choice in {C:attention}Standard packs{}"
				}
			},
			["j_nof_garden_plot_diamond"] = {
				["name"] = "Diamond Plot",
				["text"] = {
					"All playing cards obtained",
					"will have {C:diamonds}#1#{} suit",
					"{C:attention}+#2#{} choice in {C:attention}Standard packs{}"
				}
			},
			["j_nof_medical_melody"] = {
				["name"] = "Medical Melody",
				["text"] = {
					"Every {C:green}#1#{} {C:inactive}[#2#]{}", "scoring cards played",
					"restore debuffed cards",
					"{C:inactive}(includes Joker cards){}"
				}
			},
			["j_nof_stomp"] = {
				["name"] = "Stomp",
				["text"] = {
					"{C:attention}+#1#{} hand size after each discard",
					"Caps at {C:attention}+#3#{} hand size",
					"Restarts after playing a hand",
					"{C:inactive}(Currently{} {C:attention}+#2#{} {C:inactive}hand size){}"
				}
			},
			["j_nof_sickle"] = {
				["name"] = "Sickle",
				["text"] = {
					"First hand played during the Blind",
					"will be drawn back to hand,",
					"{C:attention}-#2# Hands{} when triggered",
					"{C:inactive}(Currently #1#){}",
				}
			},
		},
		["Other"] = {
			["nof_unique"] = {
				["name"] = "Unique",
				["text"] = {
					"Will replace",
					"itself when", 
					"added",
				},
			},
			["nof_do_not_disturb"] = {
				["name"] = "Do Not Disturb",
				["text"] = {
					"Becomes eternal",
					"while active",
				},
			},
		},
	},
	["misc"] = {
		["dictionary"] = {
			["nof_active"] = "active!",
			["nof_inactive"] = "inactive",
			["nof_now"] = "now!",
			["nof_hands"] = "hand(s) played",
			["nof_recharging"] = "Recharging...",
			["nof_ready"] = "Ready!",
			["nof_charged"] = "Charged!",
			["nof_sold"] = "Sold!",
			["nof_planted"] = "Planted!",
			["nof_bait"] = "cards took the bait!",
			["nof_attempts_left"] = "attempts left",
			["nof_rod_fail"] = "They got away...",
			["nof_r_down"] = "Rank Down!",
			["nof_r_up"] = "Rank Up!",
			["nof_s_prev"] = "Previous Suit!",
			["nof_s_next"] = "Next Suit!",
			["nof_grown"] = "Grown Up!",
			["nof_restored"] = "Restored!",
			["nof_stomp"] = "Stomp!",
			["nof_hand_size"] = "Hand size",
		},
	},
}
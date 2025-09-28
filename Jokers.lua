print("Loaded Jokers.lua")

SMODS.Atlas {
	key = "ArthursModJokers",
	path = "ArthursModJokers.png",
	px = 71,
	py = 95
}


-- returns true if the joker is found, false otherwise
function check_for_joker(name)
    for index, value in pairs(G.jokers.cards) do
        if value.ability.name == name then
            return true
        end
    end
    return false
end

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'nestEgg',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Nest Egg',
		text = {
			"{C:mult}+#2#{} Mult per {C:gold}$#3#{}",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
		}
	},
	config = { extra = { mult = 0, mult_add = 1, req_gold = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_add, card.ability.extra.req_gold } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 2,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 0, y = 0 },
	-- Cost of card in shop.
	cost = 6,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		if context.joker_main then
			card.ability.extra.mult = math.floor(G.GAME.dollars / card.ability.extra.req_gold) * card.ability.extra.mult_add
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,

	update = function(self, card, dt)
		card.ability.extra.mult = math.floor(G.GAME.dollars / card.ability.extra.req_gold) * card.ability.extra.mult_add
	end
}


local function calculateMultiplier()
		if (G.GAME.round % 2 == 0) then
			return 2
		end
		return 0.5
	end

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'yinYang',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Yin and Yang',
		text = {
			"{X:mult,C:white}X#1#{} Mult on odd rounds",
            "{X:mult,C:white}X#2#{} Mult on even rounds",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}"
		}
	},
	config = { extra = { odd_mult = 0.5, even_mult = 2, mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.odd_mult, card.ability.extra.even_mult, card.ability.extra.mult } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 1,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 1, y = 0 },
	-- Cost of card in shop.
	cost = 3,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		if context.joker_main then
			card.ability.extra.mult = calculateMultiplier();
			return {
				xmult = card.ability.extra.mult,
			}
		end
	end,

	update = function(self, card, dt)
		card.ability.extra.mult = calculateMultiplier();
	end
}

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'stopwatch',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Stopwatch',
		text = {
			"{X:mult,C:white}X#1#{} Mult if Boss Blind is",
			"first Blind of this Ante",
			"{C:inactive}({C:attention}#2#{C:inactive} Blinds completed this Ante){}",
		}
	},
	config = { extra = { mult = 3, finished_rounds = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.finished_rounds } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 3,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 2, y = 0 },
	-- Cost of card in shop.
	cost = 9,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers then
			if G.GAME.blind.boss then
				card.ability.extra.finished_rounds = 0
				return {
					extra = { message = "Reset!", colour = G.C.FILTER }
				}
			else
				card.ability.extra.finished_rounds = card.ability.extra.finished_rounds + 1
				return {
					extra = { message = "+1 Round", colour = G.C.FILTER }
				}
			end
		end

		if context.joker_main then
			if (G.GAME.blind.boss and card.ability.extra.finished_rounds == 0) then
				return {
					xmult = card.ability.extra.mult
				}
			end
		end
	end
}

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'shatteredGlass',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Shattered Joker',
		text = {
			"Played cards give {X:mult,C:white}X#1#{} Mult",
			"and have a {C:green}#2# in #3#{} chance",
			"to be destroyed"
		}
	},
	config = { extra = { mult = 1.25, shatter_chance = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.shatter_chance } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 3,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 3, y = 0 },
	-- Cost of card in shop.
	cost = 12,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play then
    		return {remove = pseudorandom("shatteredGlass") < (G.GAME.probabilities.normal or 1) / self.config.extra.shatter_chance}
		end

		if context.individual and context.cardarea == G.play then
			return {
				xmult = card.ability.extra.mult,
				remove = true
			}
		end
	end
}

-- GLUE JOKER ------------

--- Overwriting pseudorandom so that I can manipulate glass rng
local truePseudorandom = pseudorandom
local preventedBreak = false
function pseudorandom(key)
    if key == "glass" and check_for_joker("j_arthur_jokerGlue") then
		if (pseudorandom("ArthurMod_glassTrue") < G.GAME.probabilities.normal/4) then
			preventedBreak = true
		end
        return 99 -- force "safe" roll
    end
    return truePseudorandom(key)
end


SMODS.Joker {
	-- How the code refers to the joker.
	key = 'jokerGlue',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Joker Glue',
		text = {
			"{C:attention}Glass{} cards cannot",
			"shatter"
		}
	},
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 2,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 4, y = 0 },
	-- Cost of card in shop.
	cost = 8,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function (self, card, context)
		if preventedBreak then
			preventedBreak = false
			return {
				extra = { message = "Prevented!", colour = G.C.FILTER }
			}
		end
		
	end
}

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'echoChamber',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Echo Chamber',
		text = {
			"Store {C:chips}#1#%{} of Chips each",
			"hand, add them to the",
			"next hand played",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
		}
	},
	config = { extra = { store_percent = 20, stored = 0, chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.store_percent, card.ability.extra.stored } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 1,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 5, y = 0 },
	-- Cost of card in shop.
	cost = 3,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function (self, card, context)
		if context.joker_main then
			card.ability.extra.chips = card.ability.extra.stored
			card.ability.extra.stored = math.floor((hand_chips - card.ability.extra.stored) * (card.ability.extra.store_percent/100))
			return {
				chips = card.ability.extra.chips,
				extra = { message = "Stored!", colour = G.C.FILTER }
				
			}
		end
	end
}


SMODS.Joker {
	-- How the code refers to the joker.
	key = 'diego',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Diego',
		text = {
			"Gains {C:mult}+#1#{} XMult when",
			" {C:attention}poker hand{} played, resets",
			"when different hand played",
			"or Boss Blind defeated",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}"
		}
	},
	config = { extra = { mult_increase = 1, current_mult = 1, stored_hand = nil} },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_increase, card.ability.extra.current_mult } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 4,
	-- Which atlas key to pull from.
	atlas = 'ArthursModJokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 6, y = 0 },
	soul_pos = { x = 7, y = 0 },
	-- Cost of card in shop.
	cost = 20,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function (self, card, context)
		if context.joker_main then
			-- get the played hand
			if card.ability.extra.stored_hand == nil or context.scoring_name == card.ability.extra.stored_hand then
				card.ability.extra.stored_hand = context.scoring_name
				card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult_increase
				return {
					extra = { message = "Increased!", colour = G.C.FILTER },
					xmult = card.ability.extra.current_mult
				}
			else 
				card.ability.extra.stored_hand = context.scoring_name
				card.ability.extra.current_mult = 1
				return {
					extra = { message = "Reset!", colour = G.C.FILTER }
				}
			end
			
		end

		if context.end_of_round and context.cardarea == G.jokers then
			if G.GAME.blind.boss then
				card.ability.extra.current_mult = 1
				return {
					extra = { message = "Reset!", colour = G.C.FILTER }
				}
			end
		end
	end
}

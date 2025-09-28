--- STEAMODDED HEADER
--- MOD_NAME: Arthur's Mod
--- MOD_ID: ArthursMod
--- PREFIX: arthur
--- MOD_AUTHOR: [Arthur]
--- MOD_DESCRIPTION: Custom cards that ive made
--- BADGE_COLOUR: 3FC7EB
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0905a, Lovely>=0.6]

--- Load different files
local lovely = require("lovely")
local mod_path = "" .. SMODS.current_mod.path
local f, err = SMODS.load_file("Jokers.lua")
if err then
		error(err) --Steamodded actually does a really good job of displaying this info! So we don't need to do anything else.
	end
f()

SMODS.Shader({ key = 'greyscale', path = 'greyscale.fs' })

SMODS.Edition({
    key = "greyscale",
    loc_txt = {
        name = "Greyscale",
        label = "Greyscale",
        text = {
            "{X:chips,C:white}X2{} Chips"
        }
    },

    shader = "greyscale",
    discovered = true,
    unlocked = true,
    config = { },
    in_shop = true,
    weight = 14,
    extra_cost = 3,
    apply_to_float = true,
    calculate = function(self, card, context)
        -- calculation code goes in here
        if context.post_joker and context.cardarea == G.jokers then
            return {
                xchips = 2
            }
        end
    end,
})

----------------------------------------------
------------MOD CODE END----------------------
module( "modifier_mod", package.seeall )


local modifierStringList = {"singleplayer", "floorislava", "superspeed", "superslow", "lowgravity", "slappers"}
	--modifier_mod.ModifierCheck(name)
	--WARE.ModifierDeny = {"singleplayer"}

local minigame = nil -- the current minigame
local currentModifier = nil -- number represending the current modifier in the modifierStringList
local modifierDeny = nil -- an array of denied modifiers for the current minigame

function ModifierCheck(name)
	minigame = ware_mod.Get(name)
	modifierDeny = minigame.ModifierDeny
	if modifierDeny == nil then
		return true
	else
		return !list.Contains(modifierDeny, currentModifier)
	end
end

function PickRandomModifier()
	currentModifier = math.ceil(math.random(1,#modifierStringList))
	return modifierStringList[currentModifier]
	ActivateModifier(currentModifier)
end

local Modifiers = {
	"singleplayer" = function()
		
	end, 
	"floorislava" = function()
		
	end,
	"superspeed" = function()
		for i,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
			GAMEMODE:SetPlayerSpeed(ply, 1000, 1200)
		end
	end,
	"superslow" = function()
		
	end,
	"lowgravity" = function()
		
	end,
	"slappers" = function()
		
	end}

function ActivateModifier(modifier)
	Modifiers[modifier]
end

function CleanUpModifers() -- function for cleaning up all modifiers when needed
end
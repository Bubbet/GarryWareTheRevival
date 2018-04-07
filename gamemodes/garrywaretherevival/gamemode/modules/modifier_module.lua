module( "modifier_mod", package.seeall )


local modifierStringList = {"singleplayer", "floorislava", "superspeed", "superslow", "lowgravity", "slappers", "randomfov"}
	--modifier_mod.ModifierCheck(name)
	--WARE.ModifierDeny = {"singleplayer"}

local minigame = nil -- the current minigame
local env = nil -- the current enviroment
local currentModifier = nil -- number represending the current modifier in the modifierStringList
local modifierDeny = nil -- an array of denied modifiers for the current minigame
local envCenter = nil

floorislavaon = false -- base settings of minigames that require to be updated regularly.

concommand.Add("gw_forcemodifier", 
	function(ply, cmd, args)
		print("Changing Modifier To: " .. args[1])
		CleanUpModifers()
		ModifierCheck(args[1]);
		Modifiers(args[1]);
	end,
	function(args, stringargs) 
		local tbl = {}
		stringargs = string.Trim( stringargs )
		stringargs = string.lower( stringargs )
		for k, v in pairs(modifierStringList) do
			if string.find( string.lower( v ), stringargs ) then
				local nick = "\"" .. v .. "\""
				nick = "gw_forcemodifier " .. v
	
				table.insert( tbl, nick )
			end
		end
		return tbl
	end,
	"Used to force-change current garryware modifer. Usage: gw_forcemodifier modifername",
	FCVAR_CHEAT
)

function ModifierCheck(name)
	local minigamenew = ware_mod.Get(name)
	local envnew = minigamenew.Room
	modifierDeny = minigamenew.ModifierDeny
	if list.Contains(modifierDeny, currentModifier) then 	
		return false
	else
		minigame = minigamenew or ware_mod.Get(name)
		env = envnew or minigame.Room
		if env == "none" then -- checker room
			envCenter = GAMEMODE:GetEnts("dark_inair")[1]:GetPos()
		elseif env == "hexaprism" then
			envCenter = GAMEMODE:GetEnts("center")[1]:GetPos()
		else
			envCenter = GAMEMODE:GetEnts("inair")[1]:GetPos()
		end
	end
	return !list.Contains(modifierDeny, currentModifier);
end

function PickRandomModifier()
	currentModifier = math.ceil(math.random(1,#modifierStringList))
	--return modifierStringList[currentModifier]
	return ActivateModifier(currentModifier)
end
-- For Modifiers That Need To Run Loops
function FloorIsLava()
	print("lavaloop")
	if floorislavaon then
		local lavaz;
		if env == "none" then -- checker room
			lavaz = GAMEMODE:GetRandomLocations(1, "dark_ground")[1]:GetPos().z + 5;			
		elseif env == "hexaprism" then -- hex room
			lavaz = GAMEMODE:GetRandomLocations(1, "center")[1]:GetPos().z + 5;
		else -- box room
			lavaz = GAMEMODE:GetRandomLocations(1, "cross")[1]:GetPos().z + 5;	
		end
		
		for _,e in pairs(team.GetPlayers(TEAM_HUMANS)) do				
			if e:GetPos().z < lavaz then e:ApplyLose() end
		end
		
		timer.Simple(0.5,FloorIsLava)
	end
	
end

local function spawnModel( iModel , modelCount , delay ) -- for floor is lava
	local pos = GAMEMODE:GetRandomPositions(1, envCenter)[1]
	
	local ent = ents.Create ("prop_physics_override")
	ent:SetModel ("models/props_junk/wood_crate001a.mdl")
	ent:SetPos( pos )
	ent:SetAngles( VectorRand():Angle() )
	ent:Spawn()
	--ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	local physObj = ent:GetPhysicsObject()
	if physObj:IsValid() then
		physObj:ApplyForceCenter( VectorRand() * math.random( 256, 468 ) * physObj:GetMass() )
	end
	
	GAMEMODE:MakeAppearEffect( ent:GetPos() )
	GAMEMODE:AppendEntToBin( ent )
	
	if (iModel < modelCount) then
		timer.Simple( delay, function() spawnModel(iModel + 1 , modelCount , delay ) end )
	end
end


function Modifiers(choice)

	local ModifiersSwitch = {["singleplayer"] = function()
			
		end, ["floorislava"] = function()
			print("floorlava")
			--Spawning saftey props
			if env == "none" or env == "hexaprism" then -- checker room
				spawnModel( 1 , math.ceil(1.2*#team.GetPlayers(TEAM_HUMANS)) , 0.1 )
			end
			--Starting The Lava
			timer.Simple(3, function() floorislavaon = true; FloorIsLava(); end )
		end, ["superspeed"] = function()
			for i,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
				GAMEMODE:SetPlayerSpeed(ply, 1000, 1200)
			end
		end, ["superslow"] = function()
			
		end, ["lowgravity"] = function()
			
		end, ["slappers"] = function()
			
		end, ["randomfov"] = function()
			
		end
	}
	
	ModifiersSwitch[choice]()
	
end

function CleanUpModifers() -- function for cleaning up all modifiers when needed
	floorislavaon = false;
end
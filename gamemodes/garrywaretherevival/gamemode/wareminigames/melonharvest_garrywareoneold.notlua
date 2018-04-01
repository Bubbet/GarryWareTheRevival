WARE.Author = "Kilburn"
--WARE.Room = "empty"

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	
	local numPlayers = team.NumPlayers(TEAM_HUMANS)
    local numberSpawns = math.Clamp(math.ceil(numPlayers*1.5),1,table.Count(GAMEMODE:GetEnts(ENTS_INAIR)))
	self.NumHarvest = math.random(2,5)
    local acttime = 3.5 * self.NumHarvest
    self.NumMelonSpawns = math.ceil(numPlayers*0.2)
    self.DelayBetweenMelons = 0.3 * (1.5 + self.NumMelonSpawns - (numPlayers*0.2))
        
    GAMEMODE:SetWareWindupAndLength(5,acttime)
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Harvest Time!" )
	local entposcopy = GAMEMODE:GetRandomLocations(numberSpawns, ENTS_ONCRATE)
	
	for _,v in pairs(entposcopy) do
		local pos = v:GetPos()
		local cart = ents.Create("prop_physics")
		cart:SetModel("models/props_wasteland/laundry_cart001.mdl")
		cart:PhysicsInit(SOLID_VPHYSICS)
		cart:SetMoveType(MOVETYPE_VPHYSICS)
		cart:SetSolid(SOLID_VPHYSICS)
		cart:SetPos(pos+Vector(0,0,100))
		cart:SetAngles(Angle(0,math.random(-180,180),0))
		cart.Usable = true
		cart:Spawn()
		
		cart:Fire("AddOutput", "OnPhysGunOnlyPickup luarun1,RunCode")
		cart:Fire("AddOutput", "OnPhysGunDrop luarun2,RunCode")
		cart:Fire("AddOutput", "OnPhysCannonDetach luarun2,RunCode")
		
		GAMEMODE:AppendEntToBin(cart)
		GAMEMODE:MakeAppearEffect(pos+Vector(0,0,100))
	end
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
end

function WARE:StartAction()
	
end

function WARE:EndAction()

end

function WARE:GravGunOnPickedUp( pl, ent )
	if (ent:GetModel() == "models/props_wasteland/laundry_cart001.mdl") and ent.Usable then
		ent:SetColor(255,255,255,50)
		ent.CartOwner = pl
		--pl:ApplyWin( )
		--ent:SetUsability( false )
	end
end

function WARE:GravGunOnDropped( pl, ent )
	if ent:GetModel() == "models/props_wasteland/laundry_cart001.mdl" then
		pl:ApplyLose()
		pl:StripWeapons()
		ent.Usable = false
		ent:SetMoveType(MOVETYPE_NONE)
		--ent:SetSolid(SOLID_NONE)
		ent:SetColor(255,100,100,255)
	end
end

-- //Temporary disable
-- function WARE:IsPlayable()
        -- return true
-- end

-- WARE.Models = {
-- "models/props_junk/watermelon01.mdl"
-- "models/props_wasteland/laundry_cart001.mdl"
 -- }
 
-- function WARE:GetModelList()
	-- return self.Models
-- end


-- local function RemoveCartVictory(cart)
        -- if cart and cart:IsValid() then
                -- GAMEMODE:MakeDisappearEffect(cart:GetPos())
                -- GAMEMODE:MakeLandmarkEffect(cart:GetPos())
                -- cart:Remove()
        -- end
-- end

-- local function EntityCaught(trigger,ent)
        -- local cart = trigger:GetParent()
        
        -- if cart:IsValid() and cart.CartOwner and ent:GetModel()=="models/props_junk/watermelon01.mdl" then
                -- ent:Remove()
                -- GAMEMODE:MakeAppearEffect(ent:GetPos())
                -- if not cart.NumHarvested then cart.NumHarvested = 0 end
                -- cart.NumHarvested = cart.NumHarvested + 1
                
                -- cart.CartOwner:SendLua("LocalPlayer():EmitSound( \"" .. GAMEMODE.WinOther .. "\" )")
                
                -- if cart.NumHarvested>=GAMEMODE.Minigame.NumHarvest then
                        -- cart:SetColor(255,255,255,255)
                        -- cart.CartOwner:WarePlayerDestinyWin()
                        -- cart.CartOwner:StripWeapons()
                        -- trigger:Remove()
                        -- timer.Simple(1, RemoveCartVictory, cart)
                -- end
        -- end
-- end

-- function WARE:Initialize()
        -- local numPlayers = team.NumPlayers(TEAM_HUMANS)
        -- local numberSpawns = math.Clamp(math.ceil(numPlayers*1.5),1,table.Count(GAMEMODE:GetEnts(ENTS_INAIR)))
        
        -- self.NumHarvest = math.random(2,5)
        -- local acttime = 3.5 * self.NumHarvest
        -- self.NumMelonSpawns = math.ceil(numPlayers*0.2)
        -- self.DelayBetweenMelons = 0.3 * (1.5 + self.NumMelonSpawns - (numPlayers*0.2))
        
        -- GAMEMODE:SetWareWindupAndLength(5,acttime)
        -- GAMEMODE:DrawInstructions("Grab a laundry cart...")
        
        -- -- HAXX
        -- -- GravGunOnPickedUp hook is broken, so we'll use this tricky workaround
        -- local lua_run1 = ents.Create("lua_run")
        -- lua_run1:SetKeyValue('Code','CALLER:SetColor(255,255,255,100);CALLER.CartOwner=ACTIVATOR;ACTIVATOR.Cart=CALLER')
        -- lua_run1:SetKeyValue('targetname','luarun1')
        -- lua_run1:Spawn()
        
        -- local lua_run2 = ents.Create("lua_run")
        -- lua_run2:SetKeyValue('Code','CALLER:SetColor(255,255,255,255);CALLER.CartOwner=nil;ACTIVATOR.Cart=nil')
        -- lua_run2:SetKeyValue('targetname','luarun2')
        -- lua_run2:Spawn()
        
        -- for _,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, GAMEMODE:GetEnts(ENTS_ONCRATE))) do
                -- local cart = ents.Create("prop_physics")
                -- cart:SetModel("models/props_wasteland/laundry_cart001.mdl")
                -- cart:PhysicsInit(SOLID_VPHYSICS)
                -- cart:SetMoveType(MOVETYPE_VPHYSICS)
                -- cart:SetSolid(SOLID_VPHYSICS)
                -- cart:SetPos(pos+Vector(0,0,100))
                -- cart:SetAngles(Angle(0,math.random(-180,180),0))
                -- cart:Spawn()
                
                -- cart:Fire("AddOutput", "OnPhysGunOnlyPickup luarun1,RunCode")
                -- cart:Fire("AddOutput", "OnPhysGunDrop luarun2,RunCode")
                -- cart:Fire("AddOutput", "OnPhysCannonDetach luarun2,RunCode")
                
                -- GAMEMODE:AppendEntToBin(cart)
                -- GAMEMODE:MakeAppearEffect(pos+Vector(0,0,100))
        -- end
        
        -- for _,v in pairs(team.GetPlayers(TEAM_UNASSIGNED)) do
                -- v:Give( "weapon_physcannon" )
        -- end
-- end

function WARE:StartAction()
        GAMEMODE:DrawInstructions("Catch "..self.NumHarvest.." melons without dropping your cart ! ")
        self.NextMelonSpawn = 0
        self.NextMelonCleanup = 0
        
        -- for _,v in pairs(ents.FindByModel("models/props_wasteland/laundry_cart001.mdl")) do
                -- if v.CartOwner then
                        -- local trigger = ents.Create("ware_trigger")
                        -- trigger:SetPos(v:GetPos())
                        -- trigger:SetAngles(v:GetAngles())
                        -- trigger:Spawn()
                        
                        -- trigger:SetParent(v)
                        -- trigger:Setup(Vector(-35,-15,-10), Vector(35,15,20), EntityCaught, {"models/props_junk/watermelon01.mdl"}, true)
                        -- v.Trigger = trigger
                -- else
                        -- GAMEMODE:MakeDisappearEffect(v:GetPos())
                        -- v:Remove()
                -- end
        -- end
end

-- function WARE:EndAction()
        -- for _,v in pairs(ents.FindByClass("lua_run")) do
                -- v:Remove()
        -- end
-- end

function WARE:Think()
		
		for _,v in pairs(ents.FindByModel("models/props_wasteland/laundry_cart001.mdl")) do
			if !(v.CartOwner == nil) then
				for _,b in pairs(ents.FindInSphere(v:GetPos(), 50)) do
					if b:GetModel() == "models/props_junk/watermelon01" then
						v.CartOwner.Score = v.CartOwner.Score + 1 or 1
						b:Remove()
					end
				end
				print(v.CartOwner.Score)
			end
		end

        if not self.NextMelonSpawn then return end
        
        if CurTime()>self.NextMelonSpawn then
                for _,v in pairs(GAMEMODE:GetRandomLocations(self.NumMelonSpawns, ENTS_INAIR)) do
                        local pos = v:GetPos()
						local melon = ents.Create("prop_physics")
                        melon:SetModel("models/props_junk/watermelon01.mdl")
                        melon:PhysicsInit(SOLID_VPHYSICS)
                        melon:SetMoveType(MOVETYPE_VPHYSICS)
                        melon:SetSolid(SOLID_VPHYSICS)
                        melon:SetPos(pos)
                        melon:SetAngles(Angle(math.random(-180,180),math.random(-180,180),math.random(-180,180)))
                        melon:Spawn()
                        
                        melon:GetPhysicsObject():SetDamping(7.5,melon:GetPhysicsObject():GetRotDamping())
                        melon:GetPhysicsObject():ApplyForceCenter(Vector(math.random(-5000,5000),math.random(-5000,5000),math.random(-1000,0)))
                        
                        GAMEMODE:AppendEntToBin(melon)
                        GAMEMODE:MakeAppearEffect(pos)
                end
                self.NextMelonSpawn = CurTime() + self.DelayBetweenMelons
        end
        
        if CurTime()>self.NextMelonCleanup then
                for _,v in pairs(ents.FindByModel("models/props_junk/watermelon01.mdl")) do
                        if math.abs(v:GetPhysicsObject():GetVelocity().x)<0.1 and
                           math.abs(v:GetPhysicsObject():GetVelocity().y)<0.1 and
                           math.abs(v:GetPhysicsObject():GetVelocity().z)<0.1 then
                                GAMEMODE:MakeDisappearEffect(v:GetPos())
                                v:Remove()
                        end
                end
                self.NextMelonCleanup = CurTime() + 3
        end
end
local self = WARE
WARE.Author = "Bubbet!"
WARE.Room = "empty"

WARE.CircleRadius = 64

WARE.Circles = {}
WARE.ColorNames = {"Red", "Green", "Blue", "Orange", "Pink", "Yellow", "Cyan", "Purple", "Grey"}
WARE.Colors = {Color(255,0,0), Color(0,255,0), Color(0,0,255), Color(255,125,0), Color(255, 0, 255), Color(255, 255, 0), Color(0, 255, 255), Color(125,0,255), Color(125,125,125)}

function WARE:PickColor(ply)
	--if self.IsActive then
		
		ply.possiblecolors = {}
		for k,p in pairs(ents.FindInSphere(ply:GetPos(),150)) do
			if p:GetClass() == "ware_ringzone" then
				table.insert(ply.possiblecolors, p.colorid)
				--print(p.colorid)
			end
		end
		local targetcolorid = ply.possiblecolors[math.ceil(math.random(1,#ply.possiblecolors))]
		--print(ply.targetcolorid)
		if targetcolorid == ply.oldcolorid then
			self:PickColor(ply)
			return false
		else
			ply.targetcolorid = targetcolorid
		end
		
		GAMEMODE:DrawInstructions( "You have bounced: " .. ply.successfulbumps .. "/" .. self.targetbumps .. " times! " .. ply.keepbouncing .. " Goto color: " .. self.ColorNames[ply.targetcolorid], self.Colors[ply.targetcolorid], Color(255,255,255,255), {ply} )
		--self.targetcolorid = math.ceil(math.random(1,#self.Colors))
		
		-- local plypf = RecipientFilter()
		-- plypf:RemoveAllPlayers()
		-- if team.NumPlayers(TEAM_HUMANS)>0 then print("PlayerAdded: "..team.GetPlayers(TEAM_HUMANS)[1]:GetName()); plypf:AddPlayer(team.GetPlayers(TEAM_HUMANS)[1]); end
		-- print( "Filtered Players: "..plypf:GetCount() )
		
		-- plypf = { team.GetPlayers(TEAM_HUMANS)[1] }
		
		-- --GAMEMODE:DrawInstructions( "Goto color: " .. self.ColorNames[self.targetcolorid], self.Colors[self.targetcolorid])
		-- GAMEMODE:DrawInstructions( "Yoshi is a big dumb dumb".."Goto color: " .. self.ColorNames[self.targetcolorid], Color(0,0,0,255), Color(255,255,255,255), plypf)
	
		
		--if self.gameinprogress then
		--	for k,p in pairs(team.GetPlayers(TEAM_HUMANS)) do
		--		timer.Simple(2, function() self:PickColor(p) end)
		--	end
		--end
	--end
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )

	self.targetbumps = math.ceil(math.random(2,5))
	
	GAMEMODE:SetWareWindupAndLength(6, 4*self.targetbumps)

	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Bump to the correct color " .. self.targetbumps .. " times!" )
	
	--TEST
	GAMEMODE:HookTriggers()
	
	self.Circles = {}
	
	self.LastThinkDo = 0
	
	timer.Simple(2, 
		function()
			local ratio = 1
			local num = #GAMEMODE:GetEnts({"dark_ground","light_ground"}) * ratio
			local entposcopy = GAMEMODE:GetRandomLocations(num, {"dark_ground","light_ground"} )
			
			for k,v in pairs(entposcopy) do
				local ent = ents.Create("ware_ringzone")
				local colorid = math.ceil(math.random(1,#self.Colors))
				ent:SetPos(v:GetPos() + Vector(0,0,4) )
				ent:SetAngles(Angle(0,0,0))
				ent:SetZColor(self.Colors[colorid])
				ent:SetZSize(128)
				ent:Spawn()
				ent:Activate()
				
				ent.colorid = colorid
				
				GAMEMODE:AppendEntToBin(ent)
				
				ent.LastActTime = 0
				
				table.insert( self.Circles , ent )
		
				GAMEMODE:AppendEntToBin(ent)
				GAMEMODE:MakeAppearEffect(ent:GetPos())
			end
		end
	)
	
	timer.Simple(3,
		function()
			for k,p in pairs(team.GetPlayers(TEAM_HUMANS)) do
				p.successfulbumps = 0
				p.keepbouncing =  "Start Bouncing!"
				self:PickColor(p)
			end
		end
	)
	
	timer.Simple(6, 
		function() 
			self.IsActive = true
		end
	)
	
	return
end

function WARE:StartAction()
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		v:Give( "sware_crowbar" )
	end
	
	return
end

function WARE:EndAction()
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		if v.successfulbumps == nil then return false end
		if v.successfulbumps >= self.targetbumps then
			v:ApplyWin()
			v:StripWeapons()
		end
	end
	self.IsActive = false
	self.gameinprogress = false
end

function WARE:Think( )
	if self.IsActive then
		for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
			if !GAMEMODE:PhaseIsPrelude() and !ply:GetLocked() then
				local ent = ply:GetGroundEntity()
				--if ent == GetWorldEntity() then
				if ent == game.GetWorld() then
					ply:ApplyLose()
					ply:SimulateDeath()-- Vector(0, 0, -1) * 10^3 )
					--ply:EjectWeapons( Vector(0, 0, 1) * 100, 120)
				end
				
				
			end
		end
	
		if (CurTime() < (self.LastThinkDo + 0.05)) then return end
		self.LastThinkDo = CurTime()
		
		for k,ring in pairs(self.Circles) do
			local sphere = ents.FindInSphere(ring:GetPos(),self.CircleRadius)
			
			for _,target in pairs(sphere) do			
				if (target:IsPlayer() and target:IsWarePlayer()) or ( target:GetClass() == "swent_crowbar" ) then
					if (CurTime() > (ring.LastActTime + 0.15)) then
					
						ring.LastActTime = CurTime()
						if target:IsPlayer() and target:IsWarePlayer() and !target:GetLocked() then
							if (ring.colorid == target.oldcolorid) then
								GAMEMODE:DrawInstructions( "You have bounced: " .. target.successfulbumps .. "/" .. self.targetbumps .. " times! " .. target.keepbouncing .. " Goto color: " .. self.ColorNames[target.targetcolorid], self.Colors[target.targetcolorid], Color(255,255,255,255), {target} )
							elseif !(ring.colorid == target.targetcolorid) then
								target:ApplyLose()
								target:SimulateDeath()
								GAMEMODE:DrawInstructions( "You Failed, with " .. target.successfulbumps .. "/" .. self.targetbumps .. " bounces.", Color(255,0,0,255), Color(255,255,255,255), {target} )
							else
								target.oldcolorid = target.targetcolorid
								target.successfulbumps = target.successfulbumps + 1
								if target.successfulbumps < self.targetbumps then target.keepbouncing =  "Keep Bouncing!" else target.keepbouncing =  "Stay Alive!" end
								self:PickColor(target)
							end
							
							ring:EmitSound("ambient/levels/labs/electric_explosion1.wav")
							
							local effectdata = EffectData( )
								effectdata:SetOrigin( ring:GetPos( ) )
								effectdata:SetNormal( Vector(0,0,1) )
							util.Effect( "waveexplo", effectdata, true, true )
						end
						
						if (target:IsPlayer() == false) then
							target:EmitSound("weapons/flame_thrower_airblast_rocket_redirect.wav")
							target:GetPhysicsObject():ApplyForceCenter(ring:GetPos():GetNormalized() * 10000)
							
							if ((target.Deflected or false) == false) then
								target.Deflected = true
								local trail_entity = util.SpriteTrail( target,  --Entity
																		0,  --iAttachmentID
																		Color( 255, 255, 255, 255 ),  --Color
																		false, -- bAdditive
																		8, --fStartWidth
																		0, --fEndWidth
																		0.2, --fLifetime
																		1 / ((0.7+1.2) * 0.5), --fTextureRes
																		"trails/tube.vmt" ) --strTexture
							end
							
							
						else
							target:SetGroundEntity( NULL )
							--target:SetVelocity(target:GetVelocity()*(-1) + (target:GetPos() + Vector(0,0,32) - ring:GetPos()):Normalize() * 500)
							target:SetVelocity(target:GetVelocity()*(-1) + (target:GetPos() + Vector(0,0,32) - ring:GetPos()):GetNormalized() * 500)
						end
					
					end
				end
			end
		end
	end
end

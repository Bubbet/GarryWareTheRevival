local self = WARE
WARE.Author = "Bubbet!"
WARE.Room = "empty"

WARE.CircleRadius = 64

WARE.Circles = {}
WARE.ColorNames = {"Red", "Green", "Blue", "Orange", "Magenta", "Yellow", "Cyan", "Purple", "Aqua"}
WARE.Colors = {Color(255,0,0), Color(0,255,0), Color(0,0,255), Color(255,125,0), Color(255, 0, 125), Color(125, 255, 0), Color(0, 255, 125), Color(125,0,255), Color(0,125,255)}

function WARE:PickColor()
	self.targetcolorid = math.ceil(math.random(1,#self.Colors))
	GAMEMODE:DrawInstructions( "Goto color: " .. self.ColorNames[self.targetcolorid], self.Colors[self.targetcolorid])
	if self.gameinprogress then
		timer.Simple(2, function() self:PickColor() end)
	end
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	
	GAMEMODE:SetWareWindupAndLength(3, 16)

	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Keep bumping, to the correct color!" )
	local plypf = RecipientFilter()
	plypf:RemoveAllPlayers()
	plypf:AddPlayer(team.GetPlayers(TEAM_HUMANS)[1])
	GAMEMODE:DrawInstructions( "Yoshi is a big dumb dumb", Color(0,0,0,255), Color(255,255,255,255), plypf)
	
	--TEST
	GAMEMODE:HookTriggers()
	
	self.Circles = {}
	
	self.LastThinkDo = 0
	
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
	
	timer.Simple(2, 
		function() 
			self.gameinprogress = true
			self:PickColor()
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
	self.gameinprogress = false
end

function WARE:Think( )
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
						if !(ring.colorid == self.targetcolorid) then
							target:ApplyLose()
							target:SimulateDeath()
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

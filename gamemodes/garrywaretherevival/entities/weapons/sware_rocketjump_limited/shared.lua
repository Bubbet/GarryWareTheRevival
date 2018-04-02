
if (SERVER) then
   AddCSLuaFile ("shared.lua")
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "SWARE Rocketjump"		
SWEP.Slot				= 1
SWEP.SlotPos			= 0
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.HoldType = "rpg"

SWEP.DrawAmmo			= false
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false

SWEP.ShootSound = Sound ("npc/env_headcrabcanister/launch.wav")

SWEP.RunArmAngle  = Angle( -20, 0, 0 )
SWEP.RunArmOffset = Vector( 0, -4, 0 )
SWEP.Delay = 0.75
SWEP.TickDelay = 0.1

SWEP.ProjectileEntity = "swent_rocketjump"
SWEP.ProjectileForce = 5000000


function SWEP:Throw( shotPower )
	local tr = self.Owner:GetEyeTrace()

	if (not SERVER) then return end

	local ent = ents.Create( self.ProjectileEntity )	

	local Forward = self.Owner:EyeAngles():Forward()
	ent:SetPos( self.Owner:GetShootPos() + Forward * 0 )
	ent:SetAngles (self.Owner:EyeAngles())
	ent:Spawn()
	ent:SetOwner(self.Owner)
	ent:Activate( )
	
	local trail_entity = util.SpriteTrail( ent, --Entity
											0, --iAttachmentID
											Color( 255, 255, 255, 255 ), --Color
											false, -- bAdditive
											8, --fStartWidth
											0, --fEndWidth
											0.2, --fLifetime
											1 / ((0.7+1.2) * 0.5), --fTextureRes
											"trails/tube.vmt") --strTexture
	
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() * shotPower)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.TickDelay )
	
	if ( not self:CanPrimaryAttack() ) then return end
	if ( not self:CanShootWeapon() ) then return end
	
	self.Weapon:EmitSound(self.ShootSound)
	
	self:TakePrimaryAmmo( 1 )
	
	if (CLIENT) then return end
	self:Throw( self.ProjectileForce )
	
	timer.Simple(math.Clamp(self.Owner:GetShootPos():Distance(self.OHS+Vector(0.01,0.01,0.01))/1000,0.01,100), function()
		for _,ent in pairs(team.GetPlayers(TEAM_HUMANS)) do
			if 1 then--ent:GetPos():Distance(self.OHS) <= 80 then
				ent:SetGroundEntity( NULL )
				if ent == self.Owner then
				self.DoVel = (ent:GetPos() - self.OHS)*Vector(10,10,10)/math.Clamp((ent:GetPos():Distance(self.OHS)/80.5)^10,1,1000000)
				else
				self.DoVel = (ent:GetPos() - self.OHS)*Vector(100,100,10)/math.Clamp((ent:GetPos():Distance(self.OHS)/80.5)^10,1,1000000)
				end
				ent:SetVelocity(self.DoVel)
			end
		end
	end)
end

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	self.OHS = self.Owner:GetEyeTraceNoCursor().HitPos + Vector(0,0,-10)
end
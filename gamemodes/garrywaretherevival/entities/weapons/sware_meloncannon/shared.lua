if (SERVER) then

    AddCSLuaFile ("shared.lua")

end

SWEP.Base = "gmdm_base"
SWEP.PrintName = "SWARE MelonCannon"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.HoldType = "rpg"

SWEP.ShootSound = Sound("weapons/crossbow/fire1.wav")

SWEP.RunArmAngle = Angle( -20, 0, 0 )
SWEP.RunArmOffset = Vector( 0, -4, 0 )

SWEP.Delay = 0.75
SWEP.TickDelay = 0.1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"


function SWEP:PrimaryAttack()

    local Forward = self.Owner:EyeAngles():Forward()


    local prop = ents.Create("prop_physics")

    prop.Owner = self.Owner

    prop:SetModel( "models/props_junk/watermelon01.mdl" )

    prop:SetPos(self.Owner:GetShootPos() + Forward * 10)

    prop:Spawn()


    local phys = prop:GetPhysicsObject()

    phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() * 500)


end

    --launches melon in arc; melon has gravity


SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SecondaryAttack()
end


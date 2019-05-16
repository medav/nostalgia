AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
	
	self:SetAngles(Angle(0,0,0))
	self:SetColor(255,0,255,255)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow(false)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:EnableCollisions(true)
	end
	
end

function disorient(ply)
	umsg.Start("disorient",ply)
	umsg.End()
end

function ENT:Touch(ply)
	disorient(ply)
end

function ENT:OnTakeDamage(dmg)
	return false
end

function ENT:SetLife(timet,life)
	self.time=timet
	self.life=life
end

function ENT:Think()
	if g_time+self.life<=self.time or mode!=2 then
		self:Remove()
	end
	
end
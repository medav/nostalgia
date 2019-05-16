AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
	
	self:SetAngles(Angle(0,0,0))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow(false)
	self:SetColor(255,0,0,255)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:EnableCollisions(true)
	end
	
end

function ENT:Touch(ent)
	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:PhysicsCollide( data, physobj )
	self:Remove()
end

function ENT:OnRemove()
	local vPoint=self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint ) 
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )
	
	local position = vPoint
	local damage = 45
	local radius = 1024
	util.BlastDamage(self,self, position, radius, damage)
	
	self:Remove()
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
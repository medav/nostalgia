AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetModel( "models/hunter/plates/plate8x8.mdl" )
	local pos=ents.FindByName("scoreboard1")[1]:GetPos()
	local pos3=ents.FindByName("scoreboard1")[1]:GetPos()
	pos3:Add(Vector(-20,0,0))
	local pos2=ents.FindByName("scoreboard2")[1]:GetPos()
	self:SetNWVector("bp",pos3)
	local temp=pos
	temp:Add(Vector(-40,0,0))
	self:SetPos(temp)
	self:SetAngles(Angle(0,0,90))
	self:SetNWInt("width",math.Dist(pos.x,pos.y,pos2.x,pos2.y))
	self:SetNWInt("tall",pos2.z-pos.z)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	self:DrawShadow(false)
	
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	
end

function ENT:OnTakeDamage(dmg)
	return false
end
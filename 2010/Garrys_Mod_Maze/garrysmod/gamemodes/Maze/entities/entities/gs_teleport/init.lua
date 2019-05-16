AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
	
	self:SetAngles(Angle(0,0,0))
	self:SetColor(0,0,255,255)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow(false)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:EnableCollisions(true)
	end
	
end

function teleport_ply(ply)
	-- find an 'open' block
	local r=math.random(1,math.random(30,100))
	local dest
	for k,v in pairs(ents.FindByName("block")) do
		if !v:GetNWBool("open") && !v:GetNWBool("change") then
			if r==1 then
				dest=v
				r=0
			elseif r>1 then
				r=r-1
			end
		end
	end
	if !dest then return teleport_ply(ply) end -- repeat if no destination is found
	local pos=ply:GetPos()
	pos.x=dest:LocalToWorld(dest:OBBCenter()).x
	pos.y=dest:LocalToWorld(dest:OBBCenter()).y
	ply:SetPos(pos)
end

function ENT:Touch(ply)
	
	if ply:IsPlayer() && !get_prot_status(ply,"gs_teleport") then 
		teleport_ply(ply)
	end
	
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
include("shared.lua")



function ENT:Draw()
	self:DrawModel()
	local ang=self:GetAngles()
	ang:RotateAroundAxis(Vector(0,0,1),3)
	self:SetAngles(ang)
end


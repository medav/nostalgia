include("shared.lua")

local font=surface.CreateFont ("coolvetica", 14, 400, true, false, "gmmfont")
local font2=surface.CreateFont ("coolvetica", 8, 400, true, false, "gmmfont")



function populate_list()
	local p=player.GetAll()
	local ordered={}
	local i=0
	for i=1,#p,1 do 				-- wins
		for k,v in pairs(p) do
			if v:GetNWInt("position")==i then
				table.insert(ordered,v)
				table.remove(p,k)
			end
		end
	end
	for k,v in pairs(p) do
		table.insert(ordered,v)
	end
	return ordered
end

function format_time(timet)
	local tm
	if type(timet)=="nil" then
		tm="0:00"
	else
		local t=timet
		local s=t%60
		local m=(t-s)/60
		if s>9 then
			tm=tostring(m) .. ":" ..tostring(s)
		else
			tm=tostring(m) .. ":0" ..tostring(s)
		end
	end
	return tm
end

function ENT:Draw()
	Host=GetHostName( )
	self:DrawShadow(false)
	local w,h=self:GetNWInt("width"),self:GetNWInt("tall")
	local bpos=self:GetNWVector("bp")
	cam.Start3D2D(bpos, Angle(0,180,90), 1)
			
		local list=populate_list()
		draw.RoundedBox(4,0,0,w,24,Color(0,0,0,64))
		draw.RoundedBox(4,4,4,w-8,16,Color(0,0,96,200))
		
		draw.DrawText(Host,font, (w-8)/2, 4, Color(255,255,255,255),1)
		
		draw.RoundedBox(4,0,28,w,84,Color(0,0,0,64))
		draw.RoundedBox(4,4,32,(w-8)/2-4,76,Color(0,0,96,200))
		draw.RoundedBox(4,(w-8)/2+1,32,(w-8)/4-1,76,Color(0,0,96,200))
		draw.RoundedBox(4,(w-8)/2+(w-8)/4+1,32,(w-8)/4+4,76,Color(0,0,96,200))
		
		draw.DrawText("Player",font2, 8, 32, Color(255,255,255,255),0)
		draw.DrawText("Time",font2, (w-8)/2+5,32, Color(255,255,255,255),0)
		draw.DrawText("points",font2, (w-8)/2+(w-8)/4+5, 32, Color(255,255,255,255),0)
		
		for k,v in ipairs(list) do
			draw.DrawText(v:Nick(),font2, 8, 32+k*12, Color(255,255,255,255),0)
			draw.DrawText(format_time(v:GetNWInt("time")),font2, (w-8)/2+5,32+k*12, Color(255,255,255,255),0)
			draw.DrawText(tostring(v:GetNWInt("points")),font2, (w-8)/2+(w-8)/4+5, 32+k*12, Color(255,255,255,255),0)
		end
		
	cam.End3D2D()

end

function 	ENT:IsTranslucent( ) 
	return true
end

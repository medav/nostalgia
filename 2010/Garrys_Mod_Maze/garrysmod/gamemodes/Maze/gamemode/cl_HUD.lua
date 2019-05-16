include('cl_anim.lua')

--------------------------
--
-- This is the HUD (obiously) ive done lots of tweaking, 
-- which i eventually intend to clean up.
--
--------------------------

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do 
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud) 

local blockmap={}

usermessage.Hook("MazeTime",function(um)
	timet=um:ReadLong()
	nt=um:ReadString()
	ot=txt or "Waiting for Gamemode..."
	anim:setup("box anim",{4, ScrH() - 54, bw, 50,(#(nt)*16),nil,ot,nt})
	txt=nt
	bw=(#(txt)*16)
	if txt== "Maze Time!" then
		anim:setup("mazetime",{}) end
	cl_gmmpredict_reset()
	disorient=false
end)
usermessage.Hook("landmark",function(um)
	endp=um:ReadVector()
end)
usermessage.Hook("tick",function(um)
	timet=um:ReadLong()
	LocalPlayer():SetNWInt("distance",cl_gmmGetDist())
	
end)
usermessage.Hook("PlayerWin",function(um)
	ply=um:ReadString()	
	if ply==LocalPlayer():Nick() then
		anim:setup("player win",{"You"})
	else
		anim:setup("player win",{ply})
	end
end)
usermessage.Hook("pload1",function(um)
	anim:setup("inform",{"Profile Loading..."})
end)
usermessage.Hook("pload2",function(um)
	anim:setup("inform",{"Profile Successfully Loaded."})
end)
usermessage.Hook("psave",function(um)
	anim:setup("inform",{"Profile Saved."})
end)
usermessage.Hook("disorient",function(um)
	disorient=true
	d_frame=0
end)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- perk functions 
----------------------------------------------------------------------------------------------------------------------------------
function cl_gmmpredict()
	for k,v in pairs(ents.FindByClass("func_movelinear")) do
		v:SetColor(255,255,255,255)
		if v:GetNWBool("change") && txt=="Maze Time!"then
			v:SetColor(255,0,0,255) end
	end
end

function cl_gmmpredict_reset()
	for k,v in pairs(ents.FindByClass("func_movelinear")) do
		v:SetColor(255,255,255,255)
	end
end

function cl_gmmGetDist()
	local ep,pl
	pl=LocalPlayer():GetPos()
	ep=endp or Vector(0,0,0)
	local dist
	dist=math.Dist(ep.x,ep.y,pl.x,pl.y)
	dist=math.Round(dist)
	if LocalPlayer():GetNWBool("win") then dist=0 end
	return dist
end

function cl_gmmdistance()
	local dist=cl_gmmGetDist()
	local ox
	ox=40
	draw.RoundedBox(4,ScrW()-130-ox-4,0, 140+ox,40, g_bcolor)
	draw.RoundedBox(4,ScrW()-130-ox,0, 132+ox,36, g_fcolor)
	draw.SimpleText("Distance:" .. tostring(dist),font, ScrW()-126-ox, 2, Color(255,255,255,255),0,0)
end

function get_yaw()
	local y=g_yaw
	if !y then y=0 end
	local b=LocalPlayer():GetAngles().y
	if disorient then
		if LocalPlayer():GetNWBool("gs_reorientT") && d_frame>120 then
			disorient=false
			reorient=true
		end
		d_frame=d_frame+1
		y=math.random(1,360)
		g_yaw=y
		return y
	end
	if reorient then
		if b<y then y=y-2
		elseif y<b then y=y+2 end
		local r=y-b
		if math.abs(r)<4 then
			y=b
			reorient=false
		end
		g_yaw=y
		return y
	end
		
	return LocalPlayer():GetAngles().y
end

function cl_gmmcompass(hasmap)
	
	
	draw.RoundedBox(4, 0,0, 208,208, g_bcolor)
	if !hasmap then
		draw.RoundedBox(4, 0,0, 200,200, g_fcolor)

		surface.SetTexture(surface.GetTextureID("gmmaze/hud_compass_spindle"))
		surface.SetDrawColor(0,0,0,128) 
		surface.DrawTexturedRect(35,35,128,128)
		
		surface.SetTexture(surface.GetTextureID("gmmaze/hud_compass_spindle"))
		surface.SetDrawColor(255,255,255,128) 
		surface.DrawTexturedRect(33,33,128,128)
	else
		draw.RoundedBox(4, 0,0, 200,200, Color(128,128,128,200))
	end
	
	surface.SetTexture(surface.GetTextureID("gmmaze/hud_compass_base"))
	surface.SetDrawColor(255,255,255,255) 
	if disorient then 
		surface.SetDrawColor(255,255,255,128) 
	end
	surface.DrawTexturedRectRotated(97,97,196,196,360-get_yaw())
end

function cl_paint_map(haspredict)
	local p
	local p2=LocalPlayer():GetPos()
	local yaw=get_yaw()
	local a
	local x,y=95,95
	draw.NoTexture()
	for k,v in pairs(ents.FindInSphere(p2,512)) do
			p=v:GetPos()
			p=LocalPlayer():WorldToLocal(p)
			p:Rotate(Angle(LocalPlayer():GetAngles().p),0,0)
			a=math.floor(255-math.Dist(p.x,p.y,0,0)/2)
			p.x=p.x/8
			p.y=p.y/8
			p:Rotate(Angle(0,270,180))
			if a<0 then a=0 end
			surface.SetDrawColor(96,0,0,a)
			if v:GetNWBool("open")==false  then
				surface.SetDrawColor(0,0,96,a)
			end
			if v:GetNWBool("change") && haspredict then
				surface.SetDrawColor(0,96,0,a)
			end
			if !disoriented then
				surface.DrawTexturedRectRotated((p.x)+x+8,(p.y)+y+8,16,16,360-yaw)
			end
	end
	draw.RoundedBox(4,x+4,y+4,8,8,Color(0,96,0,200))
end

function paint_perks()
	if false then -- print all
		cl_gmmdistance()
		cl_gmmcompass(true)
		cl_gmmpredict()
		cl_paint_map(true)
	else
		if LocalPlayer():GetNWBool("pdistanceT") then
			cl_gmmdistance() end
		if LocalPlayer():GetNWBool("compassT") then
			if LocalPlayer():GetNWBool("mapT") then
				cl_gmmcompass(true) 
				cl_paint_map(LocalPlayer():GetNWBool("predictionT"))
			else
				cl_gmmcompass(false) end
		end
		if LocalPlayer():GetNWBool("predictionT") then
			cl_gmmpredict() end
	end
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- end perk functions 
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local healthbar={}			---- this is unfinished, i plan to add some stuff to it later

function healthbar:paint()
	--if self.show && !self.inanim then
		local h=LocalPlayer():Health()
		local h2=h
		draw.RoundedBox(4,ScrW()/2-98,ScrH()-48,196,100,Color(0,0,0,64))
		draw.RoundedBox(4,ScrW()/2-94,ScrH()-44,188,100,Color(128,128,128,64))
		if h<=0 then h=4 end
		draw.RoundedBox(4,ScrW()/2-94,ScrH()-44,math.floor(188*h/100),100,Color(255-(255*h/100),0,h,200))
		draw.SimpleText("Health: " .. h2,"Trebuchet18",ScrW()/2,ScrH()-22,Color(255,255,255,128),1,1)
	--end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

hook.Add("Initalize",function()
	g_fcolor=Color( 0,0,96,200)
	g_bcolor=Color(0,0, 0,64)
	
end)

surface.CreateFont ("coolvetica", 32, 400, true, false, "maze_font")
surface.CreateFont ("coolvetica", 12, 400, true, false, "maze_font2")

function GM:HUDPaint()
	g_fcolor=Color( 0,0,96,200)
	g_bcolor=Color(0,0, 0,64)
	font="maze_font"
	
	if !anim:exists("box anim") then 
		bw=bw or 300
		draw.RoundedBox(4, 0, ScrH() - 58, bw+8, 58, g_bcolor)
		draw.RoundedBox(4, 4, ScrH() - 54, bw, 50, g_fcolor)
		
		draw.SimpleText(txt, font, 16, ScrH() - 38, Color(255,255,255,255),0,0)
	end
	
	
	
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
	
	
	
	draw.RoundedBox(4, ScrW()-136, ScrH() - 58, 136, 58, g_bcolor)
	draw.RoundedBox(4, ScrW()-132, ScrH() - 54, 128, 50, g_fcolor)
	
	
	paint_perks()
	
	
	local o2={}
	o2.x=0
	o2.y=0
	draw.RoundedBox(4, ScrW()/2-128+o2.x,0+o2.y,256,44, g_bcolor)
	draw.RoundedBox(4, ScrW()/2-124+o2.x,4+o2.y,144,36, g_fcolor)
	draw.RoundedBox(4, ScrW()/2+24+o2.x,4+o2.y,100,36, g_fcolor)
	
	local o={}
	o.x=4
	o.y=4
	draw.SimpleText("Time Left:",font, ScrW()/2-120+o.x+2+o2.x, 6+o.y+o2.y, Color(0,0,0,255),0,0)
	draw.SimpleText("Time Left:", font, ScrW()/2-120+o.x+o2.x, 4+o.y+o2.y, Color(255,255,255,255),0,0)
	draw.SimpleText(tm, font, ScrW()/2+28+2+24+o2.x, 6+o.y+o2.y, Color(0,0,0,255),0,0)
	draw.SimpleText(tm, font, ScrW()/2+28+24+o2.x, 4+o.y+o2.y, Color(255,255,255,255),0,0)

	healthbar:paint()
	
	anim:think()
	draw.SimpleText("What's going on?", "maze_font2", 16, ScrH() - 52, Color(255,255,255,255),0,0)
	draw.SimpleText(GetGlobalString("version"),font,ScrW()-62,ScrH()-29,Color(0,0,0,255),1,1)
	draw.SimpleText(GetGlobalString("version"),font,ScrW()-64,ScrH()-27,Color(255,255,255,255),1,1)
	
end

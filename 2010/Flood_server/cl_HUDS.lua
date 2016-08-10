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


usermessage.Hook("floodtime",function(um)
	nt=um:ReadString()
	ot=txt or "Waiting for Gamemode..."
	anim:setup("box anim",{4, ScrH() - 54, bw, 50,(#(nt)*16),nil,ot,nt})
	txt=nt
	bw=(#(txt)*16)

end)
usermessage.Hook("Tick",function(um)
	timet=um:ReadLong()
end)




function GetAmmo()

	if ( ! ValidEntity(LocalPlayer():GetActiveWeapon())) then return -1 end
 
	return LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
end


hook.Add("Initalize",function()
	g_fcolor=Color( 0,0,96,200)
	g_bcolor=Color(0,0, 0,64)
end)

function GM:HUDPaint()

	g_fcolor=Color( 0,0,96,200)
	g_bcolor=Color(0,0, 0,64)
	
	surface.CreateFont ("coolvetica", 32, 400, true, false, "flood_font")
	surface.CreateFont ("coolvetica", 12, 400, true, false, "flood_font2")
	font="flood_font"
	
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
	
	local o2={}
	o2.x=-134
	o2.y=0
	draw.RoundedBox(4, ScrW()/2-128+o2.x,0,256+o2.y,44, g_bcolor)
	draw.RoundedBox(4, ScrW()/2-124+o2.x,4,144+o2.y,36, g_fcolor)
	draw.RoundedBox(4, ScrW()/2+24+o2.x,4,100+o2.y,36, g_fcolor)
	
	local o3={}
	o3.x=160
	local c=LocalPlayer():GetNWInt("cash")
	c=math.floor(c/1000)
	c=#(tostring(c))
	draw.RoundedBox(4, ScrW()/2+64+o3.x,0,156+c*10,44, g_bcolor)
	draw.RoundedBox(4, ScrW()/2+68+o3.x,4,148+c*10,36, g_fcolor)
	draw.SimpleText("Cash: " .. tostring(LocalPlayer():GetNWInt("cash")), font, ScrW()/2+68+o3.x+8,8, Color(255,255,255,255),0,0)
	
	local o={}
	o.x=4
	o.y=4
	draw.SimpleText("Time Left:",font, ScrW()/2-120+o.x+2+o2.x, 6+o.y+o2.y, Color(0,0,0,255),0,0)
	draw.SimpleText("Time Left:", font, ScrW()/2-120+o.x+o2.x, 4+o.y+o2.y, Color(255,255,255,255),0,0)
	draw.SimpleText(tm, font, ScrW()/2+28+2+24+o2.x, 6+o.y+o2.y, Color(0,0,0,255),0,0)
	draw.SimpleText(tm, font, ScrW()/2+28+24+o2.x, 4+o.y+o2.y, Color(255,255,255,255),0,0)

	draw.RoundedBox(4, ScrW()-136, ScrH() - 44, 136, 44, g_bcolor)
	draw.RoundedBox(4, ScrW()-132, ScrH() - 40, 128, 36, g_fcolor)
	
	
	o.x=ScrW()/2-174
	draw.RoundedBox(4, o.x, ScrH() - 50, 156, 64, g_bcolor)
	draw.RoundedBox(4,4+ o.x, ScrH() - 46, 148, 64, g_fcolor)
	draw.SimpleText("Health: " .. tostring(LocalPlayer():Health()), font, 12+o.x, ScrH()-38, Color(255,255,255,255),0,0)
	
	o.x=o.x+192
	draw.RoundedBox(4, o.x, ScrH() - 50, 156, 64, g_bcolor)
	draw.RoundedBox(4, 4+o.x, ScrH() - 46, 148, 64, g_fcolor)
	draw.SimpleText("Ammo: " .. tostring(GetAmmo()), font,12+ o.x, ScrH()-38, Color(255,255,255,255),0,0)
	
	
	anim:think()
	draw.SimpleText("What's going on?", "flood_font2", 16, ScrH() - 52, Color(255,255,255,255),0,0)
	draw.SimpleText("[iG] Flood",font,ScrW()-126,ScrH()-34,Color(0,0,0,255),0,0)
	draw.SimpleText("[iG] Flood",font,ScrW()-128,ScrH()-36,Color(255,255,255,255),0,0)
	
	
	local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))

	if (tr.Entity:IsValid() and !tr.Entity:IsPlayer()) then
		if tr.Entity:GetNWInt("PropHealth") == "" or tr.Entity:GetNWInt("PropHealth") == nil or tr.Entity:GetNWInt("PropHealth") == NULL then
			local PH = "Fetching"
			draw.SimpleText(PH, "MenuLarge", ScrW()/2, ScrH()/2 - 25, Color(0,255,0,255),1,1)
		else
			PH = "Health: " .. tr.Entity:GetNWInt("PropHealth")
			draw.SimpleText(PH, "MenuLarge", ScrW()/2, ScrH()/2 - 25, Color(0,255,0,255),1,1)
		end

		local PO = tr.Entity:GetNetworkedEntity("Owner")
		if ValidEntity(PO) then
			local Text = "Owner: " .. PO:Nick()
			surface.SetFont("Default")
			local Width, Height = surface.GetTextSize(Text)
			Width = Width + 25
			draw.RoundedBox(4, ScrW() - (Width + 8), (ScrH()/2 - 200) - (8), Width + 8, Height + 8, Color(0, 0, 0, 150))
			draw.SimpleText(Text, "Default", ScrW() - (Width / 2) - 7, ScrH()/2 - 200, Color(255, 255, 255, 255), 1, 1)
		else
			local Text = "Owner: Fetching..."
			surface.SetFont("Default")
			local Width, Height = surface.GetTextSize(Text)
			Width = Width + 25
			draw.RoundedBox(4, ScrW() - (Width + 8), (ScrH()/2 - 200) - (8), Width + 8, Height + 8, Color(0, 0, 0, 150))
			draw.SimpleText(Text, "Default", ScrW() - (Width / 2) - 7, ScrH()/2 - 200, Color(255, 255, 255, 255), 1, 1)
		end
	end

	if (tr.Entity:IsValid() and tr.Entity:IsPlayer()) then
		PlayerName = "Name: " .. tr.Entity:GetName()
		PlayerHealth = "Health: " .. tr.Entity:Health()
		draw.RoundedBox(4, ScrW()/2-#PlayerName*5-4, ScrH()/2-12-75, #PlayerName*10+8, 42, g_bcolor)
		draw.RoundedBox(4, ScrW()/2-#PlayerName*5, ScrH()/2-8-75, #PlayerName*10, 34, g_fcolor)
		draw.SimpleText(PlayerName, "MenuLarge", ScrW()/2, ScrH()/2 - 75, Color(255,255,255,255),1,1)
		draw.SimpleText(PlayerHealth, "MenuLarge", ScrW()/2, ScrH()/2 - 60, Color(255,255,255,255),1,1)
	end
end

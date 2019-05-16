include('shared.lua')

---------------------------------------------------
-----		Score board
---------------------------------------------------

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

function GM:ScoreboardShow()
	ShowSB = true
	calch()
end

function GM:ScoreboardHide()
	ShowSB = false
end



function drawTeam(y,i,info)
	local rowh=32
	local row=1
	local newy=y+(#info-1)*rowh
	local clr=team.GetColor(i)
	local pls=#info-1
	draw.RoundedBox(4,of.x,y,width,rowh+newy-y-4,color[1])
	
	draw.RoundedBox(4,of.x+4,y+4,32,24+newy-y-4,clr)
	
	local ry=row*(rowh-2)+y
	local w=math.floor((width-60)/6)
	
	draw.RoundedBox(4,of.x+w*3-26,y+4,w  ,24+newy-y-4,Color(255,255,255,100))
	draw.RoundedBox(4,of.x+w*5-10,y+4,w-8,24+newy-y-4,Color(255,255,255,100))
	draw.RoundedBox(4,of.x+4,y+4,width-8,rowh-8,clr)
	draw.SimpleText(info[1],font,ScrW()/2+2,y+6,Color(0,0,0,255),1)
	draw.SimpleText(info[1],font,ScrW()/2,y+5,Color(255,255,255,255),1)
	
	for k,v in pairs(info) do
		if k>1 then
			if v[1]==LocalPlayer():Nick() then
				draw.RoundedBox(4,of.x+36,ry-2,width-40,rowh-4,Color(0,0,96,100))
			end
			draw.SimpleText(v[1],"Trebuchet24",of.x+48 ,ry,Color(255,255,255,255))
			draw.SimpleText(v[2],"Trebuchet24",of.x+w*3-16,ry,Color(255,255,255,255))
			draw.SimpleText(v[3],"Trebuchet24",of.x+w*4,ry,Color(255,255,255,255))
			draw.SimpleText(v[4],"Trebuchet24",of.x+w*5,ry,Color(255,255,255,255))
			draw.SimpleText(v[5],"Trebuchet24",of.x+w*6,ry,Color(255,255,255,255))
			row=row+1
			ry=row*(rowh-1)+y
		end
	end
	return newy+32
end

function calch()
	local h=96+4+32+4  -- inital value is the top stuff
	
	
	-- get how manyteams have players
	for i=0,10 do
		if #team.GetPlayers(i)>=1 then
			h=h+36
		end
	end
	
	-- how many players there are
	for k,v in pairs(player.GetAll()) do
		h=h+32
	end
	of={x=ScrW()/4,y=(ScrH()-h-256)/2}
end

function GM:HUDDrawScoreBoard()
	
	if (!ShowSB) then return end
	
	if (ScoreDesign == nil) then
	
		ScoreDesign = {}
		ScoreDesign.HeaderY = 0
		ScoreDesign.Height = ScrH() / 2
	
	end
	font="ScoreboardText"
	color={
		Color(0,0,0,64),
		Color(0,0,96,200),
		Color(128,128,196,255)}


	width = ScrW() -of.x*2
	height = ScrH()-of.y*2
	local rowh=32
	local row=1
	draw.RoundedBox(4,of.x,of.y,width,96,color[1])
	draw.RoundedBox(4,of.x+4,of.y+4,width-8,88,color[2])
	draw.SimpleText(GetHostName(),"HUDNumber",ScrW()/2,of.y+4,Color(255,255,255,255),1)
	draw.SimpleText("Garry's Mod: Maze, Created By Thor.",font,ScrW()/2,of.y+60,Color(255,255,255,255),1)
	
	draw.RoundedBox(4,of.x,of.y+100,width,rowh,color[1])
	draw.RoundedBox(4,of.x+4,of.y+104,width-8,rowh-8,color[2])
	
	local w=math.floor((width-60)/6)
	draw.SimpleText("Player:",font,of.x+10+32+8,of.y+106,Color(255,255,255,255))
	draw.SimpleText("Points:",font,of.x+w*3-16 ,of.y+106,Color(255,255,255,255))
	draw.SimpleText("Time:"  ,font,of.x+w*4	   ,of.y+106,Color(255,255,255,255))
	draw.SimpleText("Status:",font,of.x+w*5	   ,of.y+106,Color(255,255,255,255))
	draw.SimpleText("Ping:"  ,font,of.x+w*6	   ,of.y+106,Color(255,255,255,255))
	
	local name,points,timet,status,ping
	
	local teamd={},y
	y=of.y+100+rowh+4
	for ID,TM in pairs(team.GetAllTeams()) do
		table.insert(teamd,TM.Name)
		for k,v in pairs(team.GetPlayers(ID)) do
			name=v:Nick()
			points=v:GetNWInt("points")
			timet=format_time(v:GetNWInt("time"))
			status=v:GetNWString("status")
			ping=v:Ping()
			table.insert(teamd,{name,points,timet,status,ping})
		end
		if #teamd>1 then
			y=drawTeam(y,ID,teamd)
		end
		teamd={}
	end
	draw.RoundedBox(4,of.x,y,width,32,color[1])
	draw.RoundedBox(4,of.x+4,y+4,width-8,24,color[2])
	
end
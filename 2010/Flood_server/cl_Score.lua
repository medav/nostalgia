include('shared.lua')

function GM:ScoreboardShow()
	ShowSB = true
end

function GM:ScoreboardHide()
	ShowSB = false
end

// TODO: CLEAN THIS CODE

function GM:GetTeamScoreInfo()

	local TeamInfo = {}
	local teamd={}
	local players={}
	local i=0
	local name,cash,member,alive,ping
	for i=0,10 do
		table.insert(teamd,team.Name(i))
		for k,v in pairs(team.GetPlayers(i)) do
			name=v:Nick()
			cash=v:GetNWInt("cash")
			member=v:GetNWString("membership") or "Guest"
			if v:IsAlive() then
				alive="Alive"
			else
				alive="Dead"
			end
			ping=v:Ping()
			table.insert(players,{name,cash,member,alive,ping})
		end
		table.insert(teamd,players)
		players={}
		table.insert(TeamInfo,teamd)
		teamd={}
	end
	
	return TeamInfo
end

function GM:HUDDrawScoreBoard()
	
	if (!ShowSB) then return end
	
	if (ScoreDesign == nil) then
	
		ScoreDesign = {}
		ScoreDesign.HeaderY = 0
		ScoreDesign.Height = ScrH() / 2
	
	end
	font="ScoreboardText"
	local color={
		Color(0,0,0,64),
		Color(0,0,96,200)}

	local ScoreboardInfo = self:GetTeamScoreInfo()

	local of={x=ScrW() / 10,y=32}
	local width = scrWidth - (2* of.y)
	local height = scrHeight-of.y*2
	local rowh=20
	local row=1
	draw.RoundedBox(4,of.x,of.y,width,64,color[1])
	draw.RoundedBox(4,of.x+4,of.y+4,width-8,56,color[2])
	draw.SimpleText(GetHostName(),font,ScrW()/2,of.y,Color(255,255,255,255),1)
	draw.SimpleText(GM.Author,font,ScrW()/2,of.y+32,Color(255,255,255,255),1)
	
	draw.RoundedBox(4,of.x,of.y+68,width,rowh,color[1])
	draw.RoundedBox(4,of.x+4,of.y+72,width-8,rowh-8,color[2])
	draw.SimpleText("Player:",font,of.x+8,of.y+80,Color(255,255,255,255),)
	
end
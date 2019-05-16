include("shared.lua")

local suprises={
	"gs_pusher",
	"gs_teleport",
	"gs_bomb",
	"gs_disorient"
}


function maze_reset()
	for k, v in pairs(ents.FindByName("block")) do
		v:Fire("Close","",0)
		v:SetNWBool("open",false)
	end
	for k, v in pairs(ents.FindByName("startp")) do
		v:Fire("Close","",0)
	end
	
	for k, v in pairs(player.GetAll()) do 
		v:SetNWString("status","Waiting")
		save_profile(v)
	end

	timer.Destroy("maze")
	timer.Destroy("player_pos")
end

function send_win(ply)
	umsg.Start("PlayerWin")
	umsg.String(ply:Nick())
	umsg.End()
	
	ply:SetNWInt("position",players_won)
	ply:SetNWInt("points",ply:GetNWInt("points")+750)
	save_profile(ply)
end
function update_player_pos()
	local p,rect
	for k, v in pairs(player.GetAll()) do
		local p=v:LocalToWorld(v:OBBCenter())
		for _, e in pairs(ents.FindByName("block")) do
			local ep=e:LocalToWorld(e:OBBCenter())
			if math.Dist(p.x,p.y,ep.x,ep.y)<175 then
				e:SetNWBool(v:Nick(),true)
			else
				v:SetNWInt("blockpos",nil)
				e:SetNWBool(v:Nick(),false)
			end
			
		end
		for _, e in pairs(ents.FindByName("EndP")) do
			if v:GetPos().x>e:GetPos().x && !v:GetNWInt("win") then
				v:SetNWBool("win",true) 
				v:SetNWString("status","Finished")
				send_win(v)
				end
		end
		if !v:GetNWBool("win") then 
			v:SetNWInt("time",mazetime-g_time)
		end
	end

end
function no_player_on(ent)
	for k, v in pairs(player.GetAll()) do
		if ent:GetNWBool(v:Nick()) then return false end
	end
	return true
end



function random_event(block)
	if math.random(1,8)== 1 then
		suprise=ents.Create(suprises[math.random(1,#suprises)])
		local pos=block:LocalToWorld(block:OBBCenter())
		pos:Add(Vector(0,0,-16))
		suprise:SetPos(pos)
		suprise:SetLife(g_time,math.random(10,20))
		suprise:Spawn()
	end
end



local m_mode
function maze_think()
	

	
	if m_mode==2 then
		for k, v in pairs(ents.FindByName("block")) do
			if v:GetNWBool("open")  then
				if math.random(1,3)==2 then
					v:SetNWBool("change",true)
				end
			else
				if math.random(1,5)==2 then
					v:SetNWBool("change",true)
				end
			end
			
			
		end
	elseif m_mode==3 then
		for k,v in pairs(ents.FindByName("block")) do
			if v:GetNWBool("change") then
				if v:GetNWBool("open") then
					v:Fire("Close","",0)
					random_event(v)
					v:SetNWBool("open",!(v:GetNWBool("open")))
				elseif  no_player_on(v) then
					v:Fire("Open","",0)
					v:SetNWBool("open",!(v:GetNWBool("open")))
				end
				v:SetNWBool("change",false)
			end
		end
		m_mode=0
	end
	m_mode=m_mode+1
	
end

function player_pos()
	if !mode==2 then return end
	update_player_pos()
end


function maze_setup()
	for k, v in pairs(player.GetAll()) do
		v:SetNWBool("win",false) 
		v:SetNWInt("distance",0) 
		v:SetNWString("status","In Maze")
		v:SetNWBool("position",0) 
		
		if v:GetNWBool("super-speed") then
			v:SetRunSpeed(800)
		end
		save_profile(v)
	end
	predict=true
	m_mode=1
	maze_think()
	maze_think()
	maze_think()
	timer.Create( "maze",1, 0, maze_think)
	timer.Create("player_pos",1,0,player_pos)
	for k, v in pairs(ents.FindByName("startp")) do
		v:Fire("Open","",0)
	end
	
	players_won=1
end



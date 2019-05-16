AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "cl_HUD.lua" )
AddCSLuaFile( "cl_anim.lua" )  
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "shared.lua" ) 
AddCSLuaFile("cl_score.lua")
include( "shared.lua" )
include( "maze.lua" )

mazetime=360s
local rtime=15
g_time=0
mode=0
local round
local pause
local start
local should_update_map
SetGlobalString("Version","Maze v1")

function GM:Initialize()
	pause = false
	start = false
	round =1
	umsg.Start("Start")
		umsg.Long(mazetime)
	umsg.End()
	for _, e in pairs(ents.FindByName("EndP")) do
		umsg.Start("landmark")
		umsg.Vector(e:GetPos())
		umsg.End()
	end
	should_update_map=false
	g_time=rtime+30
	mode=1
	timer.Create("Timer", 1, 0, timerfunc)
	umsg.Start("MazeTime")
		umsg.Long(g_time)
		umsg.String("Round Starting...")
	umsg.End()
	update_player_pos()
	for k, v in pairs(ents.FindByName("block")) do
		v:Fire("Close","",0)
		v:SetNWBool("open",false)
		v:SetNWBool("block",true)
	end
	vscore=ents.Create("vscoreboard")
	
end

function timerfunc()
	if mode==1 then
		if g_time<1 or start then
			start=false
			mode=2
			maze_setup()
			g_time=mazetime
			umsg.Start("MazeTime")
				umsg.Long(g_time)
				umsg.String("Maze Time!")
			umsg.End()
		end
	elseif mode==2 then
		if g_time<1 then
			mode=3
			maze_reset()
			g_time=rtime
			umsg.Start("MazeTime")
				umsg.Long(g_time)
				umsg.String("Round Ending...")
			umsg.End()
		end
	else
		if g_time<1 then
			for k, v in pairs(player.GetAll()) do
				if v:Alive() then v:KillSilent() end
			end
			mode=1
			g_time=rtime
			umsg.Start("MazeTime")
				umsg.Long(g_time)
				umsg.String("Round Starting...")
			umsg.End()
		end
	end
	if !pause then 
		g_time=g_time-1
	end
	umsg.Start("tick")
	umsg.Long(g_time)
	umsg.End()
end

function save_profile(ply)
	local profile = "GmMazeProfiles/" ..string.Replace(ply:SteamID(),":","_") .. ".txt"
	local out=tostring(ply:GetNWInt("points")) .. "\n"
	for k,v in pairs(gmm_perks) do
		if ply:GetNWBool(k) then
			out=out .. k .. "\n"
		end
	end
	for k,v in pairs(gmm_protection) do
		if ply:GetNWBool(k) then
			out=out .. k .. "\n"
		end
	end
	file.Write(profile,out)
	umsg.Start("psave",ply)
	umsg.End()
end

function load_profile(ply)
	umsg.Start("pload1",ply)
	umsg.End()
	local profile = "GmMazeProfiles/" ..string.Replace(ply:SteamID(),":","_") .. ".txt"
	ply:SetNWString("enabled_protection","")
	if file.Exists(profile) then
		local data=string.Explode("\n",file.Read(profile))
		ply:SetNWInt("points", tonumber(data[1]))
		table.remove(data,1)
		for k,perk in pairs(data) do
			if perk=="super-speed" then
				ply:SetRunSpeed(1000)
			end
			ply:SetNWBool(perk,true)
			set_prot(ply,perk,true)
		end
	else
		ply:SetNWInt("points",0)
	end
	umsg.Start("pload2",ply)
	umsg.End()
end

function set_prot(ply,name,enable)
	ply:SetNWBool(name .. "T", enable)
end
function get_prot_status(ply,name)
	return ply:GetNWBool(name .. "T")
end
function set_perk(ply,name,enable)
	ply:SetNWBool(name .. "T", enable)
end
function get_perk_status(ply,name)
	return ply:GetNWBool(name .. "T")
end

concommand.Add("gmm_purchase_perk",function(ply,command,args)
	local data=gmm_perks[args[1]]
	if !data then
		return
	end
	if ply:GetNWInt("points")>=data.cost && !ply:GetNWBool(args[1]) then
		ply:SetNWBool(args[1],true)
		ply:ChatPrint("You purchased: " .. args[1])
		ply:SetNWInt("points",ply:GetNWInt("points")-data.cost)
		save_profile(ply)
		if args[1]=="super-speed" then
			ply:SetRunSpeed(800)
		end
		set_perk(ply,args[1],true)
	elseif ply:GetNWBool(args[1]) then
		ply:ChatPrint("You already own this!")
	else
		ply:ChatPrint("You don't have enough points for this!")
	end
end)

concommand.Add("gmm_purchase_protection",function(ply,command,args)
	local data=gmm_protection[args[1]]
	if !data then
		return
	end
	if ply:GetNWInt("points")>=data.cost && !ply:GetNWBool(args[1]) then
		ply:SetNWBool(args[1],true)
		ply:ChatPrint("You purchased protection for: " .. args[1])
		ply:SetNWInt("points",ply:GetNWInt("points")-data.cost)
		set_prot(ply,args[1],true)
		save_profile(ply)
	elseif ply:GetNWBool(args[1]) then
		ply:ChatPrint("You already own this!")
	else
		ply:ChatPrint("You don't have enough points for this!")
	end
end)

concommand.Add("gmm_toggle_protection",function(ply,command,args)
	local name =args[1]
	if ply:GetNWBool(name) then
		set_prot(ply,name,!get_prot_status(ply,name))
	else
		ply:ChatPrint("You don't own this.")
	end
end)

concommand.Add("gmm_toggle_perk",function(ply,command,args)
	local name =args[1]
	if ply:GetNWBool(name) then
		set_perk(ply,name,!get_perk_status(ply,name))
	else
		ply:ChatPrint("You don't own this.")
	end
end)

function GM:PlayerInitialSpawn(ply)
	ply:SetModel("models/player/Kleiner.mdl") 
	ply:SetNWString("status","Waiting")
	if mode==2 then
		ply:SetNWString("status","In Maze")
	end
	ply:SetTeam(1)
	local txt = ""
	if mode==1 then
		txt="Round Starting..."
	elseif mode==2 then
		txt="Maze Time!"
	elseif mode==3 then
		txt="Round Ending..."
	end
	umsg.Start("MazeTime",ply)
		umsg.Long(g_time)
		umsg.String(txt)
	umsg.End()
	ply:SetNWBool("win",false) 
	ply:SetNWInt("points",0)
	for _, e in pairs(ents.FindByName("EndP")) do
		umsg.Start("landmark")
		umsg.Vector(e:GetPos())
		umsg.End()
	end
	load_profile(ply)
	
end

function GM:PlayerShouldTakeDamage(victim ,attacker ) 
	if victim:IsPlayer() && attacker:GetClass()=="gs_bomb" && get_prot_status(victim,"gs_bomb") then
		return false else
		return true end
		
	if	victim:IsPlayer() && attacker:IsPlayer() then return false end
	

end

hook.Add("PlayerSpawn","spawnf",function(ply)
	ply:SetNWBool("win",false)
end)


concommand.Add("gmm_zerot",function(player,command,args)
	if !player:IsAdmin() then return end
	g_time=1
end)

concommand.Add("gmm_start",function(player,command,args)
	if !player:IsAdmin() then return end
	start=true
end)

concommand.Add("gmm_pause",function(player,command,args)
	if !player:IsAdmin() then return end
	pause=!pause
end)

concommand.Add("gmm_allup",function(player,command,args)
	if !player:IsAdmin() then return end
	for k, v in pairs(ents.FindByName("block")) do
		v:Fire("Close","",0)
		v:SetNWBool("open",false)
	end
end)

concommand.Add("gmm_alldn",function(player,command,args)
	if !player:IsAdmin() then return end
	for k, v in pairs(ents.FindByName("block")) do
		v:Fire("Open","",0)
		v:SetNWBool("open",true)
	end
end)

concommand.Add("gmm_change",function(player,command,args)
	if !player:IsAdmin() then return end
	traceRes=player:GetEyeTrace()
	if traceRes.Entity:IsValid() && traceRes.Entity:GetName()=="block" then
		v=traceRes.Entity
		if v:GetNWBool("open") then
			v:Fire("Close","",0)
		else
			v:Fire("Open","",0)
		end
		v:SetNWBool("open",!(v:GetNWBool("open")))
	end
end)

function findplayer(name)
	for k,v in pairs(player.GetAll()) do
		if string.find(v:GetName(),name) then return v end
	end
end
concommand.Add("gmm_superspeed",function(player,command,args)
	if !player:IsAdmin() then return end
	p=findplayer(args[1])
	if p then p:SetRunSpeed(1000) end
end)

concommand.Add("gmm_takesuperspeed",function(player,command,args)
	if !player:IsAdmin() then return end
	p=findplayer(args[1])
	if p then p:SetRunSpeed(500) end
end)

function GM:PlayerLoadout(ply)
	ply:Give("weapon_crowbar")
end

function GM:PlayerNoClip(ply)
	return ply:IsAdmin()
end

hook.Add("InitPostEntity","scoreboard",function()
	vscore:Spawn()
end)
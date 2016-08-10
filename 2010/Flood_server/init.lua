AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_HUDS.lua")
AddCSLuaFile("cl_Menu.lua")
AddCSLuaFile("cl_Score.lua")
AddCSLuaFile("cl_anim.lua")
AddCsLuaFile("cl_DSkin.lua")

include("shared.lua")
include("PP.lua")
include("CS.lua")
include("Players.lua")

SetGlobalString("version","[iG] Flood")

BV = 300
FV = 10
FIV = 720
RV = 15
WP = 1
PS = 5
CS = 60
g_time=0
FM_PAUSE=false
START=false 
fm_ap={false}
function GM:Initialize()

	TimerStatus = 1
	g_time=BV
	
	if file.Exists("FloodBans/Bans.txt") then
		BanTable = util.KeyValuesToTable(file.Read("FloodBans/Bans.txt"))
		print("=======================================")
		print("============Ban file loaded============")
		print("=======================================")
	else
		BanTable = {}
		file.Write("FloodBans/Bans.txt", util.TableToKeyValues(BanTable))
		print("======================================")
		print("===========Ban file created===========")
		print("======================================")
	end
	
	


	timer.Create("TimeWarp", 1, 0, TimeWarp)
	timer.Create("antipiracy",1,0, antipiracy)
end

function rocket(ply)
	timer.Create(ply:Nick() .. "_isstupid",1,3,function()
		ply:SetVelocity(VectorRand()*10000) 
		ply:TakeDamage(15,ply)
	end)
	ply:SetVelocity(VectorRand()*10000) 
	ply:TakeDamage(15,ply)
end

money_round={
	"money round",
	"Money Round",
	"money Round",
	"Money round",
	"moneyround",
	"Moneyround"
}
hook.Add("PlayerSay","fm_commands",function (ply, text, team, death )
	 if text=="votestart" ||  text=="VoteStart" ||  text=="Votestart" ||  text=="I vote to start." then
		ply:SetNWBool("VoteStart",true)
		Msg("Player voted to start.\n")
		return "I vote to start."
	end
	for k,v in pairs(money_round) do
		if string.find(text,v) then
			timer.Create(ply:Nick() .. "_isstupid",1,3,function()
				ply:SetVelocity(VectorRand()*10000) 
				ply:TakeDamage(15,ply)
			end)
			ply:SetVelocity(VectorRand()*10000) 
			ply:TakeDamage(15,ply)
			return "I'm a stupid fish!"
		end
	end
	if text=="!save" then 
		SaveCash(ply)
	end
end)



hook.Add("PlayerSay","fm_saveprops",function (ply, text, team, death )
	if text=="!saveprops" then
			ply:SetNWBool("saveprops",!ply:GetNWBool("saveprops"))
			Msg("Player Toggled Save Props.\n")
		end
end)

hook.Add("PlayerSay", "fm_jointeam", function (ply, text, team, death)
		if TimerStatus == 1 then
				if string.len(text)>9 then
					if string.sub(text,1,9)=="!jointeam" then
						local team=tonumber(string.sub(text,10))
						if team==nil then return false end
						if team>=1 and team<11 and #player.GetAll()>3 then
							ply:SetTeam(team); ply:SetNWInt("T",team)
						end
						if #player.GetAll()<4 then ply:ChatPrint("Not enough players for teams.") end
						if ply:IsSuperAdmin() then ply:SetTeam(team); ply:SetNWInt("T",team) end
						if team>10 and !ply:IsSuperAdmin() then
							ply:ChatPrint("Not a valid team!")
						end
						return false
					end
				end
			end
end)
	    				
function FmStart( ply, command, arguments )
	if ply:IsAdmin() then 
		Msg("Admin started the round.\n")
		for k,v in pairs (player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK, "Admin: ".. ply.Nick(ply) .. " started the round." );
		end
		g_time=5
	end
end
concommand.Add("fm_start",FmStart)
function FmPause( ply, command, arguments )
	if ply:IsAdmin() then 
		Msg("Admin paused the round.\n")
		for k,v in pairs (player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK, "Admin: ".. ply.Nick(ply) .. " paused/unpaused the round." );
		end
		FM_PAUSE= (!FM_PAUSE) 
	end
end
concommand.Add("fm_pause",FmPause)
function TimeWarp()
	if !FM_PAUSE then 
			g_time= (g_time - 1)
		end

	if TimerStatus == 1 then
		BuildTimeFunc()
	elseif TimerStatus == 2 then
		FloodTimeFunc()
	elseif TimerStatus == 3 then
		FightTimeFunc()
	elseif TimerStatus == 4 then
		ReflectTimeFunc()
	end
	umsg.Start( "Tick" )
	umsg.Long( g_time )
	umsg.End()
end 

BTools = {
"camera", "dynamite", "emitter", "example", "eyeposer", 
"faceposer", "finger", "hoverball", "ignite", "inflator", 
"leafblower", "magnetise", "pulley", "rtcamera", "spawner",
"statue", "turret", "lamp", "light",
}

STools = {
"ballsocket_adv", "material", "paint", "physprop", 
"wheel", "colour", "nail", "thruster", "remover"
}
RTools={"ballsocket_adv", "physprop", 
"wheel", "colour", "nail", "thruster"
}
function GM:CanTool(pl, tr, tool)
	if tr.Entity:IsWorld() then pl:ChatPrint("Not a valid entity!"); return false
	elseif !tr.Entity:IsValid() then pl:ChatPrint("Not a valid entity!"); return false
	elseif tr.Entity:GetNetworkedEntity("Owner") != pl then pl:ChatPrint("This is not your prop!"); return false
	elseif tool == "remover" then pl:ChatPrint("Cannot not use the remover,\nuse the \"Prop Remover\" instead."); return false
	elseif table.HasValue(BTools, tool) or table.HasValue(RTools, tool) then
		if table.HasValue(BTools, tool) then
			if pl:IsAdmin() then
				return true
			else
				pl:ChatPrint("You must be an admin to use this.")
				return false
			end
		end
		if table.HasValue(RTools,tool) then
			if pl:IsAdmin() or pl:GetNWInt("IsAdmin")<=5 then return true
			else 
				pl:ChatPrint("This tool is vip+ only, check the donations page in the Q menu on how to get it.") 
				return false
			end
		end
	end
	return true
	--[[if table.HasValue(STools, tool) then
		if pl:IsAdmin() then
			return true
		else
			if tool == "remover" then
				pl:ChatPrint("Use the \"Remover Tool\" to remove props, this is the remover(Admins only)")
				return false
			
		end
	end
	else
		return true
	end--]]
end




function BuildTimeFunc()
	local int num_players=0
	local allplayers = player.GetAll( )
	if g_time <= 0 then
		for k, v in pairs(allplayers) do
			num_players=num_players+1		
		end
		if num_players<=1 then
		    	Msg("Not enough players to start the round.\n")
			for k,v in pairs ( allplayers ) do
 		  	  v:PrintMessage( HUD_PRINTTALK, "Not enough players to start the round." );
			end
			TimerStatus=1
			g_time=BV
			RemoveAllWeapons()
			GivePhysGuns()
			return
		end
		ResetHealth()
		TimerStatus = 2
		RemoveAllWeapons()
		UnfreezeProps()
		for k,v in pairs ( allplayers ) do
			v:SetNWBool("VoteStart",false)
		end
		g_time = FV
		umsg.Start( "floodtime" )
		umsg.String("Get on your boat!")
		umsg.End()
		
	else

		if !START then
			for k,v in pairs ( allplayers ) do
				START=v:GetNWBool("VoteStart")
				if(!v:GetNWBool("VoteStart")) then
					break
				end
			end
			if START then
				g_time=6
				for k,v in pairs ( allplayers ) do
					v:PrintMessage( HUD_PRINTTALK, "All players have voted to start.\n" );
					v:SetNWBool("VoteStart",false)
				end
			end
		end

		
	end
end
function FloodTimeFunc()
	
	if g_time <= 0 then
			TimerStatus = 3
			RaiseWater()
			RemoveAllWeapons()
			GivePistols()
			UnfreezeProps()
			g_time = FIV
			umsg.Start( "floodtime" )
			umsg.String("Sink enemy boats!")
			umsg.End()
			ttime=g_time
			
	end
end
function antipiracy()
	if !TimerStatus==3 then return end
	for k,v in pairs(player.GetAll()) do
		if v:GetNWBool("pirate") then 
			if v:Alive()==false then v:SetNWBool("pirate",false)
			else
				v:TakeDamage(6)
			
				if v:GetPos():Distance(v:GetNWEntity("antip"):GetPos())>87 then
					v:SetNWBool("pirate",false)
				end
			end
		end
	end
end

function collide(ent1,ent2)
	if TimerStatus==3 then 
		if ent1:IsPlayer() and ent2:GetClass()=="prop_physics" then
			if (ent1~=ent2:GetNWEntity("Owner") and (ent1:GetNWInt("T")~=ent2:GetNWEntity("Owner"):GetNWInt("T") or ent1:GetNWInt("T")==1)) then
				if ent1:GetPos():Distance(ent2:GetPos())<70 then
					if ent1:GetNWBool("pirate")==false then
						ent1:ChatPrint("No Pirating is allowed!")
					end
					ent1:SetNWBool("pirate", true)
					ent1:SetNWEntity("antip", ent2)
					return
				end
			end
		end
		if ent2:IsPlayer() and ent1:GetClass()=="prop_physics" then
			if (ent2~=ent1:GetNWEntity("Owner") and (ent2:GetNWInt("T")~=ent1:GetNWEntity("Owner"):GetNWInt("T") or ent2:GetNWInt("T")==1)) then
				if ent2:GetPos():Distance(ent1:GetPos())<70 then
					if ent2:GetNWBool("pirate")==false then
						ent2:ChatPrint("No Pirating is allowed!")
					end
					ent2:SetNWBool("pirate", true)
					ent2:SetNWEntity("antip", ent1)
					return
				end
			end
		end
	end
end
hook.Add("ShouldCollide","collide",collide)


function FightTimeFunc()

	if g_time <= 0 then
		TimerStatus = 4
		LowerWater()
		RemoveAllWeapons()
		GivePhysGuns()
		RecieveBonus()
		ResetHealth()
		g_time = RV
		umsg.Start( "floodtime" )
		umsg.String("Round reseting")
		umsg.End()
	else  
		PayDay()
		if ttime>=g_time+20 then
			blow_up()
			ttime=g_time
		end
	end
end

function ReflectTimeFunc()

	if g_time <= 0 then
		TimerStatus = 1
		g_time = BV
		umsg.Start( "floodtime" )
		umsg.String("Build a boat.")
		umsg.End()
	else  

		RefundProps()
	end	
end

function RaiseWater()

	for k, v in pairs(ents.FindByName("water")) do
		v:Fire("Open","",0)
	end
end

function LowerWater()

	for k, v in pairs(ents.FindByName("water")) do
		v:Fire("Close","",0)
	end
end

function blow_up()
	if TimerStatus!=3 then return end
	for k,v in pairs(ents.FindByClass("prop_physics")) do
		if math.random(1,3)==2 then
			local vPoint = v:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart( vPoint ) -- not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
			util.Effect( "Explosion", effectdata )
			v:Remove()
		end
		
	end
	for k2,v2 in pairs(player.GetAll()) do
		v2:ChatPrint("Money rounds will not be tolerated!")
		rocket(v2)
	end
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount )

	if TimerStatus == 1 or TimerStatus == 4 then
		return false
	else
		
		if ent:IsPlayer() then
			--Rawr
		else
			if attacker:IsPlayer() then
				if attacker:GetActiveWeapon() != nil then
					ent:SetNWInt("PropHealth", ent:GetNWInt("PropHealth") - fm_weapons[attacker:GetActiveWeapon():GetClass()].damage)
				end
				ttime=g_time
			else
				if attacker:GetClass() == "entityflame" then
					ent:SetNWInt("PropHealth", ent:GetNWInt("PropHealth") - .5)
				else
					ent:SetNWInt("PropHealth", ent:GetNWInt("PropHealth") - 1)
				end
			end
			
			if ent:GetNWInt("PropHealth") <= 0 and ent:IsValid() then
				local vPoint = ent:GetPos()
				local effectdata = EffectData()
				effectdata:SetStart( vPoint ) -- not sure if we need a start and origin (endpoint) for this effect, but whatever
				effectdata:SetOrigin( vPoint )
				effectdata:SetScale( 1 )
				util.Effect( "Explosion", effectdata )
				ent:Remove()
			end
		end
	end
end

function GM:Think()
	if TimerStatue == 3 then
		timer.Simple(10,
		function()
			if pl:HasWeapon("gmod_tool") or pl:HasWeapon("weapon_physgun") then
				RemoveAllWeapons()
				GivePistols()
			end
		end)
	end
	SaveProfile()
	FoundWinner()
	
end

